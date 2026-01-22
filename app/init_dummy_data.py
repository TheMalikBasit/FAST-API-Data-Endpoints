import asyncio
import random
from datetime import datetime, timedelta
from uuid import uuid4
from passlib.context import CryptContext

# Import your app modules
from app.db.database import AsyncSessionLocal
from app.models.user import User
from app.models.device import Device, Organization
from app.models.camera import Camera, CameraRule
from app.models.violation import Violation

# Setup password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


async def init_data():
    async with AsyncSessionLocal() as db:
        print("🌱 Starting Dummy Data Generation...")

        # 1. Create Organization
        # FIX: Removed 'is_active', added 'status="Active"' to match your table
        org_id = uuid4()
        org = Organization(
            id=org_id,
            name="Apex Industries Ltd.",
            status="Active"
        )
        db.add(org)

        # 2. Create Global Admin User
        # FIX: Changed 'hashed_password' to 'password_hash' to match your table
        admin_user = User(
            email="admin@apex.com",
            password_hash=pwd_context.hash("admin123"),
            username="admin",  # Added username just in case, though usually optional if nullable
            role="GlobalAdmin",
            organization_id=org_id,
            is_active=True  # valid for users table
        )
        db.add(admin_user)

        # 3. Create Edge Device
        device_id = uuid4()
        device = Device(
            id=device_id,
            organization_id=org_id,
            name="Edge-Server-01",
            device_token_secret="dummy_token_secret_value",
            status="Online",
            last_heartbeat=datetime.utcnow()
        )
        db.add(device)

        # 4. Create Cameras (Rooms)
        camera_names = ["Warehouse A", "Assembly Line", "Chemical Storage", "Main Entrance", "Loading Dock"]
        cameras = []
        for name in camera_names:
            cam_id = uuid4()
            cam = Camera(
                id=cam_id,
                organization_id=org_id,
                device_id=device_id,
                name=name,
                rtsp_url=f"rtsp://192.168.1.{random.randint(10, 99)}/stream",
                status="Online",
                local_timezone="UTC"
            )

            # Add Rules for the camera
            rule = CameraRule(
                camera_id=cam_id,
                active_rules={"helmet": {"required": True, "severity": "Critical"},
                              "vest": {"required": True, "severity": "High"}},
                is_active=True
            )

            db.add(cam)
            db.add(rule)
            cameras.append(cam)

        await db.commit()
        print("✅ Org, User, Device, and Cameras created.")

        # 5. Generate Violations (History for last 30 days)
        print("⏳ Generating 30 days of violation history...")
        violation_types = ["no_helmet", "no_vest", "restricted_area", "fire_hazard"]

        violations = []
        now = datetime.utcnow()

        for day in range(30):
            # Generate 5-15 violations per day
            date_cursor = now - timedelta(days=day)
            daily_count = random.randint(5, 15)

            for _ in range(daily_count):
                cam = random.choice(cameras)
                v_type = random.choice(violation_types)

                # Logic to make data look realistic
                if v_type == "no_helmet":
                    severity = "Critical"
                elif v_type == "no_vest":
                    severity = "High"
                else:
                    severity = "Medium"

                v = Violation(
                    organization_id=org_id,
                    camera_id=cam.id,
                    timestamp_utc=date_cursor.replace(hour=random.randint(8, 18), minute=random.randint(0, 59)),
                    violation_type=v_type,
                    severity=severity,
                    is_false_positive=False,
                    is_resolved=random.choice([True, False]),
                    snapshot_url="https://via.placeholder.com/150",
                    duration_seconds=random.uniform(5.0, 120.0)
                )
                violations.append(v)

        db.add_all(violations)
        await db.commit()
        print(f"✅ Successfully inserted {len(violations)} violations.")
        print("\n🎉 DONE! Login details: admin@apex.com / admin123")


if __name__ == "__main__":
    asyncio.run(init_data())