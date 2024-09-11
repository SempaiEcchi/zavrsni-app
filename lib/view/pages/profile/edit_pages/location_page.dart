import 'package:firmus/helper/open_settings.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/view/pages/profile/edit_pages/location_page_controller.dart';
import 'package:firmus/view/pages/registration/registration_image_cropper.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../onboarding/pick_registation_type.dart';

const kPulaLocation = LatLng(44.8683, 13.8481);

class LocationEditPage extends ConsumerStatefulWidget {
  const LocationEditPage({super.key});

  @override
  ConsumerState createState() => _LocationEditPageState();
}

class _LocationEditPageState extends ConsumerState<LocationEditPage> {
  bool _loadingCurrent = false;

  @override
  Widget build(BuildContext context) {
    final controller =
        ref.watch(locationPageControllerProvider.notifier).controller;
    final data = ref.watch(locationPageControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: FirmusAppBar(
        onPressed: () {
          GoRouter.of(context).pop();
        },
        text: 'Lokacija',
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBody(
          center: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 52.0, top: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FlutterMap(
                        options: MapOptions(
                            initialCenter: kPulaLocation,
                            onMapEvent: (event) {
                              if (event is MapEventMoveEnd ||
                                  event is MapEventFlingAnimationEnd) {
                                ref
                                    .read(
                                        locationPageControllerProvider.notifier)
                                    .refreshLocationName();
                              }
                            }),
                        mapController: controller,
                        nonRotatedChildren: [
                          Center(
                              child: Icon(Icons.add,
                                  color: Theme.of(context).primaryColor,
                                  size: 40)),
                          Align(
                            alignment: Alignment.topRight,
                            child: AnimatedTapButton(
                              onTap: () {
                                if (_loadingCurrent) return;
                                setState(() {
                                  _loadingCurrent = true;
                                });
                                ref
                                    .read(
                                        locationPageControllerProvider.notifier)
                                    .centerOnCurrentLocation()
                                    .whenComplete(() {
                                  setState(() {
                                    _loadingCurrent = false;
                                  });
                                }).catchError((err) {
                                  if (err.toString() == "100" ||
                                      err is PlatformException) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            content: Row(
                                              children: [
                                                Text(
                                                    "Dozvolite pristup lokaciji u postavkama."),
                                                const Spacer(),
                                                SmallPrimaryButton(
                                                    onTap: () {
                                                      openSettings();
                                                    },
                                                    text: context
                                                        .loc.openSettings)
                                              ],
                                            )));
                                  }
                                });
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 16, right: 16),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _loadingCurrent
                                    ? Container(
                                        width: 24,
                                        height: 24,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: CircularProgressIndicator(),
                                        ))
                                    : Icon(
                                        Icons.navigation_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                              ),
                            ),
                          )
                        ],
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            retinaMode: true,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              data.hasError
                                  ? "Nije pronađena lokacjia"
                                  : data.valueOrNull?.currentLocation ?? "",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: "SourceSansPro",
                                color: Colors.black,
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                height: 1.52,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          PrimaryButton(
                              onTap: () {
                                if (data.hasError) return;
                                showLoadingDialog(context);
                                ref
                                    .read(studentNotifierProvider.notifier)
                                    .updateUserLocation(
                                        controller.camera.center,
                                        data.requireValue.currentLocation)
                                    .then((v) => GoRouter.of(context).popPop());
                              },
                              text: "Spremi lokaciju"),
                          const SizedBox(
                            height: 12,
                          ),
                          AnimatedTapButton(
                            onTap: () {
                              GoRouter.of(context).pop();
                            },
                            child: SizedBox(
                              width: double.infinity,
                              height: 36,
                              child: Center(
                                child: Text(
                                  "Odustani",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Theme.of(context).disabledColor,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
