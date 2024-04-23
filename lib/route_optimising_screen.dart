import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RouteOptimisingScreen extends StatefulWidget {
  @override
  _RouteOptimisingScreenState createState() => _RouteOptimisingScreenState();
}

class _RouteOptimisingScreenState extends State<RouteOptimisingScreen> {
  Dio dio = Dio();
  MapController mapController = MapController();
  List<dynamic> routePoints = [];
  LatLng startPoint = LatLng(-0.12070277,51.514156); // Default start point (New York)
  LatLng endPoint = LatLng(-0.12360937,51.507996); // Default end point (Los Angeles)
  LatLng sangliPoint = LatLng(16.8548, 74.5643);
  LatLng mirajPoint = LatLng(16.8206, 74.6451);
  LatLng islampurPoint = LatLng(17.0345, 74.4832);
  // Miraj
  double mirajLat = 16.8206;
  double mirajLng = 74.6451;

// Islampur
  double islampurLat = 17.0345;
  double islampurLng = 74.4832;

// Sangli
  double sangliLat = 16.8548;
  double sangliLng = 74.5643;

// Karad
  double karadLat = 17.2865;
  double karadLng = 74.1990;


  @override
  void initState() {
    _fetchRoutes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Optimising'),
      ),
      body:_buildMap(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchRoutes();
        },
        child: Icon(Icons.directions),
      ),
    );
  }

  Widget _buildMap() {

    return FlutterMap(

      mapController: mapController,
      options: MapOptions(
        center: mirajPoint,
        zoom: 7,
        onMapReady: _buildMarkers,
        onPositionChanged: (MapPosition pos, bool isGesture) {

          // Perform actions once the map is ready
          // For example, load markers here
          _buildMarkers();
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(markers: _buildMarkers()),
        if (routePoints.isNotEmpty)
          PolylineLayer(
            polylineCulling: true,
            polylines: [
              Polyline(
                isDotted: false,
                points: routePoints.map((e) {
                  return LatLng(e.latitude, e.longitude);
                }).toList(),
                color: Colors.blueAccent,
                strokeWidth: 12,
              )
            ],
          ),

      ],

    );
  }

  List<Marker> _buildMarkers() {
    if(routePoints.length == 0){
      return[] ;
    }
    return routePoints.map((location) {
      print(location);
      return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(location.latitude, location.longitude),
        child:const Icon(Icons.location_on, color: Colors.red),
      );
    }).toList();
  }




  Future<void> _fetchRoutes() async {
    final String apiKey = 'pk.bbdcb4a476f696320042ce82b579960b'; // Replace with your LocationIQ API key
    final String url =
        'https://us1.locationiq.com/v1/optimize/driving/${mirajLat},${mirajLng};${sangliLat},${sangliLng};${islampurLat},${islampurLng};${karadLat},${karadLng}?key=$apiKey';
    try {
       print(url);
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final decoded = response.data;
        final List<dynamic> waypoints = decoded['waypoints'];
        for (var waypoint in waypoints) {
          // Access the 'location' object within each waypoint
          List<dynamic> location = waypoint['location'];

          // Extract latitude and longitude values
          double latitude = location[1];
          double longitude = location[0];

          // Create a LatLng object and add it to the list
          setState(() {
            routePoints.add(LatLng(latitude, longitude));
          });


        }

        // if (routes.isNotEmpty) {
        //   final route = routes.first;
        //   List<LatLng> points = [];
        //   for (var step in route['geometry']['coordinates']) {
        //     points.add(LatLng(step[1], step[0]));
        //   }
        //   setState(() {
        //     routePoints = points;
        //   });
        // } else {
        //   print('No routes found');
        // }
      } else {
        print('Failed to fetch routes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching routes: $e');
    }
  }
}
