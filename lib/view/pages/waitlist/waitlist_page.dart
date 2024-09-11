import 'package:email_validator/email_validator.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class JoinWaitlistPage extends StatefulHookConsumerWidget {
  const JoinWaitlistPage({Key? key}) : super(key: key);

  @override
  ConsumerState<JoinWaitlistPage> createState() => _JoinWaitlistPageState();
}

class _JoinWaitlistPageState extends ConsumerState<JoinWaitlistPage> {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
        text: kDebugMode ? "leo.radocaj2@gmail.com" : "");
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.8),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 650,
                  height: MediaQuery.of(context).size.height * 0.8,
                  constraints: const BoxConstraints(maxHeight: 600),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Prijavi se na listu čekanja",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                                  fontSize: 52,
                                  height: 1,
                                  fontWeight: FontWeight.w900)
                              .copyWith(
                                  fontFamily: "SourceSansPro",
                                  color: Colors.black)),
                      Text(
                          "Prijavom na listu čekanja dobit ćeš priliku da budeš među prvima koji će koristiti Firmus.\nTakođer ćeš dobiti besplatan pristup našoj platformi na 90 dana.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                                  fontSize: 24,
                                  height: 1,
                                  fontWeight: FontWeight.w400)
                              .copyWith(
                                  fontFamily: "SourceSansPro",
                                  color: Colors.black)),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              decoration: inputDecoration.copyWith(
                                  hintText: "Email",
                                  fillColor: Colors.white,
                                  filled: true),
                              controller: controller,
                              onFieldSubmitted: (value) {},
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  submitEmail(controller.text);
                                },
                                child: const Text("Prijavi se")),
                          ),
                        ],
                      ),
                      const AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Placeholder(
                          child: Text("video"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void submitEmail(String email) {
    if (EmailValidator.validate(email) == false) {
      return;
    }
    ref.read(httpServiceProvider).request(
        PostRequest(endpoint: "/waitlist", body: {
          "email": email,
        }),
        converter: (data) {});
  }
}
