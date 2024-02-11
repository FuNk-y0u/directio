from models import *
from inc import *
from init import app

def gen():
    with app.app_context():
        db.create_all()

if __name__ == "__main__":
    gen()