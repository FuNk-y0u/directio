from inc import *

db = SQLAlchemy()

class busStation(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String(100))
    Lat = db.Column(db.String(100))
    Lng = db.Column(db.String(100))

class latnlongs(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    Lat = db.Column(db.String(100))
    Lng = db.Column(db.String(100))
    