import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../infra/services/job/entity/job_offer_details_response.dart';
import '../../pages/chats/chats_page.dart';
import '../../shared/lists/tab_bar.dart';
import 'active_list.dart';
import 'applicants_list.dart';
import 'companies_list.dart';
import 'jobs_list.dart';
import 'matched_list.dart';

sealed class AdminHomePage {
  Widget get page;
}

class ApplicationsPage extends AdminHomePage {
  @override
  Widget get page => _ApplicationsView();
}

class CompaniesPage extends AdminHomePage {
  @override
  Widget get page => CompaniesView();
}

class JobOffersPage extends AdminHomePage {
  final SimpleCompany? company;

  JobOffersPage([this.company]);

  @override
  Widget get page => JobView(this.company);
}

class ChatsPageC extends AdminHomePage {
  ChatsPageC();

  @override
  Widget get page => ChatsPage();
}

final adminNavProvider = NotifierProvider<AdminNavNotifier, AdminHomePage>(
  () => AdminNavNotifier(),
);

class AdminNavNotifier extends Notifier<AdminHomePage> {
  void navigateTo(AdminHomePage page) {
    switch (page) {
      case ApplicationsPage page:
        break;
      case CompaniesPage page:
        break;
      case JobOffersPage page:
        break;
      case ChatsPageC page:
        break;
    }
    this.state = page;
  }

  @override
  AdminHomePage build() {
    return ApplicationsPage();
  }
}

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
      ),
      drawer: Drawer(
        child: Consumer(
          builder: (context, ref, child) {
            adminProvidersWarmup(ref);

            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                  child: Text('Admin'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: const Text('Prijave'),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    ref.read(adminNavProvider.notifier).navigateTo(
                          ApplicationsPage(),
                        );
                    context.pop();
                  },
                ),
                ListTile(
                  title: const Text('Kompanije'),
                  leading: const Icon(Icons.work_outline),
                  onTap: () {
                    ref.read(adminNavProvider.notifier).navigateTo(
                          CompaniesPage(),
                        );
                    context.pop();
                  },
                ),
                ListTile(
                  title: const Text('Job Offers'),
                  leading: const Icon(Icons.offline_bolt_outlined),
                  onTap: () {
                    ref.read(adminNavProvider.notifier).navigateTo(
                          JobOffersPage(),
                        );
                    context.pop();
                  },
                ),
                ListTile(
                  title: const Text('Chat'),
                  leading: const Icon(Icons.chat_sharp),
                  onTap: () {
                    ref.read(adminNavProvider.notifier).navigateTo(
                          ChatsPageC(),
                        );
                    context.pop();
                  },
                ),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () {
                    ref.read(firmusUserProvider.notifier).logout();
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final page = ref.watch(adminNavProvider);
          return page.page;
        },
      ),
    );
  }

  void adminProvidersWarmup(WidgetRef ref) {
    ref.read(jobProfilesProvider);
  }
}

class _ApplicationsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminApplicationsViewNotifierProvider);
    return ConstrainedBody(
      center: true,
      child: state.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          debugPrintStack(stackTrace: stack);
          return InkWell(
              onTap: () {
                ref.refresh(adminApplicationsViewNotifierProvider);
              },
              child: Text('Error: $error'));
        },
        data: (data) {
          return DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: RoundedTabBar(
                          tabs: [
                            context.loc.applications,
                            context.loc.matches,
                            context.loc.active,
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            ref.refresh(
                                adminApplicationsViewNotifierProvider.notifier);
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          CollapsingList(data.applications, () {
                            ref.refresh(adminApplicationsViewNotifierProvider);
                          }),
                          CollapsingListMatched(data.matches, () {
                            ref.refresh(adminApplicationsViewNotifierProvider);
                          }),
                          CollapsingListActive(data.active, () {
                            ref.refresh(adminApplicationsViewNotifierProvider);
                          }),
                        ]),
                  ),
                ],
              ));
        },
      ),
    );
  }
}

class AllApplicationsState {
  const AllApplicationsState({
    required this.applications,
    required this.matches,
    required this.active,
  });

  final Map<JobOpportunity, List<InterestedApplicant>> applications;
  final Map<JobOpportunity, List<MatchedApplicant>> matches;
  final Map<JobOpportunity, List<EmployedApplicant>> active;

  AllApplicationsState copyWith({
    Map<JobOpportunity, List<InterestedApplicant>>? applications,
    Map<JobOpportunity, List<MatchedApplicant>>? matches,
    Map<JobOpportunity, List<EmployedApplicant>>? active,
  }) {
    return AllApplicationsState(
      applications: applications ?? this.applications,
      matches: matches ?? this.matches,
      active: active ?? this.active,
    );
  }
}

final adminApplicationsViewNotifierProvider =
    AsyncNotifierProvider<AdminApplicationsViewNotifier, AllApplicationsState>(
  () => AdminApplicationsViewNotifier(),
);

class AdminApplicationsViewNotifier
    extends AsyncNotifier<AllApplicationsState> {
  @override
  FutureOr<AllApplicationsState> build() async {
    final (
      resp,
      resp2,
      resp3,
    ) = await (
      ref.watch(jobServiceProvider).getAllInterestedApplicants(),
      ref.watch(jobServiceProvider).getAllMatchedApplicants(),
      ref.watch(jobServiceProvider).getAllEmployedApplicants()
    ).wait;

    return AllApplicationsState(
        applications: resp, matches: resp2, active: resp3);
  }

  Future refreshInterested() {
    return ref
        .watch(jobServiceProvider)
        .getAllInterestedApplicants()
        .then((value) {
      update((c) {
        return c.copyWith(applications: value);
      });
    });
  }

  Future refreshMatched() {
    return ref
        .watch(jobServiceProvider)
        .getAllMatchedApplicants()
        .then((value) {
      update((c) {
        return c.copyWith(matches: value);
      });
    });
  }

  Future refreshEmployed() {
    return ref
        .watch(jobServiceProvider)
        .getAllEmployedApplicants()
        .then((value) {
      update((c) {
        return c.copyWith(active: value);
      });
    });
  }

  Future swipe(FirmusSwipeType swipeType, JobOpportunity job,
      InterestedApplicant applicant) async {
    removeStudent(job, applicant);

    await ref.watch(jobServiceProvider).swipeStudent(
          applicant.student.id,
          job.id,
          swipeType,
        );

    if (swipeType == FirmusSwipeType.like) {
      this.refreshMatched();
    }
  }

  removeStudent(JobOpportunity job, InterestedApplicant applicant) {
    final state = this.state.requireValue;
    final applications = (state.applications[job] ?? []).toList();
    applications.remove(applicant);
    final newApplications = {...state.applications};
    newApplications[job] = applications;
    if (applications.isEmpty) {
      newApplications.remove(job);
    }
    logger.info('Removed student from job');

    update((c) {
      return c.copyWith(applications: newApplications);
    });
  }

  removeMatchedStudent(String matchId) {
    final state = this.state.requireValue;
    final Map<JobOpportunity, List<MatchedApplicant>> matches =
        Map.from(state.matches);

    matches.removeWhere((key, value) {
      final match =
          value.firstWhereOrNull((element) => element.matchId == matchId);
      if (match != null) {
        value.remove(match);
        return true;
      }
      return false;
    });

    update((c) {
      return c.copyWith(matches: matches);
    });
  }

  removeEmployed(EmployedApplicant applicant) {
    final state = this.state.requireValue;
    final Map<JobOpportunity, List<EmployedApplicant>> active =
        Map.from(state.active);

    active.removeWhere((key, value) {
      final match = value.firstWhereOrNull(
          (element) => element.record_id == applicant.record_id);
      if (match != null) {
        value.remove(match);
        return true;
      }
      return false;
    });

    update((c) {
      return c.copyWith(active: active);
    });
  }

  Future startJob(String matchId) async {
    await ref
        .watch(httpServiceProvider)
        .request(GetRequest(endpoint: "/jobs/match/$matchId/employ"),
            converter: (Map<String, dynamic> response) {
      return response;
    });
    removeMatchedStudent(matchId);
    this.refreshMatched();
  }


  Future rejectStudent(String matchId) async {
    await ref
        .watch(httpServiceProvider)
        .request(GetRequest(endpoint: "/jobs/match/$matchId/reject"),
        converter: (Map<String, dynamic> response) {
          return response;
        });
    removeMatchedStudent(matchId);
    this.refreshMatched();
  }


  void finishEmployment(EmployedApplicant applicant) {
    ref.read(httpServiceProvider).request(
        PostRequest(
            endpoint: "/jobs/employment/${applicant.record_id}/complete",
            body: {}),
        converter: noOp);
    removeEmployed(applicant);
  }
}
