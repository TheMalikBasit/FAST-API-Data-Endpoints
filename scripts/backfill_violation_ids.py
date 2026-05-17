"""Backfill violation IDs from UUID to INC-<LOCATION><DateTime> format.

Run ONCE after deploying the model change (Violation.id String, NotificationLog.ref_id String).
Wrap in a single transaction — aborts on any error so the DB is never left half-migrated.

Prerequisite: take a pg_dump backup before running.

Usage:
    python -m scripts.backfill_violation_ids
"""
import asyncio
from collections import defaultdict
from sqlalchemy import text

from app.db.database import engine, AsyncSessionLocal
from app.utils.violation_id import generate_violation_id


async def run() -> None:
    async with engine.begin() as conn:
        # 1. Stage: add new_id column to violations.
        await conn.execute(text("ALTER TABLE violations ADD COLUMN new_id VARCHAR(64)"))

        # 2. Pull every violation joined to its camera.
        rows = (await conn.execute(text(
            "SELECT v.id::text AS old_id, v.timestamp_utc, c.location, c.name "
            "FROM violations v JOIN cameras c ON v.camera_id = c.id"
        ))).all()

        # 3. Compute new IDs; resolve collisions with a numeric suffix.
        class _Camera:
            __slots__ = ("location", "name")
            def __init__(self, location, name):
                self.location = location
                self.name = name

        seen: dict[str, int] = defaultdict(int)
        mapping: list[tuple[str, str]] = []  # (old_id, new_id)
        for old_id, ts, location, name in rows:
            camera = _Camera(location, name)
            base = generate_violation_id(camera, ts)
            seen[base] += 1
            new_id = base if seen[base] == 1 else f"{base}_{seen[base]}"
            mapping.append((old_id, new_id))

        # 4. Write new_id back row-by-row (parameterized to dodge SQL injection
        #    through camera names/locations).
        for old_id, new_id in mapping:
            await conn.execute(
                text("UPDATE violations SET new_id = :nid WHERE id::text = :oid"),
                {"nid": new_id, "oid": old_id},
            )

        # 5. Repoint notification_log.ref_id (UUID-typed today) to the new strings.
        #    Because ref_id will become String(64) in step 6, we first need to
        #    flip its type, but we can use a CTE to map values atomically.
        await conn.execute(text(
            "ALTER TABLE notification_log ALTER COLUMN ref_id TYPE VARCHAR(64) USING ref_id::text"
        ))
        for old_id, new_id in mapping:
            await conn.execute(
                text("UPDATE notification_log SET ref_id = :nid WHERE ref_id = :oid"),
                {"nid": new_id, "oid": old_id},
            )

        # 6. Swap the primary key on violations.
        await conn.execute(text("ALTER TABLE violations DROP CONSTRAINT violations_pkey"))
        await conn.execute(text("ALTER TABLE violations DROP COLUMN id"))
        await conn.execute(text("ALTER TABLE violations RENAME COLUMN new_id TO id"))
        await conn.execute(text("ALTER TABLE violations ALTER COLUMN id SET NOT NULL"))
        await conn.execute(text("ALTER TABLE violations ADD PRIMARY KEY (id)"))

        print(f"Backfilled {len(mapping)} violation IDs.")


if __name__ == "__main__":
    asyncio.run(run())
