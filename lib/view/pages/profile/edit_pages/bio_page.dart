import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/onboarding/pick_registation_type.dart';
import 'package:firmus/view/pages/registration/registration_image_cropper.dart';
import 'package:firmus/view/shared/buttons/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../registration/widgets/constrained_body.dart';

class BioEditPage extends ConsumerStatefulWidget {
  const BioEditPage({super.key});

  @override
  ConsumerState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<BioEditPage> {
  final key = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(
      height: 24,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: FirmusAppBar(
        onPressed: () {
          GoRouter.of(context).pop();
        },
        text: 'Bio',
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: FormBuilder(
          key: key,
          initialValue:
              ref.read(studentNotifierProvider).requireValue.toBioEditForm(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ConstrainedBody(
                  center: false,
                  child: SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        FadeAndTranslate(
                          autoStart: true,
                          translate: const Offset(0.0, 20.0),
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              /// Broj mobitela
                              ///
                              const Opacity(
                                opacity: 0.6,
                                child: Text(
                                  'Ukratko nam reci više o sebi, ovaj opis biti će \nprikazan svim poslodavcima',
                                  style: TextStyle(
                                    fontFamily: "SourceSansPro",
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              SizedBox(
                                child: FormBuilderTextField(
                                  autocorrect: false,
                                  minLines: 3,
                                  autovalidateMode: AutovalidateMode.always,
                                  maxLines: 10,
                                  keyboardType: TextInputType.text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.white),
                                  decoration: inputDecoration.copyWith(
                                    hintText: "...",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                  ),
                                  textInputAction: TextInputAction.done,
                                  name: 'bio',
                                ),
                              ),
                              spacer,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SaveButton(
                onTap: () async {
                  key.currentState!.save();

                  if (key.currentState!.saveAndValidate()) {
                    showLoadingDialog(context);
                    final data = key.currentState!.value;
                    logger.info(data);
                    ref
                        .read(studentNotifierProvider.notifier)
                        .updateBio(data)
                        .whenComplete(() => GoRouter.of(context).popPop());
                  }
                },
              ),
              const SizedBox(
                height: 52,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
