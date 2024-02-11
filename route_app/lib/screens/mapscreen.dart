import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:route_app/apis/locationapi.dart';
import 'package:route_app/models/ModelBuspark.dart';
import 'package:bottom_drawer/bottom_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BottomDrawerController bottomDrawerController = BottomDrawerController();
  final MapController mapController = MapController();

  bool locationPermission = false;

  double? currentLatitude;
  double? currentLongitude;
  LatLng? currentCameraPosition;

  double hardLng = 85.28036411474989;
  double hardLat = 27.673482911482175;

  BussPark? from = null;
  BussPark? to = null;

  List<BussPark> busParks = [
    BussPark(
        "Panga Bus Park", const LatLng(27.674679357944573, 85.28010394047544)),
    BussPark(
        "Nagau Bus Park", const LatLng(27.674793820618376, 85.27760680388258)),
    BussPark("Khasi Bazar Bus Park",
        const LatLng(27.677577854400823, 85.27483071755216))
  ];
  List<LatLng> polylinePoints = [];

  var geoloactor = Geolocator();

  // ! Renders bus markers
  List<Marker> renderMarkers() {
    List<Marker> markers = [];
    for (var element in busParks) {
      markers.add(Marker(
          height: 50,
          width: 50,
          point:
              LatLng(element.latandlong.latitude, element.latandlong.longitude),
          child: Stack(
            children: [
              const Icon(
                Icons.circle,
                color: Color.fromARGB(255, 164, 26, 255),
                size: 50,
              ),
              Text(
                element.name,
                style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontSize: 32),
              ),
            ],
          )));
    }
    return markers;
  }

  // ! Gets current position of user
  Future<void> getCurrentPosition() async {
    if (locationPermission) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position pos) {
        if (mounted) {
          setState(() {
            currentLatitude = pos.latitude;
            currentLongitude = pos.longitude;
          });
        }
      }).catchError((error) {
        debugPrint(error);
      });
    }
  }

  List<Widget> fromAndTo() {
    var _from = from;
    var _to = to;

    String nameFrom = "";
    String nameTo = "";

    if (_from != null) {
      nameFrom = _from.name;
    }

    if (_to != null) {
      nameTo = _to.name;
    }

    return [
      Spacer(),
      Text("From: ${nameFrom}"),
      Spacer(),
      Text("To: ${nameTo}"),
      Spacer()
    ];
  }

  BottomDrawer parkSelectorDrawer() {
    return BottomDrawer(
        color: const Color.fromARGB(255, 235, 235, 235),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 60,
              spreadRadius: 5,
              offset: const Offset(2, -6))
        ],
        header: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
          ),
        ),
        body: Center(
          child: Expanded(
            child: Column(
              children: [
                Text("Select your bus park"),
                Row(
                  children: fromAndTo(),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var _busPark = busParks[index];
                    return ListTile(
                      leading: TextButton(
                        child: const Text("Add to From"),
                        onPressed: () {
                          setState(() {
                            from = _busPark;

                            if (polylinePoints.length == 0) {
                              polylinePoints.add(_busPark.latandlong);
                            } else {
                              polylinePoints[0] = _busPark.latandlong;
                            }
                          });
                        },
                      ),
                      title: Text(_busPark.name),
                      trailing: TextButton(
                        child: const Text("Add to To"),
                        onPressed: () {
                          setState(() {
                            to = _busPark;
                            if (polylinePoints.length > 1) {
                              polylinePoints[1] = _busPark.latandlong;
                            } else {
                              polylinePoints.add(_busPark.latandlong);
                            }
                          });
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: busParks.length,
                )
              ],
            ),
          ),
        ),
        headerHeight: 30.0,
        drawerHeight: 500.0,
        controller: bottomDrawerController);
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();

      // Getting location permissions
      handleLocationPermission().then((value) {
        locationPermission = value;
        if (!value) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Location service denied")));
        }
      });

      // Getting current position
      getCurrentPosition().then((value) {
        mapController.move(LatLng(hardLat, hardLng), 18.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.move(LatLng(hardLat, hardLng), 24.0);
        },
        child: const Text("Reposition"),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: const MapOptions(
              initialCenter: LatLng(0, 0),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: renderMarkers()),
              PolylineLayer(polylines: [
                Polyline(
                    points: polylinePoints, color: Colors.blue, strokeWidth: 5)
              ])
            ],
          ),
          const Center(
              child: Padding(
            padding: EdgeInsets.only(bottom: 14.0),
            child: Icon(Icons.location_pin),
          )),
          parkSelectorDrawer()
        ],
      ),
    );
  }
}
