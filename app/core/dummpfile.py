from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

test_password = "12345"   # or "admin123"
hashed_password = pwd_context.hash(test_password)

print(hashed_password)

# from passlib.context import CryptContext
#
# pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
#
# # Use the hash you inserted into the DB (from your attached image)
# db_hash = "$2b$12$jDQnJM5vVEZuDhWZu235weYKgNZwHulTD9q6J1IkhE6Wr4ZDVVJJG"
#
# # Use the exact password string you are sending from the frontend
# test_password = "556727"
#
# # This MUST print True for the login to work.
# print(f"Verification Result: {pwd_context.verify(test_password, db_hash)}")