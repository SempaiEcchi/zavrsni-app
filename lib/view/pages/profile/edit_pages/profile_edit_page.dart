import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/helper/image_picker.dart';
import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/main.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/onboarding/pick_registation_type.dart';
import 'package:firmus/view/pages/registration/page_builders/basic_info.dart';
import 'package:firmus/view/pages/registration/registration_image_cropper.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:firmus/view/pages/registration/widgets/gender_field.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../registration/widgets/constrained_body.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final key = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    setNavBlue();
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
        text: 'Osnovni podaci',
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: FormBuilder(
          key: key,
          initialValue: ref
              .read(studentNotifierProvider)
              .requireValue
              .toProfileEditForm(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
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
                                  children: [
                                    _ImageField(),
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
                                            name: 'first_name',
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
                                            name: 'last_name',
                                          ).withTitle("Prezime"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              spacer,
                              const Row(
                                children: [
                                  Expanded(child: GenderField()),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(child: BirthDateField()),
                                ],
                              ),
                              spacer,

                              /// Broj mobitela
                              FormBuilderTextField(
                                autocorrect: false,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        signed: true),
                                valueTransformer: (value) {
                                  final newValue = value is String
                                      ? value.replaceAll(RegExp(r'[^0-9]'), '')
                                      : value;
                                  return newValue;
                                },
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white),
                                decoration: inputDecoration.copyWith(
                                  hintText: "Broj mobitela",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Colors.white.withOpacity(0.5)),
                                ),
                                textInputAction: TextInputAction.next,
                                name: 'phone_number',
                              ).withTitle("Broj mobitela", required: true),
                              spacer,

                              /// Kontakt Email adresa
                              SizedBox(
                                child: FormBuilderTextField(
                                  autocorrect: false,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.email(),
                                  ]),
                                  keyboardType: TextInputType.emailAddress,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.white),
                                  decoration: inputDecoration.copyWith(
                                    hintText: "Unesite email adresu za kontakt",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  name: 'email_contact',
                                ).withTitle("Kontaktna email adresa",
                                    required: false),
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
                  setState(() {});
                  key.currentState!.save();

                  if (key.currentState!.validate(focusOnInvalid: false)) {
                    ref.a.logEvent(
                      name: AnalyticsEvent.update_student_profile,
                    );
                    final data = key.currentState!.value;
                    await ref
                        .read(studentNotifierProvider.notifier)
                        .updateProfile(Map.from(data))
                        .then((v) => GoRouter.of(context).pop());
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
    );
  }
}

class _ImageField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilderField<Object>(
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
      name: "image",
      builder: (FormFieldState<Object> field) {
        Object image = field.value!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: AnimatedTapButton(
                child: GestureDetector(
                  onTap: () {
                    pickImage().then((value) async {
                      if (value != null) {
                        File croppedValue = await RegistrationImageCropperPage(
                                uncroppedImage: File(value.path))
                            .startCrop(context);
                        field.didChange(croppedValue);
                        field.save();
                      }
                    });
                  },
                  child: SizedBox(
                    height: 148,
                    width: 98,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Assets.images.profileAvatarBorder.image(height: 160),
                        Positioned(
                          top: 8,
                          child: FittedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                width: 80,
                                color: Colors.white,
                                height: 80,
                                child: image is String
                                    ? CachedNetworkImage(
                                        imageUrl: image,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        image as File,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 22,
                            child: Assets.images.addAPhoto.image(width: 24)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  field.errorText!,
                  style: Theme.of(context).inputDecorationTheme.errorStyle,
                ),
              )
          ],
        );
      },
    );
  }
}
