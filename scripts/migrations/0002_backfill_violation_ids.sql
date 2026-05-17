-- Convert violation IDs from UUID to INC-<LOCATION><YYYYMMDD_HH24MISSUS>.
-- Atomic: wrapped in a transaction; aborts on any error.
-- Run once, after deploying the Python model change (Violation.id String,
-- NotificationLog.ref_id String).

BEGIN;

-- 1. Stage new column on violations.
ALTER TABLE violations ADD COLUMN new_id VARCHAR(64);

-- 2. Compute new IDs, resolving collisions with a numeric suffix.
WITH base AS (
    SELECT v.id AS old_id,
           'INC-' ||
             COALESCE(
               NULLIF(substring(trim(both '_' from regexp_replace(upper(c.location), '[^A-Z0-9]+', '_', 'g')) FROM 1 FOR 20), ''),
               NULLIF(substring(trim(both '_' from regexp_replace(upper(c.name), '[^A-Z0-9]+', '_', 'g')) FROM 1 FOR 20), ''),
               'UNKNOWN'
             ) ||
             to_char(v.timestamp_utc, 'YYYYMMDD_HH24MISSUS') AS base_id
      FROM violations v
      JOIN cameras c ON v.camera_id = c.id
),
numbered AS (
    SELECT old_id, base_id,
           row_number() OVER (PARTITION BY base_id ORDER BY old_id) AS rn
      FROM base
)
UPDATE violations v
   SET new_id = CASE WHEN n.rn = 1 THEN n.base_id ELSE n.base_id || '_' || n.rn END
  FROM numbered n
 WHERE v.id = n.old_id;

-- 3. Flip notification_log.ref_id from UUID to varchar so it can hold the new
--    string IDs. Cast existing values so non-violation refs (digest run IDs)
--    survive as stringified UUIDs.
ALTER TABLE notification_log
    ALTER COLUMN ref_id TYPE VARCHAR(64) USING ref_id::text;

-- 4. Repoint ref_ids that previously referenced violations to the new INC- IDs.
UPDATE notification_log nl
   SET ref_id = v.new_id
  FROM violations v
 WHERE nl.ref_id IS NOT NULL
   AND nl.ref_id = v.id::text;

-- 5. Swap the primary key on violations.
ALTER TABLE violations DROP CONSTRAINT violations_pkey;
ALTER TABLE violations DROP COLUMN id;
ALTER TABLE violations RENAME COLUMN new_id TO id;
ALTER TABLE violations ALTER COLUMN id SET NOT NULL;
ALTER TABLE violations ADD PRIMARY KEY (id);

COMMIT;
