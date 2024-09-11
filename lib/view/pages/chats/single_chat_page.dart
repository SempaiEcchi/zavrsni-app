import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/main.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/models/user_type.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/chats/controllers/chat_page_state.dart';
import 'package:firmus/view/pages/chats/controllers/single_chat_controller.dart';
import 'package:firmus/view/pages/chats/controllers/single_chat_state.dart';
import 'package:firmus/view/pages/chats/widgets/send_message_box.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleChatPage extends ConsumerWidget {
  final ChatOverview chatId;

  const SingleChatPage(this.chatId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(singleChatControllerProvider(chatId));
    return Scaffold(
      body: chat.when(data: (data) {
        return ConstrainedBody.onlyWeb(
          child: _ChatBody(
              chat: data,
              notifier:
                  ref.read(singleChatControllerProvider(chatId).notifier)),
        );
      }, error: (e, st) {
        return Text("Error loading chat $e");
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}

class _ChatBody extends StatefulHookConsumerWidget {
  final SingleChatState chat;
  final SingleChatController notifier;

  @override
  ConsumerState<_ChatBody> createState() => _ChatBodyState();

  const _ChatBody({
    required this.chat,
    required this.notifier,
  });
}

class _ChatBodyState extends ConsumerState<_ChatBody> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      widget.notifier.seeMessages();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    widget.notifier.seeMessages();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = useScrollController(keys: [""]);
    useEffect(() {
      Future(() {
        controller.jumpTo(controller.position.maxScrollExtent);
      });
      return null;
    }, ["key"]);

    return SafeArea(
      top: false,
      bottom: true,
      child: Column(
        children: [
          buildHeader(),
          const SizedBox(
            height: 2,
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                controller: controller,
                itemCount: widget.chat.messages.length,
                itemBuilder: (context, index) {
                  final message = widget.chat.messages[index];
                  return BubbleSpecialThree(
                    text: message.message,
                    color: message.isSender
                        ? const Color(0xFFE8E8EE)
                        : Theme.of(context).primaryColor.withOpacity(0.5),
                    tail: false,
                    isSender: message.isSender,
                  );
                }),
          ),
          SendMessageBox(
            onTapSend: (String message) {
              widget.notifier.sendMessage(message).catchError((e) {
                logger.info(e);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Greška pri slanju poruke"),
                ));
              });
              Future(() {
                controller.animateTo(controller.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    final userType = ref.read(firmusUserProvider).requireValue!.userType;
    if (userType == UserType.student) {
      return _CompanyChatHeader(
          jobOpportunity: widget.chat.chat.jobOpportunity);
    }

    final SimpleStudentProfile? student = widget.chat.chat.student;
    return _StudentChatHeader(
      studentName: student?.name ?? "",
      studentLocation: student?.location ?? "",
      image: student?.imageUrl ?? "",
      studentNumber: student?.phoneNumber ?? "",
    );
  }
}

class _StudentChatHeader extends StatelessWidget {
  final String studentName;
  final String studentLocation;
  final String image;
  final String studentNumber;

  const _StudentChatHeader({
    required this.studentName,
    required this.studentLocation,
    required this.image,
    required this.studentNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
          color: const Color(0xffF4F6F9),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.paddingOf(context).top,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BackButton(
                  color: Colors.black,
                  onPressed: () {
                    GoRouter.of(context).pop();
                  }),
              CircleAvatar(
                radius: 16,
                backgroundImage: CachedNetworkImageProvider(image),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      studentName,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(height: 0),
                    ),
                    Text(
                      studentLocation,
                      maxLines: 1,
                      style: textStyles.paragraphXSmallHeavy.copyWith(
                          color: FigmaColors.neutralNeutral4, height: 0),
                    ),
                  ],
                ),
              ),
              _PhoneButton(studentNumber),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}

class _PhoneButton extends StatelessWidget {
  final String phoneNumber;

  _PhoneButton(this.phoneNumber);

  @override
  Widget build(BuildContext context) {
    if (phoneNumber.isEmpty) {
      return const SizedBox();
    }
    return IconButton(
        onPressed: () {
          whatsapp(phoneNumber);
        },
        icon: const Icon(
          CupertinoIcons.phone,
          size: 28,
          color: Color(0xffEC8714),
        ));
  }

}

whatsapp(String contact) async {
  final text = "Pozdrav!";

  var androidUrl = "whatsapp://send?phone=$contact&text=$text";
  var iosUrl = "https://wa.me/$contact?text=${Uri.parse(text)}";

  if (kIsWeb) {
    await launchUrl(Uri.parse(iosUrl));
    return;
  }

  try {
    if (UniversalPlatform.isIOS) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      await launchUrl(Uri.parse(androidUrl));
    }
  } on Exception {
    Clipboard.setData(ClipboardData(text: contact));
  }
}

class _CompanyChatHeader extends StatelessWidget {
  final JobOpportunity jobOpportunity;

  const _CompanyChatHeader({
    required this.jobOpportunity,
  });

  @override
  Widget build(BuildContext context) {
    final company = jobOpportunity.company;
    return Container(
      key: ValueKey(company.id),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
          color: const Color(0xffF4F6F9),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.paddingOf(context).top,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BackButton(
                  color: Colors.black,
                  onPressed: () {
                    GoRouter.of(context).pop();
                  }),
              Hero(
                tag: "${company.id}companylogo",
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: CachedNetworkImageProvider(company.logoUrl),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      company.name,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(height: 0),
                    ),
                    Text(
                      jobOpportunity.jobTitle,
                      maxLines: 1,
                      style: textStyles.paragraphXSmallHeavy.copyWith(
                          color: FigmaColors.neutralNeutral4, height: 0),
                    ),
                  ],
                ),
              ),
              _PhoneButton(company.phoneNumber),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
