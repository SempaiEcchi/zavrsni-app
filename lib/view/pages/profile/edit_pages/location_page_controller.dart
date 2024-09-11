import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/view/pages/profile/edit_pages/location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

final locationPageControllerProvider = AsyncNotifierProvider.autoDispose<
    LocationPageController, LocationPageState>(() {
  return LocationPageController();
});

class LocationPageState extends Equatable {
  final String currentLocation;
  final LatLng currentLatLng;

  const LocationPageState({
    required this.currentLocation,
    required this.currentLatLng,
  });

  @override
  List<Object?> get props => [currentLocation, currentLatLng];
}

class LocationPageController
    extends AutoDisposeAsyncNotifier<LocationPageState> {
  final controller = MapController();
  Location location = Location();

  HttpService get httpService => ref.read(httpServiceProvider);

  @override
  Future<LocationPageState> build() async {
    return _getInitialLocation();
  }

  Future<LocationPageState> _getInitialLocation() {
    final savedLatLng = ref.read(studentNotifierProvider).requireValue.location;
    if (savedLatLng != null) {
      Future(() {
        controller.move(savedLatLng, 13);
      });
      return _forLatLng(savedLatLng);
    }
    return _forLatLng(kPulaLocation);
  }

  Future<void> refreshLocationName() async {
    state = const AsyncLoading();

    final latLng = controller.camera.center;
    try {
      final result = await _forLatLng(latLng);
      if (latLng == controller.camera.center) state = AsyncData(result);
    } catch (e, st) {
      if (latLng == controller.camera.center) state = AsyncError(e, st);
    }
  }


  Future<LocationPageState> _forLatLng(LatLng latLng) async {
    // open maps api response
    dynamic locationResp;

 
    try {
      locationResp = await httpService.request(LocationHttpRequest(latLng),
          converter: defaultConverter);
    } catch (e) {
      locationResp = await httpService.request(LocationHttpRequest(latLng),
          converter: defaultConverter);
    }

    // street name + number + city
    final address = (locationResp["address"] as Map);
    String loc = address["city"] ??
        address["village"] ??
        address["town"] ??
        address["county"] ??
        address["state"] ??
        address["country"] ??
        locationResp["display_name"] ??
        "Unknown";

    return LocationPageState(
      currentLocation: loc.toString(),
      currentLatLng: latLng,
    );
  }

  Future<void> centerOnCurrentLocation() async {
    final permission = await Permission.location.request();
    debugPrint(permission.toString());
    if (permission.isGranted) {
      await location.changeSettings(accuracy: LocationAccuracy.low);
      await location.requestService();
      final currentLocation = await location.getLocation();
      controller.move(
          LatLng(currentLocation.latitude!, currentLocation.longitude!), 13);
      refreshLocationName();
    } else {
      throw Exception(100);
    }
  }
}

class LocationHttpRequest extends BaseHttpRequest {
  LocationHttpRequest(LatLng latLng)
      : super(
          endpoint:
              'https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude}&lon=${latLng.longitude}&format=json',
          type: RequestType.get,
          contentType: Headers.jsonContentType,
        );

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
