import asyncio
import random
from datetime import datetime, timedelta
from uuid import uuid4
from passlib.context import CryptContext

from app.db.database import AsyncSessionLocal
from app.models.user import User
from app.models.device import Device, Organization
from app.models.camera import Camera, CameraRule
from app.models.violation import Violation
from app.models.capabilities import OrganizationCapability
from sqlalchemy import text

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

CUSTOM_CAPABILITIES = [
    {"code": "no_mask", "name": "No Face Mask", "is_ppe": True},
    {"code": "no_medical_coat", "name": "No Medical Coat", "is_ppe": True},
    {"code": "no_gloves", "name": "No Medicated Gloves", "is_ppe": True},
    {"code": "no_cap", "name": "No Head Cover Cap", "is_ppe": True},
    {"code": "smoking", "name": "Smoking Detected", "is_ppe": False},
]


async def seed_data():
    async with AsyncSessionLocal() as db:
        print("🌱 Starting Custom Data Seeding...")

        # 0. Clean Slate (Optional: Truncate tables to avoid duplicates if re-running)
        print("🧹 Clearing old data...")
        await db.execute(text("TRUNCATE TABLE violations, cameras, users, organizations CASCADE;"))

        # 1. Create Organization
        org_id = uuid4()
        org_name = "MediSafe Hospital"
        print(f"🏥 Creating Organization: {org_name}")

        org = Organization(id=org_id, name=org_name, status="Active")
        db.add(org)

        # 2. Create Admin
        admin_email = "admin@medisafe.com"
        admin_user = User(
            email=admin_email,
            password_hash=pwd_context.hash("admin123"),
            username="Dr. Admin",
            role="GlobalAdmin",
            organization_id=org_id,
            is_active=True,
            phone_number="+1234567890"
        )
        db.add(admin_user)

        # 3. Create Device
        device_id = uuid4()
        device = Device(
            id=device_id,
            organization_id=org_id,
            name="Main-Hospital-Server",
            device_token_secret="secure_token_xyz",
            status="Online",
            last_heartbeat=datetime.utcnow()
        )
        db.add(device)
        await db.flush()

        # 4. Capabilities
        for cap in CUSTOM_CAPABILITIES:
            new_cap = OrganizationCapability(
                organization_id=org_id,
                object_code=cap["code"],
                display_name=cap["name"],
                is_ppe=cap["is_ppe"]
            )
            db.add(new_cap)

        # ---------------------------------------------------------
        # 5. Create Cameras (MULTIPLE PER ROOM)
        # ---------------------------------------------------------
        print("📷 Creating Cameras with Locations...")
        rooms = ["ICU Entrance", "Surgical Ward", "Medicine Storage", "Staff Cafeteria", "Lobby"]
        cameras = []

        for room_name in rooms:
            # Create 2 cameras for each room to demonstrate aggregation
            for i in range(1, 3):
                cam_id = uuid4()
                cam_name = f"{room_name.split(' ')[0]}-Cam-0{i}"  # e.g., ICU-Cam-01

                cam = Camera(
                    id=cam_id,
                    organization_id=org_id,
                    device_id=device_id,
                    name=cam_name,  # <--- Specific Camera Name
                    location=room_name,  # <--- Common Room Name (Grouping Key)
                    rtsp_url=f"rtsp://192.168.1.{random.randint(10, 99)}/stream",
                    status="Online",
                    local_timezone="UTC"
                )

                rule = CameraRule(
                    camera_id=cam_id,
                    active_rules={cap["code"]: {"required": True, "severity": "High"} for cap in CUSTOM_CAPABILITIES},
                    is_active=True
                )

                db.add(cam)
                db.add(rule)
                cameras.append(cam)

        await db.flush()

        # 6. Violations
        print("⏳ Generating 30 days of violations...")
        violations = []
        now = datetime.utcnow()

        severity_map = {"no_mask": "Critical", "no_medical_coat": "High", "no_gloves": "Critical", "no_cap": "Medium",
                        "smoking": "Critical"}

        for day in range(30):
            date_cursor = now - timedelta(days=day)
            daily_count = random.randint(15, 30)

            for _ in range(daily_count):
                cam = random.choice(cameras)
                violation_obj = random.choice(CUSTOM_CAPABILITIES)
                v_code = violation_obj["code"]

                v = Violation(
                    organization_id=org_id,
                    camera_id=cam.id,
                    timestamp_utc=date_cursor.replace(hour=random.randint(7, 20), minute=random.randint(0, 59)),
                    violation_type=v_code,
                    severity=severity_map.get(v_code, "Medium"),
                    is_false_positive=random.choices([True, False], weights=[0.1, 0.9])[0],
                    is_resolved=random.choice([True, False]),
                    snapshot_url="https://via.placeholder.com/150",
                    duration_seconds=random.uniform(5.0, 60.0)
                )
                violations.append(v)

        db.add_all(violations)
        await db.commit()
        print("✅ Data Seeded Successfully!")


if __name__ == "__main__":
    asyncio.run(seed_data())