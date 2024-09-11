import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/models/entity/user_entity.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/chats/controllers/chat_page_controller.dart';
import 'package:firmus/view/pages/chats/controllers/chat_page_state.dart';
import 'package:firmus/view/pages/chats/single_chat_page.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatsPage extends ConsumerWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUser = ref.watch(firmusUserProvider).requireValue!.userType;
    final chatOverviews = ref.watch(chatsControllerProvider);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Transform.scale(
          scale: 1.1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: FigmaColors.primaryPrimary100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Kontaktiraj podršku",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      body: chatOverviews.when(data: (data) {
        return ConstrainedBody.onlyWeb(
          child: _ChatsList(
            chatOverviews: data.chats,
            myUser: myUser,
          ),
        );
      }, error: (e, st) {
        debugPrintStack(stackTrace: st);
        return Text("Error loading chats $e");
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}

class _ChatsList extends ConsumerWidget {
  final UserType myUser;
  final List<ChatOverview> chatOverviews;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (chatOverviews.isEmpty) {
      return Center(
          child: Text(
        "Nemate poruka",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.grey),
      ));
    }
    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(
              color: FigmaColors.primaryPrimary10,
              height: 0.1,
            ),
        itemCount: chatOverviews.length,
        itemBuilder: (context, index) {
          final chatOverview = chatOverviews[index];
          return ListTile(
            key: ValueKey(chatOverview.chatId),
            leading: Hero(
              tag: "${chatOverview.jobOpportunity.company.id}companylogo",
              child: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(chatOverview.company.logoUrl),
              ),
            ),
            title: Text(
              chatOverview.title(myUser),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              chatOverview.lastMessage ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              myUser.when(
                student: () {
                  final student =
                      ref.read(studentNotifierProvider).requireValue;

                  ref.a.logEvent(
                      name: AnalyticsEvent.contact_company_whatsapp,
                      parameters: {
                        "company_id": chatOverview.company.id,
                        "company_name": chatOverview.company.name,
                        "student_id": student.id,
                        "student_name":
                            student.first_name + " " + student.last_name,
                      });
                  whatsapp(chatOverview.company.phoneNumber);
                },
                company: () {
                  if (chatOverview.student?.phoneNumber == null) {
                    launchUrl(Uri.parse(
                        "mailto:${chatOverview.student!.email_contact}"));
                  }

                  whatsapp(chatOverview!.student?.phoneNumber ?? "");
                },
                admin: () {
                  if (chatOverview.student?.phoneNumber == null) {
                    launchUrl(Uri.parse(
                        "mailto:${chatOverview.student!.email_contact}"));
                  }

                  whatsapp(chatOverview!.student?.phoneNumber ?? "");
                },
              );
              // GoRouter.of(context).push(RoutePaths.chat, extra: chatOverview);
            },
          );
        });
  }

  const _ChatsList({
    required this.chatOverviews,
    required this.myUser,
  });
}
