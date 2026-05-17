"""Human-readable incident IDs for violations.

Format: INC-<LOCATION><YYYYMMDD_HHMMSSffffff>
Example: INC-WAREHOUSE_A20260517_143022123456
"""
import re
from datetime import datetime

_LOC_MAX_LEN = 20
_INVALID_LOC_CHARS = re.compile(r"[^A-Z0-9]+")


def _sanitize_location(raw: str | None) -> str:
    if not raw:
        return ""
    cleaned = _INVALID_LOC_CHARS.sub("_", raw.upper()).strip("_")
    return cleaned[:_LOC_MAX_LEN]


def generate_violation_id(camera, ts: datetime) -> str:
    """Build an incident-style ID from a Camera row and a UTC timestamp.

    Falls back to camera.name when camera.location is null/blank. If both are
    empty, uses 'UNKNOWN'.
    """
    loc = _sanitize_location(getattr(camera, "location", None)) \
        or _sanitize_location(getattr(camera, "name", None)) \
        or "UNKNOWN"
    stamp = ts.strftime("%Y%m%d_%H%M%S%f")
    return f"INC-{loc}{stamp}"
