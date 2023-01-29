import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:placify/core/config.dart';
import 'package:placify/core/model/place_prediction_model.dart';
import 'package:placify/core/utils/helpers.dart';
import 'package:placify/presentations/components/place_types.dart';

class PlaceDetailsView extends StatelessWidget {
  const PlaceDetailsView({super.key, required this.place});
  final PredictionPlaceModel place;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final images = place.photos;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text(
          "Place Details",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: images.isEmpty
                  ? AppKeys.placeImageHolderUrl
                  : Helpers.getPhotoUrlFromPlacePhoto(images.first),
              height: size.height * .5,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            place.name ?? "Unknown Place",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            place.address ?? "Unknown Address",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (place.types.isNotEmpty) ...[
            const SizedBox(
              height: 15,
            ),
            const Text("Types",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                )),
            const SizedBox(
              height: 8,
            ),
            PlaceTypes(
              types: place.types,
            ),
          ],
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
