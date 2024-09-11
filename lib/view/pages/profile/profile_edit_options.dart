import 'package:firmus/infra/keep_alive.dart';
import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/infra/stores/job_creation_notifier.dart';
import 'package:firmus/infra/stores/notification_controller.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/registration_image_cropper.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/form/full_screen_list_selector.dart';
import 'package:firmus/view/shared/popups/generic_action_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'notificatio_control.dart';

final _expandableControllerProvider =
    Provider.family.autoDispose<ExpandedTileController, String>((ref, id) {
  keepAlive(ref);
  final controller = ExpandedTileController();

  ref.onDispose(() {
    controller.dispose();
    ref.invalidateSelf();
  });
  return controller;
});

class TopLevelProfileEditOptions extends ConsumerStatefulWidget {
  const TopLevelProfileEditOptions({super.key});

  @override
  ConsumerState<TopLevelProfileEditOptions> createState() =>
      _ProfileEditOptionsState();
}

class _ProfileEditOptionsState
    extends ConsumerState<TopLevelProfileEditOptions> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            const ExpandedTileWrapper(
              text: 'Uredi profil podatke',
              content: BasicProfileOptions(),
            ),
            ExpandedTileWrapper(
              text: 'Uredi CV',
              onTap: () {
                GoRouter.of(context).push(RoutePaths.cvEdit);
              },
            ),
            ExpandedTileWrapper(
                leading: ref
                            .watch(notificationController)
                            .valueOrNull
                            ?.permanentlyDenied ??
                        false
                    ? Icon(
                        Icons.warning,
                        color: Theme.of(context).colorScheme.error,
                      )
                    : null,
                text: 'Notifikacije',
                content: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: NotificationControl(),
                )),
            ExpandedTileWrapper(
              text: 'Podesi preferencije',
              onTap: () {
                GoRouter.of(context).push(RoutePaths.preferencesEdit);
              },
            ),
            ExpandedTileWrapper(
              text: 'Obriši račun',
              onTap: () async {
                var shouldDelete = await GenericRationalePopup(
                  title: 'Želiš li obrisati Firmus račun?',
                ).show(context);

                if (shouldDelete != true) return;

                ref
                    .read(studentNotifierProvider.notifier)
                    .deleteAccount()
                    .then((_) {
                  GoRouter.of(context)
                      .pushAndRemoveUntil(RoutePaths.onboarding);
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Greška prilikom brisanja računa, pokušajte preko weba."),
                  ));
                });
              },
            ),
            ExpandedTileWrapper(
              text: 'Odjavi se',
              trailing:
                  Icon(Icons.logout, color: Theme.of(context).disabledColor),
              onTap: () async {
                showLoadingDialog(context);
                ref
                    .read(studentNotifierProvider.notifier)
                    .logout()
                    .then((value) {
                  GoRouter.of(context)
                      .pushAndRemoveUntil(RoutePaths.onboarding);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BasicProfileOptions extends ConsumerWidget {
  const BasicProfileOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langs = ref.watch(languagesProvider);
    return Column(
      children: [
        ExpandedTileWrapper(
          text: 'Osnovni podaci',
          onTap: () {
            GoRouter.of(context).push(RoutePaths.profileEdit);
          },
        ),
        ExpandedTileWrapper(
          text: 'Lokacija',
          onTap: () {
            GoRouter.of(context).push(RoutePaths.locationEdit);
          },
        ),
        ExpandedTileWrapper(
          text: 'Bio',
          onTap: () {
            GoRouter.of(context).push(RoutePaths.bioEdit);
          },
        ),
        // ExpandedTileWrapper(
        //   text: 'Fakultet',
        //   onTap: () {
        //     GoRouter.of(context).push(RoutePaths.universityEdit);
        //   },
        // ),
        ExpandedTileWrapper(
          text: 'Jezici',
          onTap: () {
            FullScreenListSelector<String>(
              initialSelectedItems:
                  ref.read(studentNotifierProvider).requireValue.languages,
              initialItems: langs.valueOrNull ?? [],
              title: "Jezik",
              subtitle: "Odaberite jezik",
              onAddNewItem: (query) async {
                return query;
              },
              onSave: (List<String> selectedItems) async {
                return ref
                    .read(studentNotifierProvider.notifier)
                    .updateLanguages(selectedItems.map((e) => e).toList());
              },
            ).show(context);
          },
        ),
      ],
    );
  }
}

class ExpandedTileWrapper extends ConsumerWidget {
  final String text;
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tile = ExpandedTile(
      onTap: () {
        _logAnalytics(ref);
      },
      theme: theme,
      trailing: trailing ?? icon,
      leading: leading,
      title: Text(text),
      content: content ?? Container(),
      controller: controller(ref),
    );

    if (onTap != null) {
      return AnimatedTapButton(
          onTap: () {
            _logAnalytics(ref);
            onTap!();
          },
          child: AbsorbPointer(absorbing: true, child: tile));
    }
    return tile;
  }

  void _logAnalytics(WidgetRef ref) {
    ref.a
        .logEvent(name: AnalyticsEvent.tap_profile_setting_option, parameters: {
      "option": text,
    });
  }

  ExpandedTileController controller(ref) {
    return ref.watch(_expandableControllerProvider(text));
  }

  const ExpandedTileWrapper({
    super.key,
    required this.text,
    this.onTap,
    this.content,
    this.trailing,
    this.leading,
  });
}

const theme = ExpandedTileThemeData(
  headerRadius: 0,
  contentBackgroundColor: Colors.white,
  headerColor: Colors.white,
  contentRadius: 0,
  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
  headerPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
);
const icon = Icon(
  Icons.arrow_forward_ios,
  size: 16,
  color: FigmaColors.neutralNeutral6,
);
