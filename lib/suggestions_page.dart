import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SuggestionsPage extends StatefulWidget {
  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  // List of saved places with name and address
  final List<Map<String, String>> savedPlaces = [
    {'name': 'CN Tower', 'address': '290 Bremner Blvd, Toronto, ON'},
    {'name': 'Royal Ontario Museum', 'address': '100 Queens Park, Toronto, ON'},
    {'name': 'Toronto Islands', 'address': 'Toronto Islands, Toronto, ON'},
    {'name': 'Casa Loma', 'address': '1 Austin Terrace, Toronto, ON'},
    {'name': 'Distillery District', 'address': '55 Mill St, Toronto, ON'}
  ];

  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _placeAddressController = TextEditingController();

  // Add a new place with name and address
  void _addPlace() {
    final newName = _placeNameController.text;
    final newAddress = _placeAddressController.text;

    if (newName.isNotEmpty && newAddress.isNotEmpty) {
      setState(() {
        savedPlaces.add({'name': newName, 'address': newAddress});
      });
      _placeNameController.clear();
      _placeAddressController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suggestions',
          style: TextStyle(
            fontFamily: 'Teko',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saved Places',
              style: TextStyle(
                fontFamily: 'Teko',
                fontWeight: FontWeight.bold,
                color: isLightTheme ? Colors.black : Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: savedPlaces.length,
                itemBuilder: (context, index) {
                  final place = savedPlaces[index];
                  return Card(
                    color: isLightTheme ? Colors.white : Colors.grey[800],
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        place['name'] ?? 'Unknown Place',
                        style: TextStyle(
                          color: isLightTheme ? Colors.black : Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        place['address'] ?? 'Unknown Address',
                        style: TextStyle(
                          color: isLightTheme ? Colors.black54 : Colors.white70,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NearbyPlacesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  foregroundColor: isLightTheme ? Colors.black : Colors.white,
                  backgroundColor: isLightTheme ? Colors.white : Colors.black,
                  side: BorderSide(
                      color: isLightTheme ? Colors.black : Colors.white),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: const Text('Nearby Places'),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor:
                            isLightTheme ? Colors.white : Color(0xFF8B7D5B),
                        title: Text(
                          'Add a New Place',
                          style: TextStyle(
                            color: isLightTheme ? Colors.black : Colors.white,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _placeNameController,
                              decoration: InputDecoration(
                                hintText: 'Enter place name',
                                hintStyle: TextStyle(
                                  color: isLightTheme
                                      ? Colors.black54
                                      : Colors.white54,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _placeAddressController,
                              decoration: InputDecoration(
                                hintText: 'Enter place address',
                                hintStyle: TextStyle(
                                  color: isLightTheme
                                      ? Colors.black54
                                      : Colors.white54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color:
                                    isLightTheme ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _addPlace,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isLightTheme ? Colors.blue : Colors.blueGrey,
                            ),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                color:
                                    isLightTheme ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  foregroundColor: isLightTheme ? Colors.black : Colors.white,
                  backgroundColor: isLightTheme ? Colors.white : Colors.black,
                  side: BorderSide(
                      color: isLightTheme ? Colors.black : Colors.white),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: const Text('Add New Place'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NearbyPlacesPage extends StatefulWidget {
  const NearbyPlacesPage({super.key});

  @override
  _NearbyPlacesPageState createState() => _NearbyPlacesPageState();
}

class _NearbyPlacesPageState extends State<NearbyPlacesPage> {
  List<dynamic> nearbyPlaces = [];
  bool isLoading = true;
  String errorMessage = '';

  final String foursquareApiKey =
      "fsq3GOZ7uhN/MS2jobaLIO0xPFO8b5M7gVzLp3YK79MmSU0=";

  @override
  void initState() {
    super.initState();
    _fetchNearbyPlaces();
  }

  Future<void> _fetchNearbyPlaces() async {
    try {
      Position position = await _determinePosition();
      double latitude = position.latitude;
      double longitude = position.longitude;

      String url =
         'https://api.foursquare.com/v3/places/nearby?ll=$latitude,$longitude&radius=5000&limit=20';
      //String url =
        //  'https://api.foursquare.com/v3/places/search?ll=$latitude,$longitude&categories=19014&radius=5000&limit=20';


      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": foursquareApiKey,
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['results'] != null) {
          Set<dynamic> allPlaces = {};

          for (var place in data['results']) {
            allPlaces.add(place);
          }

          setState(() {
            nearbyPlaces = allPlaces.toList();
            isLoading = false;
          });
        }
      } else {
        throw 'Failed to load data with status code ${response.statusCode}';
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
        isLoading = false;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied';
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nearby Places to Eat, Shop & Explore',
          style: TextStyle(
            fontFamily: 'Teko',
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black54
                          : Colors.white70,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: nearbyPlaces.length,
                  itemBuilder: (context, index) {
                    var place = nearbyPlaces[index];
                    String name = place['name'] ?? 'Unknown Name';
                    String address =
                        place['location']?['address'] ?? 'Unknown Address';
                    String category = place['categories'] != null
                        ? place['categories'][0]['name'] ?? 'Unknown Category'
                        : 'Unknown Category';

                    return ListTile(
                      title: Text(
                        name,
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '$category\n$address',
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black54
                                  : Colors.white70,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}