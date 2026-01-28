# update_db_2fa.py
import asyncio
from sqlalchemy import text
from app.db.database import AsyncSessionLocal

async def add_2fa_columns():
    async with AsyncSessionLocal() as db:
        print("🔧 Adding 2FA columns to users table...")
        try:
            await db.execute(text("ALTER TABLE users ADD COLUMN IF NOT EXISTS is_2fa_enabled BOOLEAN DEFAULT FALSE;"))
            await db.execute(text("ALTER TABLE users ADD COLUMN IF NOT EXISTS otp_hash VARCHAR(255);"))
            await db.execute(text("ALTER TABLE users ADD COLUMN IF NOT EXISTS otp_expires_at TIMESTAMP;"))
            await db.commit()
            print("✅ Success! 2FA columns added.")
        except Exception as e:
            print(f"❌ Error: {e}")

if __name__ == "__main__":
    asyncio.run(add_2fa_columns())