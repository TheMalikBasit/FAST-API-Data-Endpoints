import asyncio
import random
from datetime import datetime
from uuid import UUID

# Import standard DB connection that the FastAPI app uses
from sqlalchemy.future import select
from app.db.database import AsyncSessionLocal
from app.models.camera import Camera
from app.models.violation import Violation
from app.models.capabilities import OrganizationCapability

TARGET_ORG_ID = UUID("16f28877-4fc0-467e-98f9-d4dfb7acafc2")


async def seed_today_violations():
    async with AsyncSessionLocal() as db:
        print(f"🔗 Executing inside Docker container...")
        print(f"🔍 Searching for Organization: {TARGET_ORG_ID}...")

        stmt_cameras = select(Camera).where(Camera.organization_id == TARGET_ORG_ID)
        cameras = (await db.execute(stmt_cameras)).scalars().all()

        if not cameras:
            print("❌ No cameras found for this organization! Cannot generate violations.")
            return

        stmt_capabilities = select(OrganizationCapability).where(
            OrganizationCapability.organization_id == TARGET_ORG_ID)
        capabilities = (await db.execute(stmt_capabilities)).scalars().all()

        if not capabilities:
            print("❌ No AI capabilities found for this organization!")
            return

        print(f"✅ Found {len(cameras)} cameras and {len(capabilities)} AI capabilities.")
        print("⏳ Generating 20 violations for today...")

        violations = []
        now = datetime.utcnow()

        for _ in range(20):
            cam = random.choice(cameras)
            cap = random.choice(capabilities)

            random_hour = random.randint(0, now.hour)
            random_minute = random.randint(0, 59)
            event_time = now.replace(hour=random_hour, minute=random_minute, second=random.randint(0, 59))

            v = Violation(
                organization_id=TARGET_ORG_ID,
                camera_id=cam.id,
                timestamp_utc=event_time,
                violation_type=cap.object_code,
                severity=random.choice(["Low", "Medium", "High", "Critical"]),
                is_false_positive=random.choices([True, False], weights=[0.05, 0.95])[0],
                is_resolved=random.choice([True, False]),
                snapshot_url="placeholder.jpg",
                person_track_id=f"track_today_{random.randint(1000, 9999)}",
                duration_seconds=random.uniform(2.0, 45.0)
            )
            violations.append(v)

        db.add_all(violations)
        await db.commit()
        print("✅ Successfully added 20 violations for today!")


if __name__ == "__main__":
    asyncio.run(seed_today_violations())