// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GoogleMapScreen extends StatefulWidget {
//   static const routeName = 'GoogleMapScreen';
//   @override
//   _GoogleMapScreenState createState() => _GoogleMapScreenState();
// }

// class _GoogleMapScreenState extends State<GoogleMapScreen> {
//   GoogleMapController _controller;
//   final CameraPosition _initialPosition =
//       CameraPosition(target: LatLng(30.1575, 71.5249));
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('GoogleMap'),
//       ),
//       body: GoogleMap(
//         mapToolbarEnabled: true,
//         initialCameraPosition: _initialPosition,
//         mapType: MapType.normal,
//         onMapCreated: (controller) {
//           setState(() {
//             _controller = controller;
//           });
//         },
//         onTap: (cordinates) {
//           _controller.animateCamera(CameraUpdate.newLatLng(cordinates));
//         },
//       ),
//     );
//   }
// }
