import asyncio
from uuid import uuid4
from sqlalchemy import select, delete
from app.db.database import AsyncSessionLocal
from app.models.user import User
from app.models.capabilities import OrganizationCapability

# Define the standard objects your ML model can detect
DEFAULT_CAPABILITIES = [
    {"code": "no_helmet", "name": "No Helmet", "is_ppe": True},
    {"code": "no_vest", "name": "No Safety Vest", "is_ppe": True},
    {"code": "fire_hazard", "name": "Fire / Smoke", "is_ppe": False},
    {"code": "restricted_area", "name": "Restricted Area Intrusion", "is_ppe": False},
    {"code": "phone_usage", "name": "Mobile Phone Usage", "is_ppe": False},
]


async def seed_capabilities():
    async with AsyncSessionLocal() as db:
        print("🌱 Seeding Organization Capabilities...")

        # 1. Get the Admin User to find the Organization ID
        # (Assuming you are using the admin email we created earlier)
        stmt = select(User).where(User.email == "admin@apex.com")
        result = await db.execute(stmt)
        admin = result.scalars().first()

        if not admin:
            print("❌ Admin user not found. Please run init_dummy_data.py first.")
            return

        org_id = admin.organization_id
        print(f"🏢 Found Organization ID: {org_id}")

        # 2. Clear existing capabilities to avoid duplicates
        await db.execute(delete(OrganizationCapability).where(OrganizationCapability.organization_id == org_id))

        # 3. Insert Defaults
        for cap in DEFAULT_CAPABILITIES:
            new_cap = OrganizationCapability(
                organization_id=org_id,
                object_code=cap["code"],
                display_name=cap["name"],
                is_ppe=cap["is_ppe"]
            )
            db.add(new_cap)

        await db.commit()
        print(f"✅ Successfully added {len(DEFAULT_CAPABILITIES)} capabilities.")


if __name__ == "__main__":
    asyncio.run(seed_capabilities())