-- 0001_add_camera_deleted_at.sql
--
-- Adds the soft-delete column to cameras. Required because the API uses
-- Base.metadata.create_all() at startup, which only creates missing tables
-- and never alters existing ones. Run this once against any pre-existing DB
-- (skip for fresh DBs spun up after the model change — create_all picks it up).
--
-- Apply via Adminer (http://localhost:8080) or psql:
--   docker compose exec db psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
--     -f /docker-entrypoint-initdb.d/0001_add_camera_deleted_at.sql

ALTER TABLE cameras
    ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ NULL;

CREATE INDEX IF NOT EXISTS ix_cameras_deleted_at
    ON cameras (deleted_at);
