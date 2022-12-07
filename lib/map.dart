import 'package:api_connection/popup.dart';

import 'detection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

Marker createMarker(Detection my_detection) {
  return Marker(
      point: LatLng(my_detection.lat, my_detection.long),
      builder: (_) => const Icon(Icons.location_on, size: 40),
      width: 40,
      height: 40,
      anchorPos: AnchorPos.align(AnchorAlign.top));
}

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

final PopupController _popupLayerController = PopupController();

class _MyMapState extends State<MyMap> {
  List<Detection> detectionObjects = [];
  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          zoom: 5.0,
          center: LatLng(35.102165, 31.533894),
          onTap: (_, __) => _popupLayerController
              .hideAllPopups(), // Hide popup when the map is tapped.
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 2))
                  .asyncMap((event) => getDetection()),
              builder: (context, snapshot) {
                if (snapshot.data.toString() != "[]" &&
                    snapshot.data.toString() != "null") {
                  String data = snapshot.data as String;
                  Map<String, dynamic> dataMap = jsonDecode(data)[0];
                  detectionObjects.add(Detection.fromJson(dataMap));
                  markers = detectionObjects
                      .map((object) => createMarker(object))
                      .toList();
                }
                return PopupMarkerLayerWidget(
                  options: PopupMarkerLayerOptions(
                    popupController: _popupLayerController,
                    markers: markers,
                    markerRotateAlignment:
                        PopupMarkerLayerOptions.rotationAlignmentFor(
                            AnchorAlign.top),
                    popupBuilder: (BuildContext context, Marker marker) =>
                        ExamplePopup(marker),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
