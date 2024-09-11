import 'package:firmus/helper/logger.dart';
import 'package:firmus/models/registration.dart';
import 'package:firmus/view/pages/registration/page_builders/basic_info.dart';
import 'package:firmus/view/pages/registration/page_builders/city_picker.dart';
import 'package:firmus/view/pages/registration/page_builders/email_validate.dart';
import 'package:firmus/view/pages/registration/page_builders/experience_picker.dart';
import 'package:firmus/view/pages/registration/page_builders/tag_picker.dart';
import 'package:firmus/view/pages/registration/page_builders/video_creator.dart';
import 'package:firmus/view/pages/registration/widgets/top_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../infra/actions/registration_action.dart';
import '../../../infra/observables/registration_observable.dart';
import '../../../main.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  // show if registration fails
  final String? error;
  const RegistrationPage([this.error]);

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    if (widget.error != null) {
      Future(() {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text(widget.error!)));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final obs = ref.watch(registrationOProvider).currentPage;
    setNavBlue();
    ref.read(universityProvider);

    return WillPopScope(
      onWillPop: () async {
        logger.info("onWillPop");
        final page = ref.read(registrationOProvider).currentPage;

        if (page.index == 0) {
          GoRouter.of(context).pop();
        } else {
          RegistrationAction.of(ref).previousPage();
        }
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset:
            obs == StudentRegistrationPage.experiencePicker,
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [
            Positioned.fill(
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1),
                    child: page(obs, context))),
            Positioned(
              top: 0,
              child: Container(
                child: const SafeArea(
                    bottom: false, top: true, child: RegistrationAppBar()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget page(StudentRegistrationPage currentPage, BuildContext context) {
    switch (currentPage) {
      case StudentRegistrationPage.verifyEmail:
        return const EmailValidateScreen();
      case StudentRegistrationPage.cityPicker:
        return const CityPickerPage();

      case StudentRegistrationPage.basicInfo:
        return const BasicInfoPage();

      case StudentRegistrationPage.experiencePicker:
        return const ExperiencePickerPage();

      case StudentRegistrationPage.video:
        return const RegistrationVideoCreatorPage();
      case StudentRegistrationPage.tagPicker:
        return const TagPickerPage();
      case StudentRegistrationPage.done:
        return const Text("Done");
    }
    return Text(currentPage.name);
  }
}
