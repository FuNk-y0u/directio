from inc import *
from models import *

def get_stations():
    stations = busStation.query.all()

    res = {
        "stations":[]
    }

    for station in stations:
        res["stations"][-1] = {
            "Name": station.Name,
            "Lat": station.Lat,
            "Lng": station.Lng
        }

    return jsonify(
        res
    )