"""fastapi-mail bootstrap shared by all notification kinds."""
from pathlib import Path
from fastapi_mail import FastMail, ConnectionConfig

from app.core.config import settings

TEMPLATE_DIR = Path(__file__).parent / "templates"

mail_conf = ConnectionConfig(
    MAIL_USERNAME=settings.MAIL_USERNAME,
    MAIL_PASSWORD=settings.MAIL_PASSWORD,
    MAIL_FROM=settings.MAIL_FROM or settings.MAIL_USERNAME,
    MAIL_FROM_NAME=settings.MAIL_FROM_NAME,
    MAIL_PORT=settings.MAIL_PORT,
    MAIL_SERVER=settings.MAIL_SERVER,
    MAIL_STARTTLS=True,
    MAIL_SSL_TLS=False,
    USE_CREDENTIALS=True,
    VALIDATE_CERTS=True,
    TEMPLATE_FOLDER=TEMPLATE_DIR,
)

fast_mail = FastMail(mail_conf)
