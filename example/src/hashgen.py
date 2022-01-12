import bcrypt


def handler(event, context):
    return {
        "hash": bcrypt.hashpw(
            event["password"].encode("utf-8"), bcrypt.gensalt(rounds=10)
        ).decode("utf-8")
    }
