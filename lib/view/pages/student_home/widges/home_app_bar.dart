import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/infra/stores/company_notifier.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/infra/stores/notification_list_controller.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/models/user_type.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/chats/controllers/chat_page_controller.dart';
import 'package:firmus/view/pages/employer_home_swiper/controller/student_swipe_controller.dart';
import 'package:firmus/view/pages/student_home/home_page.dart';
import 'package:firmus/view/pages/student_home/widges/view_type_selector.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/popups/anonymous_user_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeAppBar extends ConsumerStatefulWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends ConsumerState<HomeAppBar> {
  final shareKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firmusUserProvider).valueOrNull;
    if (user == null) return const _StudentAppBar();

    ref.read(notificationListController);
    ref.read(chatsControllerProvider);

    return user.userType.when(
      company: () => const _CompanyAppBar(),
      student: () => const _StudentAppBar(),
      admin: () => const SizedBox(),
    );
  }
}

class _CompanyAppBar extends ConsumerWidget {
  const _CompanyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    return ref.watch(companyNotifierProvider).maybeWhen(
        skipLoadingOnReload: true,
        skipError: true,
        skipLoadingOnRefresh: true,
        data: (data) => SizedBox(
              height: 58,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      AnimatedTapButton(
                        onTap: () {},
                        child: ProfileAvatarWithPercentage(
                          url: data.logoUrl,
                          percentage: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text("${(1 * 100).toInt()}%",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Theme.of(context).primaryColor)),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ref.watch(currentPageProvider) == HomePages.swiper &&
                            ref.watch(selectedJobProvider) != null
                        ? HomeViewTypeSelector(
                            onSelected: (HomeViewType type) {
                              if (ref.read(selectedJobProvider) != null) {
                                ref
                                    .read(swipableStudentsProvider(
                                            ref.read(selectedJobProvider)!.id)
                                        .notifier)
                                    .changeViewType(type);
                              }
                            },
                            initialType: ref.read(jobHomeViewType),
                          )
                        : currentPage == HomePages.notifications
                            ? Text("NOTIFIKACIJE",
                                style: Theme.of(context).textTheme.bodyLarge!)
                            : AnimatedTapButton(
                                child: GestureDetector(
                                    onTap: () {
                                      ref.invalidate(swipableStudentsProvider);
                                      ref
                                          .read(currentPageProvider.notifier)
                                          .changePage(HomePages.swiper);
                                    },
                                    child: Assets.images.landingLogo
                                        .image(height: 24)),
                              ),
                  ),
                  const BuildNotificationsButton(),
                ],
              ),
            ),
        orElse: () => const SizedBox.shrink());
  }
}

class _StudentAppBar extends ConsumerWidget {
  const _StudentAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    return ref.watch(studentNotifierProvider).maybeWhen(
        skipLoadingOnReload: true,
        skipError: true,
        skipLoadingOnRefresh: true,
        data: (data) => SizedBox(
              height: 58,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      AnimatedTapButton(
                        onTap: () {
                          if (data.anon) {
                            const AnonymousUserPopup().showPopup(context);
                          } else {
                            GoRouter.of(context).push(RoutePaths.profileEdit);
                          }
                        },
                        child: ProfileAvatarWithPercentage(
                          url: data.imageUrl,
                          percentage: data.profileCompletionPercentage,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                          "${(data.profileCompletionPercentage * 100).toInt()}%",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Theme.of(context).primaryColor)),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: currentPage == HomePages.swiper
                        ? HomeViewTypeSelector(
                            onSelected: (HomeViewType type) {
                              ref
                                  .read(jobOfferStoreProvider.notifier)
                                  .changeViewType(type);
                            },
                            initialType: ref.read(jobHomeViewType),
                          )
                        : currentPage == HomePages.notifications
                            ? Text("NOTIFIKACIJE",
                                style: Theme.of(context).textTheme.bodyLarge!)
                            : AnimatedTapButton(
                                child: GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(currentPageProvider.notifier)
                                          .changePage(HomePages.swiper);

                                      ref.refresh(jobOfferStoreProvider);
                                      // LikeTutorialPopup().show(context);
                                      // ref.invalidate(jobOfferStoreProvider);
                                      // GoRouter.of(context).push(RoutePaths.home);
                                    },
                                    child: Assets.images.landingLogo
                                        .image(height: 24)),
                              ),
                  ),
                  const BuildNotificationsButton()
                ],
              ),
            ),
        orElse: () => const SizedBox.shrink());
  }
}

class BuildNotificationsButton extends ConsumerStatefulWidget {
  const BuildNotificationsButton({
    super.key,
  });

  @override
  ConsumerState<BuildNotificationsButton> createState() =>
      _BuildNotificationsButtonState();
}

class _BuildNotificationsButtonState
    extends ConsumerState<BuildNotificationsButton> {
  late HomePages _previous = ref.read(currentPageProvider);

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(currentPageProvider) == HomePages.notifications;
    return GestureDetector(
      onTap: () async {
        if (selected) {
          ref.read(currentPageProvider.notifier).changePage(_previous);
        } else {
          _previous = ref.read(currentPageProvider);
          ref
              .read(currentPageProvider.notifier)
              .changePage(HomePages.notifications);
        }
      },
      child: CircleAvatar(
        radius: 21,
        backgroundColor: Colors.white,
        child: Icon(
          selected ? Icons.clear : Icons.notifications_none_rounded,
          color: FigmaColors.neutralNeutral4,
        ),
      ),
    );
  }
}

class ProfileAvatarWithPercentage extends StatelessWidget {
  final String url;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 21.0,
      backgroundColor: Colors.white,
      lineWidth: 3.0,
      percent: percentage,
      center: ClipOval(
        child: SizedBox(
          width: 36,
          height: 36,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressColor: Theme.of(context).primaryColor,
    );
  }

  const ProfileAvatarWithPercentage({
    super.key,
    required this.url,
    required this.percentage,
  });
}
