class PredictionPlaceModel {
  final String? businessStatus;
  final String? address;
  final String? placeId;
  final double? lat;
  final double? lng;
  final String? icon;
  final String? iconBgColor;
  final String? name;
  final List<PlacePhoto> photos;
  final num? rating;
  final List<String> types;
  PredictionPlaceModel({
    this.name,
    this.address,
    this.businessStatus,
    this.icon,
    this.iconBgColor,
    this.lat,
    this.lng,
    required this.photos,
    this.placeId,
    this.rating,
    required this.types,
  });

  factory PredictionPlaceModel.fromJson(Map<String, dynamic> json) =>
      PredictionPlaceModel(
        photos: (json['photos'] is List)
            ? (json['photos'] as List)
                .map((e) => PlacePhoto.fromJson(e))
                .toList()
            : [],
        types: (json['types'] is List)
            ? (json['types'] as List).map((e) => e.toString()).toList()
            : [],
        name: json['name'],
        address: json['formatted_address'],
        businessStatus: json['business_status'],
        icon: json['icon'],
        iconBgColor: json['icon_background_color'],
        lat: json['geometry']['location']['lat'],
        lng: json['geometry']['location']['lng'],
        placeId: json['place_id'],
        rating: json['rating'],
      );
}

class PlacePhoto {
  final num? height;
  final num? width;
  final String? reference;
  PlacePhoto({this.height, this.reference, this.width});

  factory PlacePhoto.fromJson(Map<String, dynamic> json) => PlacePhoto(
        height: json['height'],
        width: json['width'],
        reference: json['photo_reference'],
      );
}
