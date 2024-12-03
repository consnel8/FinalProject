import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class SimilarOutfitsPage extends StatefulWidget {
  final String outfitImageUrl;

  SimilarOutfitsPage({required this.outfitImageUrl});

  @override
  _SimilarOutfitsPageState createState() => _SimilarOutfitsPageState();
}

class _SimilarOutfitsPageState extends State<SimilarOutfitsPage> {
  List<Map<String, dynamic>> nearbyStores = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNearbyStores(5000); // Default: 5 miles radius
  }

  Future<void> _fetchNearbyStores(int radius) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final position = await _determinePosition();
      final latitude = position.latitude;
      final longitude = position.longitude;

      const String apiKey = "fsq3z3ZH5r8gtaMWUOCX2LZozL1yTVlwRikRFYRZOAVkB7U=";
      final String url = "https://api.foursquare.com/v3/places/search?ll=$latitude,$longitude&categories=17030,17033,17038,17039,17040,17041,17043,17044,17045,17046,17052,17047,17048,17049,17050,17051&radius=$radius&limit=20";

      //"https://api.foursquare.com/v3/places/search?ll=$latitude,$longitude&categories=19014&radius=$radius&limit=20";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": apiKey,
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        setState(() {
          nearbyStores = results.map((place) {
            return {
              "name": place['name'] ?? 'Unknown',
              "address": place['location']?['address'] ?? 'Unknown Address',
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch stores: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        errorMessage = "Error: $error";
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
      throw 'Location permissions are permanently denied.';
    }

    return await Geolocator.getCurrentPosition();
  }

  Widget _buildDistanceFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRadiusButton(5000, "5 Miles"),
        const SizedBox(width: 10),
        _buildRadiusButton(10000, "10 Miles"),
        const SizedBox(width: 10),
        _buildRadiusButton(20000, "20 Miles"),
      ],
    );
  }

  Widget _buildRadiusButton(int radius, String label) {
    return ElevatedButton(
      onPressed: () => _fetchNearbyStores(radius),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Stores for Similiar Items"),
      ),
      body: Column(
        children: [
          // Current Outfit Image
          AspectRatio(
            aspectRatio: 3 / 2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.outfitImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildDistanceFilterButtons(),
          const SizedBox(height: 10),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : ListView.builder(
              itemCount: nearbyStores.length,
              itemBuilder: (context, index) {
                final store = nearbyStores[index];
                return ListTile(
                  leading: const Icon(Icons.store, color: Colors.black),
                  title: Text(store['name']!),
                  subtitle: Text(store['address']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}







