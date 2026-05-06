"""Token-signed unsubscribe links — uses SECRET_KEY, no DB lookup needed to verify."""
from itsdangerous import URLSafeSerializer, BadSignature
from app.core.config import settings

_serializer = URLSafeSerializer(settings.SECRET_KEY, salt="notif-unsub")


def make_token(user_id: str) -> str:
    return _serializer.dumps({"u": str(user_id)})


def verify_token(token: str) -> str | None:
    try:
        data = _serializer.loads(token)
        return data.get("u")
    except BadSignature:
        return None


def unsubscribe_url(user_id: str) -> str:
    token = make_token(user_id)
    return f"{settings.API_PUBLIC_URL}/api/v1/notifications/unsubscribe?token={token}"
