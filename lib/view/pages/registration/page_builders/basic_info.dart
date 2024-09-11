import 'dart:async';
import 'dart:io';

import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/helper/open_settings.dart';
import 'package:firmus/infra/actions/registration_action.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/models/registration.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:firmus/view/pages/registration/widgets/gender_field.dart';
import 'package:firmus/view/pages/registration/widgets/next_button.dart';
import 'package:firmus/view/pages/registration/widgets/social_media_buttons.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../helper/image_picker.dart';
import '../../../../infra/observables/registration_observable.dart';
import '../../../shared/buttons/primary_button.dart';
import '../registration_image_cropper.dart';

class BasicInfoPage extends ConsumerStatefulWidget {
  const BasicInfoPage({Key? key}) : super(key: key);

  @override
  ConsumerState<BasicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends ConsumerState<BasicInfoPage>
    with AutosaverMixin {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(
      height: 24,
    );
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: initialValue(),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: ConstrainedBody(
              center: false,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          context.loc.enterBasicInfoTitle,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        FadeAndTranslate(
                          autoStart: true,
                          translate: const Offset(0.0, 20.0),
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              /// Ime i prezime
                              SizedBox(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // image form field
                                    const _RegistrationProfileAvatarPicker(),
                                    const SizedBox(
                                      width: 29,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FormBuilderTextField(
                                            validator:
                                                FormBuilderValidators.compose([
                                              FormBuilderValidators.required(),
                                            ]),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(color: Colors.white),
                                            decoration: inputDecoration,
                                            textInputAction:
                                                TextInputAction.next,
                                            name: 'name',
                                          ).withTitle("Ime"),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          FormBuilderTextField(
                                            validator:
                                                FormBuilderValidators.compose([
                                              FormBuilderValidators.required(),
                                            ]),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(color: Colors.white),
                                            decoration: inputDecoration,
                                            textInputAction:
                                                TextInputAction.next,
                                            name: 'surname',
                                          ).withTitle("Prezime"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              spacer,

                              /// Email adresa
                              SizedBox(
                                child: FormBuilderTextField(
                                  autocorrect: false,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.email(),
                                  ]),
                                  keyboardType: TextInputType.emailAddress,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.white),
                                  decoration: inputDecoration.copyWith(
                                    hintText: "Unesite studentsku email adresu",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                  ),
                                  textInputAction: TextInputAction.done,
                                  name: 'email',
                                ).withTitle("Email adresa"),
                              ),

                              spacer,

                              const IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(child: GenderField()),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: BirthDateField(),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 12,
                              ),
                              FormBuilderCheckbox(
                                onChanged: (value) {
                                  saveState();

                                  setState(() {});
                                },
                                side: const BorderSide(
                                    color: Colors.white, width: 2),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                name: 'asStudent',
                                title: FieldTitle(
                                    title: "Želim se prijaviti kao student",
                                    required: false),
                              ),
                              const SizedBox(
                                height: 120,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SocialMediaButtons(),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 52,
                  ),
                  NextButton(
                    onTap: () async {
                      _formKey.currentState!.save();

                      if (_formKey.currentState!.saveAndValidate()) {
                        saveState();
                        RegistrationAction.of(ref).next();
                      }

                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 52,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> initialValue() {
    return ref
            .read(registrationOProvider)
            .state[StudentRegistrationPage.basicInfo] ??
        {
          if (kDebugMode) ...{
            "name": "Marko",
            "surname": "Markovic",
            "email": "leo.radocaj2@gmail.com",
          }
        };
  }

  @override
  void saveState() {
    _formKey.currentState!.save();
    RegistrationAction.of(ref).saveState(StudentRegistrationPage.basicInfo,
        Map.from(_formKey.currentState!.value));
  }
}

class BirthDateField extends StatelessWidget {
  const BirthDateField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final rebuildOn = Form.of(context);
    final lastDate = DateTime(
      DateTime.now().year - 18,
      DateTime.now().month,
      DateTime.now().day,
    );
    return FormBuilderDateTimePicker(
      lastDate: lastDate,
      initialDate: lastDate,
      onFieldSubmitted: (_) {
        logger.info("submitted");
      },
      inputType: InputType.date,
      autofocus: false,
      style:
          Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
      initialEntryMode: DatePickerEntryMode.calendar,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
      name: "date_of_birth",
      scrollPadding: const EdgeInsets.only(bottom: 120),
      textInputAction: TextInputAction.done,
      format: DateFormat("dd.MM.yyyy"),
      decoration: inputDecoration.copyWith(
          hintText: "Datum rođenja",
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white.withOpacity(0.5)),
          suffixIcon: const Icon(
            Icons.calendar_today_rounded,
            color: Colors.white,
          )),
    ).withTitle(
      "Datum rođenja",
    );
  }
}

class _RegistrationProfileAvatarPicker extends ConsumerWidget {
  const _RegistrationProfileAvatarPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilderField<File?>(
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
      name: "image",
      initialValue: ref
          .read(registrationOProvider)
          .state[StudentRegistrationPage.basicInfo]?['image'],
      builder: (FormFieldState<File?> field) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: AnimatedTapButton(
                    child: GestureDetector(
                      onTap: () {
                        pickImage().then((value) async {
                          if (value != null) {
                            File croppedValue =
                                await RegistrationImageCropperPage(
                                        uncroppedImage: File(value.path))
                                    .startCrop(context);
                            field.didChange(croppedValue);
                          }
                        }).catchError((e) {
                          logger.info(e);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Theme.of(context).canvasColor,
                              content: Row(
                                children: [
                                  Text(
                                    "Dozvolite pristup galeriji u postavkama.",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  const Spacer(),
                                  SmallPrimaryButton(
                                      onTap: () {
                                        openSettings();
                                      },
                                      text: context.loc.openSettings)
                                ],
                              )));
                        });
                      },
                      child: SizedBox(
                        height: 148,
                        width: 98,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Assets.images.profileAvatarBorder
                                .image(height: 160),
                            if (field.value == null)
                              Positioned(
                                top: 8,
                                child: Assets.images.profileAvatar
                                    .image(width: 80),
                              )
                            else
                              Positioned(
                                top: 8,
                                child: FittedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Container(
                                      width: 80,
                                      color: Colors.white,
                                      height: 80,
                                      child: Image.file(
                                        field.value!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                                bottom: 22,
                                child:
                                    Assets.images.addAPhoto.image(width: 24)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(field.errorText!,
                        style:
                            Theme.of(context).inputDecorationTheme.errorStyle),
                  )
              ],
            ),
            Align(
                alignment: Alignment.topRight,
                child: Text(
                  "*",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.error),
                ))
          ],
        );
      },
    );
  }
}

mixin AutosaverMixin<T extends StatefulWidget> on State<T> {
  void saveState();

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      saveState();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
