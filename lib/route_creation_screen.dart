import 'package:flutter/material.dart';

class RouteCreationForm extends StatefulWidget {
  @override
  _RouteCreationFormState createState() => _RouteCreationFormState();
}

class _RouteCreationFormState extends State<RouteCreationForm> {
  final TextEditingController _routeNameController = TextEditingController();
  final TextEditingController _startingLocationController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final List<TextEditingController> _waypointControllers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Creation Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _routeNameController,
              decoration: InputDecoration(labelText: 'Route Name'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _startingLocationController,
              decoration: InputDecoration(labelText: 'Starting Location'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: 'Destination'),
            ),
            SizedBox(height: 20),
            Text('Waypoints:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _waypointControllers.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _waypointControllers[index],
                        decoration: InputDecoration(labelText: 'Waypoint ${index + 1}'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          _waypointControllers.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _waypointControllers.add(TextEditingController());
                });
              },
              child: Text('Add Waypoint'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Save route data
                String routeName = _routeNameController.text;
                String startingLocation = _startingLocationController.text;
                String destination = _destinationController.text;
                List<String> waypoints = _waypointControllers.map((controller) => controller.text).toList();

                // Process route data (e.g., save to database)
                // Then navigate to the next screen or perform further actions
              },
              child: Text('Save Route'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _routeNameController.dispose();
    _startingLocationController.dispose();
    _destinationController.dispose();
    _waypointControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}