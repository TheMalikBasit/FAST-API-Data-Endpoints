# app/core/email.py
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig, MessageType
from pydantic import EmailStr
import os

# CONFIGURATION (Load these from .env in real production)
conf = ConnectionConfig(
    MAIL_USERNAME=os.getenv("MAIL_USERNAME", "your_email@gmail.com"),
    MAIL_PASSWORD=os.getenv("MAIL_PASSWORD", "your_app_password"),
    MAIL_FROM=os.getenv("MAIL_FROM", "your_email@gmail.com"),
    MAIL_PORT=587,
    MAIL_SERVER="smtp.gmail.com",
    MAIL_STARTTLS=True,
    MAIL_SSL_TLS=False,
    USE_CREDENTIALS=True,
    VALIDATE_CERTS=True
)


async def send_2fa_email(email: EmailStr, code: str):
    """Sends the 6-digit OTP to the user."""

    html = f"""
    <html>
        <body>
            <div style="font-family: Arial, sans-serif; padding: 20px;">
                <h2>Security Verification</h2>
                <p>Your verification code for Little Angels Dashboard is:</p>
                <h1 style="color: #2563EB; letter-spacing: 5px;">{code}</h1>
                <p>This code expires in 5 minutes.</p>
                <p>If you did not request this, please ignore this email.</p>
            </div>
        </body>
    </html>
    """

    message = MessageSchema(
        subject="Your Login Verification Code",
        recipients=[email],
        body=html,
        subtype=MessageType.html
    )

    fm = FastMail(conf)
    await fm.send_message(message)