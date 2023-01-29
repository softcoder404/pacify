import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:placify/core/utils/helpers.dart';

import '../../core/config.dart';
import '../../core/model/place_prediction_model.dart';

class CustomMarkerWindow extends StatelessWidget {
  const CustomMarkerWindow({
    super.key,
    required this.place,
    this.onViewDetails,
  });
  final PredictionPlaceModel place;
  final VoidCallback? onViewDetails;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                  width: 70,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey),
                      color: Helpers.getColorFromHexString(
                          place.iconBgColor ?? "#FFFFFF"),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          place.icon ?? AppKeys.defaultIconUrl,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name ?? "Unknown Place",
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        place.address ?? "Unknown Address",
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          InkWell(
            onTap: onViewDetails,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.teal, borderRadius: BorderRadius.circular(4)),
              alignment: Alignment.center,
              child: Text(
                "View Details",
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
