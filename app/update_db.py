import asyncio
from sqlalchemy import text
from app.db.database import AsyncSessionLocal

async def add_phone_column():
    async with AsyncSessionLocal() as db:
        print("🔧 Adding phone_number column to users table...")
        try:
            # PostgreSQL command to add the missing column
            await db.execute(text("ALTER TABLE users ADD COLUMN IF NOT EXISTS phone_number VARCHAR(255);"))
            await db.commit()
            print("✅ Success! 'phone_number' column added.")
        except Exception as e:
            print(f"❌ Error: {e}")

if __name__ == "__main__":
    asyncio.run(add_phone_column())