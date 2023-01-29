import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:placify/core/config.dart';
import 'package:placify/core/model/place_prediction_model.dart';
import 'package:placify/core/services/location_services.dart';
import 'package:placify/presentations/place_details_view.dart';

import 'components/custom_marker_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  Set<Marker> markers = <Marker>{};
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  _getCurrentPosition() async {
    final currentLocation = await LocationService.getCurrentPosition();
    final cameraPosition = CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 19.151926040649414,
    );
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _onPlaceChanges(String value) async {
    if (value.length < 4) return;

    _customInfoWindowController.hideInfoWindow!();
    final result = await LocationService.getPlacesAutoComplete(value);
    if (!result.success) {
      return;
    }
    final places = result.data as List<PredictionPlaceModel>;
    markers.clear();
    LatLng? latLng;
    double avgLat = 0;
    double avgLng = 0;

    for (var place in places) {
      LatLng latLng = LatLng(place.lat ?? 0, place.lng ?? 0);
      Marker marker = Marker(
          markerId: MarkerId(place.placeId.toString()),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: latLng,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              CustomMarkerWindow(
                place: place,
                onViewDetails: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => PlaceDetailsView(place: place)),
                  );
                },
              ),
              latLng,
            );
          });
      markers.add(marker);
      avgLat += place.lat ?? 0;
      avgLng += place.lng ?? 0;
    }
    avgLat = avgLat / places.length;
    avgLng = avgLng / places.length;
    latLng = LatLng(avgLat, avgLng);
    final c = await _controller.future;

    c.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 12)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        //fit: StackFit.expand,
        children: [
          //render map box
          GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            markers: markers,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _customInfoWindowController.googleMapController = controller;
              _getCurrentPosition();
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: MediaQuery.of(context).size.height * .15,
            width: MediaQuery.of(context).size.width * .75,
            offset: 50,
          ),
          Positioned(
            top: 60,
            left: 15,
            right: 15,
            child: Card(
              elevation: 2,
              color: Colors.white,
              child: TextFormField(
                onChanged: _onPlaceChanges,
                decoration: const InputDecoration(
                  fillColor: Colors.transparent,
                  filled: true,
                  border: InputBorder.none,
                  hintText: "Search for places e.g hotels, restaurants",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }
}
