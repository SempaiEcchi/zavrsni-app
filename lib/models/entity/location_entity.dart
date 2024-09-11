class LocationEntity {
  final double lat;
  final double lng;

  const LocationEntity({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  factory LocationEntity.fromMap(Map<String, dynamic> map) {
    var x = map["location"]["coordinates"] as List;
    return LocationEntity(
      lat: x.last as double,
      lng: x.first as double,
    );
  }
}
