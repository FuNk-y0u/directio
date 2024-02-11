from inc import *
from init import app

from views.view_aimodel import ai_model
from views.view_getpath import get_path
from views.view_getstation import get_stations

app.add_url_rule("/ai", view_func=ai_model, methods=["POST"])
app.add_url_rule("/get_path", view_func=get_path, methods=["POST"])
app.add_url_rule("/get_stations", view_func=get_stations, methods=["POST"])

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8000, debug=True)