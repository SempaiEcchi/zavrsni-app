import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/helper/image_picker.dart';
import 'package:firmus/helper/open_settings.dart';
import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/infra/stores/cv_upload_provider.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/profile/edit_pages/_cv_video_editor.dart';
import 'package:firmus/view/pages/profile/profile_edit_options.dart';
import 'package:firmus/view/pages/student_home/widges/home_app_bar.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:firmus/view/shared/popups/anonymous_user_popup.dart';
import 'package:firmus/view/shared/popups/cv_video_player_popup.dart';
import 'package:firmus/view/shared/popups/video_editor_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../models/entity/cv_video.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(studentNotifierProvider).maybeWhen(
        data: (data) => data,
        orElse: () => null,
        skipLoadingOnReload: true,
        skipError: true,
        skipLoadingOnRefresh: true);
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: !user.anon
          ? null
          : () {
              const AnonymousUserPopup().showPopup(context);
            },
      child: IgnorePointer(
        ignoring: user.anon,
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            HapticFeedback.lightImpact();
            return ref.refresh(firmusUserProvider.future);
          },
          child: ListView(
            padding: EdgeInsets.zero,
            // shrinkWrap: true,
            children: [
              UploadedCvsVideos(
                cvs: user.cvVideos.toList()
                  ..sort((a, b) => a.id.compareTo(b.id)),
                uploadingCvs: ref.watch(uploadingVideosProvider),
              ),
              ProfileCard(
                fullName: "${user.first_name} ${user.last_name}",
                email: user.email,
                imageUrl: user.imageUrl,
                percentage: user.profileCompletionPercentage,
              ),
              const SizedBox(
                height: 24,
              ),
              const TopLevelProfileEditOptions(),
              const SizedBox(
                height: 24,
              ),
              PrivacyTOSFooter(),
              FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final packageInfo = snapshot.data as PackageInfo;
                      return Center(
                        child: Text(
                          "Verzija ${packageInfo.version}+${packageInfo.buildNumber}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                      );
                    }
                    return const SizedBox();
                  }),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyTOSFooter extends StatelessWidget {
  const PrivacyTOSFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {
              launchUrlString("https://firmus.hr/tos");
            },
            child: Text(
              "Terms and Conditions",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            )),
        TextButton(
            onPressed: () {
              launchUrlString("https://firmus.hr/privacy");
            },
            child: Text(
              "Privacy Policy",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            )),
      ],
    );
  }
}

class UploadedCvsVideos extends ConsumerWidget {
  final List<StudentCVVid> cvs;
  final List<UploadingCV> uploadingCvs;

  static Future pickVideo(BuildContext context, WidgetRef ref) {
    return handleVideoPick().then((value) async {
      if (value == null) return;
      final croppedVideo = await VideoEditorPopup(
        file: value,
      ).show(context);
      if (croppedVideo == null) return;
      return ref
          .read(studentNotifierProvider.notifier)
          .uploadVideo(croppedVideo);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elems = [
      ...uploadingCvs,
      ...cvs,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Uploadani video CV-ovi',
          style: TextStyle(
            color: Color(0xFF858B94),
            fontSize: 11,
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 75,
              child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
                      ),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: cvs.length + uploadingCvs.length,
                  itemBuilder: (context, index) {
                    //show uploadingCvs first

                    final cv = elems[index];
                    if (cv is UploadingCV) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(
                            height: 57,
                            width: 57,
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(
                              width: 50,
                              height: 50,
                              child: ClipOval(
                                  child: cv.thumbnail == null
                                      ? null
                                      : Image.file(
                                          cv.thumbnail!,
                                          fit: BoxFit.cover,
                                        ))),
                        ],
                      );
                    }

                    if (cv is StudentCVVid) {
                      return PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        itemBuilder: (context) {
                          return options(context, ref, cv);
                        },
                        child: SizedBox(
                          width: 55,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ClipOval(
                                      child: CachedNetworkImage(
                                    imageUrl: cv.thumbnailUrl,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    fit: BoxFit.cover,
                                  ))),
                              Positioned(
                                top: 5,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                      color: FigmaColors.neutralBlack,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return null;
                  }),
            ),
            AnimatedTapButton(
              onTap: () {
                pickVideo(context, ref).catchError((er, st) {
                  FirebaseCrashlytics.instance.recordError(er, st, fatal: true);
                  if (er is PlatformException) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        content: Row(
                          children: [
                            Text(context.loc.galleryPermission),
                            const Spacer(),
                            SmallPrimaryButton(
                                onTap: () {
                                  openSettings();
                                },
                                text: context.loc.openSettings)
                          ],
                        )));
                  }
                });
              },
              child: SizedBox(
                height: 52,
                width: 52,
                child: Center(
                    child: Container(
                        child: Assets.images.addIconPng.image(width: 40))),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 0,
        ),
      ],
    );
  }

  const UploadedCvsVideos({
    super.key,
    required this.cvs,
    required this.uploadingCvs,
  });

  List<PopupMenuEntry> options(
      BuildContext context, WidgetRef ref, StudentCVVid vid) {
    final style = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: Theme.of(context).primaryColor);

    void logEvent(String name) {
      ref.a.logEvent(name: AnalyticsEvent.tap_cv_video_option, parameters: {
        "action": name,
        "video_id": vid.id,
      });
    }

    return [
      PopupMenuItem(
        value: SampleItem.itemOne,
        child: Text(
          'Uredi',
          style: style,
        ),
        onTap: () {
          logEvent("edit");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CvVideoEditor(
                id: vid.id.toString(),
                thumbnail: vid.thumbnailUrl,
                isNew: false,
                jobProfiles: vid.jobProfiles,
              ),
            ),
          );
        },
      ),
      PopupMenuItem(
        value: SampleItem.itemTwo,
        child: Text(
          'Pogledaj',
          style: style,
        ),
        onTap: () {
          logEvent("view");
          Future(() {
            CvVideoPlayerPopup(
              videoUrl: vid.videoUrl,
              thumbnailUrl: vid.thumbnailUrl,
            ).show(context);
          });
        },
      ),
      PopupMenuItem(
        value: SampleItem.itemThree,
        child: Text(
          'Obriši',
          style: style,
        ),
        onTap: () {
          logEvent("delete");
          ref.read(studentNotifierProvider.notifier).deleteVideo(vid);
        },
      ),
    ];
  }
}

enum SampleItem { itemOne, itemTwo, itemThree }

bool _handlingVideoPick = false;

Future<File?> handleVideoPick() async {
  try {
    if (_handlingVideoPick) {
      return Future.error("Already handling video pick");
    }
    _handlingVideoPick = true;
    final video = await pickVideo();
    if (video == null) return null;
    final file = File(video!.path);

    return file;
  } finally {
    _handlingVideoPick = false;
  }
}

// class AdjustSelectedJobProfiles extends HookConsumerWidget {
//   const AdjustSelectedJobProfiles({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final formKey = useMemoized(() => GlobalKey<FormFieldState>());
//
//     return ref.read(selectableJobProfileFrequenciesProvider).when(
//         skipLoadingOnRefresh: true,
//         skipLoadingOnReload: true,
//         data: (jobProfiles) {
//       return Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FormBuilderField<List<SelectedJobProfile>>(
//               key: formKey,
//               onSaved: (List<SelectedJobProfile>? updated) {
//                 if (updated != null) {
//                   ref.read(studentNotifierProvider.notifier).updateJobFrequency(updated);
//                   ref.invalidate(jobOfferStoreProvider);
//                 }
//               },
//               initialValue: jobProfiles,
//               builder: (state) {
//                 final sorted = state.value!.toList()..sort((a, b) => a.jobProfile.name.compareTo(b.jobProfile.name));
//                 return Container(
//                   child: Wrap(
//                       runSpacing: 10,
//                       spacing: 8,
//                       children: sorted.map((e) {
//                         final selected = e.frequency > 0;
//
//                         return SelectableJobProfileChip(
//                             staticTextColor: true,
//                             onTap: () async {
//                               final SelectedJobProfile existing =
//                                   sorted.firstWhere((element) => element.jobProfile.id == e.jobProfile.id);
//
//                               final updated = await JobProfileFrequencyPopup(
//                                 profile: existing,
//                               ).show(context);
//
//                               final List<SelectedJobProfile> updatedState = sorted.toList();
//                               updatedState.remove(existing);
//                               updatedState.add(updated);
//                               state.didChange(updatedState);
//                               formKey.currentState!.save();
//                             },
//                             large: true,
//                             tag: e.jobProfile,
//                             isSelected: selected,
//                             onLongPress: () {
//                               var newState = state.value!.toList();
//                               final index =
//                                   newState.indexWhere((element) => element.jobProfile.id == e.jobProfile.id);
//
//                               if (selected) {
//                                 newState[index] = SelectedJobProfile(jobProfile: e.jobProfile, frequency: 0);
//                               } else {
//                                 newState[index] = SelectedJobProfile(
//                                   jobProfile: e.jobProfile,
//                                 );
//                               }
//
//                               state.didChange(newState);
//                               formKey.currentState!.save();
//                             });
//                       }).toList()),
//                 );
//               },
//               name: 'jobProfiles',
//             ),
//           ],
//         ),
//       );
//     }, error: (e, st) {
//       return Text(e.toString());
//     }, loading: () {
//       logger.info("reloading");
//       return const Center(child: CircularProgressIndicator());
//     });
//   }
// }

class ProfileCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String imageUrl;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        children: [
          basicProfileInfo(context),
          const SizedBox(
            height: 20,
          ),
          const BasicInfoCard(
            text:
                "Za bolju ponuda poslova i povećanje vidljivosti tvojeg profila od strane poslodavaca povećaj postotak ispunjenosti profila",
          )
        ],
      ),
    );
  }

  Row basicProfileInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: 50,
            child: FittedBox(
                child: ProfileAvatarWithPercentage(
              percentage: percentage,
              url: imageUrl,
            ))),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(email),
              Text("${(percentage * 100).toInt()}% popunjenost profila",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // SmallPrimaryButton(
        //   onTap: () {
        //    },
        //   text: 'Pozovi prijatelje',
        // )
      ],
    );
  }

  const ProfileCard({
    super.key,
    required this.fullName,
    required this.email,
    required this.percentage,
    required this.imageUrl,
  });
}

class BasicInfoCard extends StatelessWidget {
  const BasicInfoCard({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: FigmaColors.neutralNeutral5.withOpacity(0.1)),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: "SourceSansPro",
          ).copyWith(
            color: const Color(0xFF858B94),
            fontSize: 11,
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
        ));
  }
}
