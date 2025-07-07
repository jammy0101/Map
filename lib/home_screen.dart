import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(32.986111, 70.604164),
    zoom: 14,
  );



  List<Marker> marker = [];
  List<Marker> list = [
    Marker(
        markerId: MarkerId('1'),
      position: LatLng(32.986111, 70.604164),
      infoWindow: InfoWindow(
        title: 'My current Location',
      ),
    ),
    // Marker(
    //   markerId: MarkerId('2'),
    //   position: LatLng(1.9979, 21.6001),
    //   infoWindow: InfoWindow(
    //     title: 'Another Location',
    //   ),
    // ),
    // Marker(
    //   markerId: MarkerId('3'),
    //   position: LatLng(20.5937, 21.6001),
    //   infoWindow: InfoWindow(
    //     title: 'india Location',
    //   ),
    // ),
  ];

  loadData(){
    getUserCurrentLocation().then((value) async {
      print('My current location');
      print(value.latitude.toString() +""+ value.longitude.toString());

      marker.add(
        Marker(
          markerId: MarkerId('2'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: InfoWindow(
            title: 'My current location',
          ),
        ),
      );
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final GoogleMapController controller = await  _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {

      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marker.addAll(list);
    loadData();
  }

 Future<Position>   getUserCurrentLocation()async{
  await  Geolocator.requestPermission().then((value){

  }).onError((error,stackTrace){
    print('Error : ${error.toString()}');
  });
  return await Geolocator.getCurrentPosition();
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          markers: Set<Marker>.of(marker),
          myLocationEnabled: false,
          compassEnabled: false,
          onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: ()async{
           // GoogleMapController controller = await _controller.future;
           // controller.animateCamera(CameraUpdate.newCameraPosition(
           //     CameraPosition(
           //         target: LatLng(20.5937, 21.6001),
           //       zoom: 14,
           //     ),
           // ));
           // setState(() {
           //
           // });

          },
        child: Icon(Icons.location_disabled_outlined),
      ),
    );
  }
}
