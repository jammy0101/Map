import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ConvertLatLangToAddress extends StatefulWidget {
  const ConvertLatLangToAddress({super.key});

  @override
  State<ConvertLatLangToAddress> createState() =>
      _ConvertLatLangToAddressState();
}

class _ConvertLatLangToAddressState extends State<ConvertLatLangToAddress> {
  String address = '';
  String coordinates = '';
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google MAP'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    32.986111,
                    70.604164,
                  );

                  if (placemarks.isNotEmpty) {
                    Placemark place = placemarks.first;
                    setState(() {
                      address =
                          "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.street}, ${place.postalCode}";
                    });
                  }
                } catch (e) {
                  print("Error: $e");
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "LatLng to Address",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(
              address,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            TextField(
              controller: addressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter address',
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                String inputAddress = addressController.text.trim();
                if (inputAddress.isEmpty) return;

                try {
                  List<Location> locations = await locationFromAddress(
                    inputAddress,
                  );
                  if (locations.isNotEmpty) {
                    setState(() {
                      coordinates =
                          "Latitude: ${locations.first.latitude}, Longitude: ${locations.first.longitude}";
                    });
                  }
                } catch (e) {
                  print("Error: $e");
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Address to LatLng",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            Text(
              coordinates,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
