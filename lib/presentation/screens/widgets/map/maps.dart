import 'dart:async';
import 'dart:math' show Random, asin, cos, sqrt;

import 'package:eigital_test/constants/constants.dart';
import 'package:eigital_test/logic/cubit/is_visible_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late LatLng _latLng;
  late PointLatLng _pointLatLng;
  late Position _position;
  final Completer<GoogleMapController> _mapController = Completer();
  final List<double> _destLatLngList = [];
  bool _isLoading = true;
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  double totalDistance = 0.0;
  double _destLat = 0.0;
  double _destLng1 = 0.0;
  double _destLng2 = 0.0;
  double _destLng3 = 0.0;
  double _randLng = 0.0;
  String _placeDistance = "0.0";

  @override
  void initState() {
    _getUserLocation();
    super.initState();
  }

  // MAIN RENDER
  @override
  Widget build(BuildContext context) {
    return BlocProvider<IsVisibleCubit>(
      create: (context) => IsVisibleCubit(),
      child: Stack(
        children: [
          _renderMap(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DISTANCE: $_placeDistance km'),
                Builder(builder: (context) {
                  return Visibility(
                    visible: context.select(
                        (IsVisibleCubit cubit) => cubit.state.isVisible),
                    child: RawMaterialButton(
                      fillColor: Colors.blue,
                      onPressed: () {
                        Random rand = Random();
                        context.read<IsVisibleCubit>().visible();
                        setState(() {
                          _destLat = _position.latitude.toPrecision(2);
                          _destLng1 = _position.longitude.toPrecision(2);
                          _destLng2 = _position.longitude.toPrecision(2) + 0.01;
                          _destLng3 =
                              _position.longitude.toPrecision(2) + 0.002;
                          _destLatLngList
                              .addAll([_destLng1, _destLng2, _destLng3]);
                          _randLng = _destLatLngList[
                              rand.nextInt(_destLatLngList.length)];
                        });
                        _getPolyline(_destLat, _randLng);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'RANDOM ROUTE',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderMap() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : GoogleMap(
            initialCameraPosition: CameraPosition(target: _latLng, zoom: 15.0),
            onMapCreated: (controller) => _mapController.complete(controller),
            myLocationEnabled: true,
            markers: _createMarker(_destLat, _randLng),
            polylines: Set<Polyline>.of(polylines.values),
          );
  }

  // add markers to map
  Set<Marker> _createMarker(double lat, double lng) {
    return {
      Marker(
        markerId: const MarkerId('marker1'),
        position: _latLng,
        infoWindow: const InfoWindow(title: 'Current location'),
      ),
      Marker(
        markerId: const MarkerId('marker2'),
        position: LatLng(lat, lng),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(90),
      ),
    };
  }

  // get the current location of user
  Future<Position> _locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // get the current location of user
  void _getUserLocation() async {
    Random rand = Random();

    try {
      _position = await _locateUser();
      setState(() {
        _isLoading = false;
        _latLng = LatLng(_position.latitude, _position.longitude);
        _pointLatLng = PointLatLng(_position.latitude, _position.longitude);
      });
    } catch (e) {
      print('USER LOCATION ERROR: $e');
    }
  }

  // generating the list of coordinates to be used for drawing the polylines
  void _getPolyline(double lat, double lng) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Constants.apiKey,
      _pointLatLng,
      PointLatLng(lat, lng),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        _calculateDistance();
      }
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      color: Colors.blue,
    );
    polylines[id] = polyline;
    setState(() {});
  }

// Formula for calculating distance between two coordinates
// https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _calculateDistance() {
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    // storing the calculated total distance of the route
    setState(() {
      _placeDistance = totalDistance.toStringAsFixed(2);
      print('DISTANCE: $_placeDistance km');
    });
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
