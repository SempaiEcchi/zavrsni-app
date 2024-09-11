import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/helper/warmup_provider.dart';
import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/infra/stores/notification_handler.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/main.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/admin/pages/admin_home.dart';
import 'package:firmus/view/pages/chats/chats_page.dart';
import 'package:firmus/view/pages/employeer_home/company_active_job_list.dart';
import 'package:firmus/view/pages/employer_home_swiper/controller/student_swipe_controller.dart';
import 'package:firmus/view/pages/employer_home_swiper/job_based_swiper_page.dart';
import 'package:firmus/view/pages/employer_profile/employer_profile_page.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/student_home/job_list.dart';
import 'package:firmus/view/pages/student_home/saved_jobs_page.dart';
import 'package:firmus/view/pages/student_home/widges/home_app_bar.dart';
import 'package:firmus/view/pages/student_home/widges/view_type_selector.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/popups/anonymous_user_popup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infra/stores/notification_controller.dart';
import '../../../models/user_type.dart';
import '../job_op_creation/pick_creation_type_popup.dart';
import '../notifications/notifications_page.dart';
import '../profile/profile_page.dart';
import 'swiping_page.dart';

class HomePageNavigationController extends AutoDisposeNotifier<HomePages> {
  void changePage(HomePages page) {

    HapticFeedback.lightImpact();
    state = page;
    ref.read(analyticsServiceProvider).setPage(state.name);

  }

  @override
  HomePages build() {
    bool isCompany =
        ref.read(firmusUserProvider).valueOrNull?.userType == UserType.company;
    if (isCompany) {
      return HomePages.savedJobs;
    }

    return HomePages.swiper;
  }
}

final currentPageProvider =
    NotifierProvider.autoDispose<HomePageNavigationController, HomePages>(() {
  return HomePageNavigationController();
});

enum HomePages {
  swiper,
  savedJobs,
  chat,
  profile,
  notifications,
}

class StudentHomePage extends ConsumerStatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<StudentHomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<StudentHomePage> {
  @override
  void initState() {
    warmupProvider(ref, jobProfilesProvider);

    if(!kIsWeb){
      ref.read(notificationHandlerProvider);
      Future(() async {
        await ref.read(notificationController.future);
        ref.read(notificationController.notifier).init();
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firmusUserProvider);
    final currentPage = ref.watch(currentPageProvider);
    EdgeInsets padding = MediaQuery.paddingOf(context);
    late Map pages;
    //todo: return different home pages based on user type

    final type = user.requireValue!.userType;
    if (type == UserType.company) {
      pages = {
        HomePages.swiper: const JobBasedSwiperPage(),
        HomePages.savedJobs: const CompanyActiveJobsList(),
        HomePages.profile: const EmployerProfilePage(),
        HomePages.chat: const ChatsPage(),
        HomePages.notifications: const NotificationsPage(),
      };
    } else if (type == UserType.student) {
      pages = {
        HomePages.swiper: const JobsView(),
        HomePages.savedJobs: const SavedJobsPage(),
        HomePages.profile: const ProfilePage(),
        HomePages.chat: const ChatsPage(),
        HomePages.notifications: const NotificationsPage(),
      };
    } else {
      return AdminHome();
    }

    return Scaffold(
      bottomNavigationBar: CustomBottomNav(
        userType: user.requireValue!.userType,
        currentIndex: currentPage.index,
        onTap: (int index) {
          HapticFeedback.selectionClick();
          final page = HomePages.values[index];
          if (user.requireValue!.userType == UserType.student) {
            if (HomePages.values[index] == HomePages.savedJobs &&
                ref.read(firmusUserProvider).requireValue!.isAnon) {
              return const AnonymousUserPopup().showPopup(context);
            }
          }
          if (page == HomePages.swiper) {
            ref.invalidate(selectedJobProvider);
          }

          setNavGrey();
          ref.read(currentPageProvider.notifier).changePage(page);
        },
      ),
      body: SafeArea(
        top: true,
        minimum: EdgeInsets.only(top: padding.top + 4),
        child: ConstrainedBody(
          child: Column(
            children: [
              const HomeAppBar(),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: pages[currentPage],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final UserType userType;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          if (currentIndex != 0) ...kElevationToShadow[1]!,
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: kIsWeb ? 10 : 0),
        child: SafeArea(
          bottom: true,
          child: SizedBox(
            height: 52,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavBarItem(
                  icon: Assets.images.homeOutline.svg(
                    color: FigmaColors.neutralNeutral4,
                  ),
                  iconSelected: Assets.images.homeFilled.svg(
                    color: FigmaColors.primaryPrimary100,
                  ),
                  onTap: () {
                    onTap(0);
                  },
                  scale: 1.2,
                  selected: currentIndex == 0,
                ),
                NavBarItem(
                  selected: currentIndex == 1,
                  icon: Assets.images.boltOutline.svg(
                    color: FigmaColors.neutralNeutral4,
                  ),
                  iconSelected: Assets.images.boltFilled.svg(
                    color: FigmaColors.primaryPrimary100,
                  ),
                  onTap: () {
                    onTap(1);
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return AnimatedTapButton(
                      onTap: () {
                        HapticFeedback.mediumImpact();

                        userType.when(
                          student: () {
                            UploadedCvsVideos.pickVideo(context, ref);
                          },
                          company: () {
                            const PickJobCreationTypePopup().show(context);
                          },
                          admin: () {},
                        );
                      },
                      child: Container(
                          width: 72,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 2, color: Color(0xFF1479EC)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.add,
                                color: Theme.of(context).primaryColor),
                          )),
                    );
                  },
                ),
                NavBarItem(
                  icon: Assets.images.chatOutline.svg(
                    color: FigmaColors.neutralNeutral4,
                  ),
                  iconSelected: Assets.images.chatFilled.svg(
                    color: FigmaColors.primaryPrimary100,
                  ),
                  selected: currentIndex == 2,
                  onTap: () {
                    onTap(2);
                  },
                ),
                NavBarItem(
                  icon: Assets.images.profileOutline.svg(
                    color: FigmaColors.neutralNeutral4,
                  ),
                  iconSelected: Assets.images.profileFilled.svg(
                    color: FigmaColors.primaryPrimary100,
                  ),
                  selected: currentIndex == 3,
                  onTap: () {
                    onTap(3);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final Widget icon;
  final Widget iconSelected;
  final VoidCallback onTap;
  final bool selected;
  final double size;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 8,
            ),
            SizedBox(
                width: 22,
                height: 22,
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: selected ? iconSelected : icon)),
            const SizedBox(
              height: 4,
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: selected ? 1 : 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: selected ? 8 : 0,
                child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: FigmaColors.primaryPrimary100,
                      borderRadius: BorderRadius.circular(2),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  const NavBarItem({
    super.key,
    required this.icon,
    required this.iconSelected,
    required this.onTap,
    required this.selected,
    this.size = 30,
    this.scale = 1,
  });
}

class JobsView extends ConsumerWidget {
  const JobsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(jobHomeViewType);
    return page == HomeViewType.carousel
        ? const SwipingPage()
        : const JobsList();
  }
}

extension on ImageIcon {
  ImageIcon copyWith({
    Color? color,
    double? size,
  }) {
    return ImageIcon(
      image,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }
}
