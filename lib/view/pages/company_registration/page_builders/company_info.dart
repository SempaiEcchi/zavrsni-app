import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/helper/image_picker.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/stores/company_registration.dart';
import 'package:firmus/main.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/registration_image_cropper.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../registration/widgets/constrained_body.dart';
import '../../registration/widgets/next_button.dart';
import '../company_registration_page.dart';

class CompanyInfoPage extends ConsumerStatefulWidget {
  const CompanyInfoPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CompanyInfoPage> createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends ConsumerState<CompanyInfoPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final scope = FocusScope.of(context);
    logger.info(scope.focusedChild);
    const spacer = SizedBox(
      height: 24,
    );
    return FormBuilder(
      key: _formKey,
      initialValue: ref
              .read(companyRegistrationNotifierProvider)
              .state[CompanyRegistrationPage.companyInfo] ??
          {},
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: ConstrainedBody(
              center: false,
              child: SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 110,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Osnovne informacije o\nfirmi",
                          textAlign: TextAlign.left,
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
                              Column(
                                children: [
                                  _CompanyImagePicker(),
                                  spacer,
                                  FormBuilderTextField(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white),
                                    decoration: inputDecoration,
                                    textInputAction: TextInputAction.next,
                                    name: 'name',
                                    initialValue:
                                        kDebugMode ? "leo company" : null,
                                  ).withTitle("Puni naziv firme"),
                                  spacer,
                                  FormBuilderTextField(
                                    keyboardType: TextInputType.multiline,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white),
                                    decoration: inputDecoration.copyWith(
                                        isDense: false),
                                    textInputAction: TextInputAction.next,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                    initialValue:
                                        kDebugMode ? "leo company" : null,
                                    name: 'oib',
                                  ).withTitle(
                                    "OIB Firme",
                                  ),
                                  spacer,
                                  FormBuilderTextField(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white),
                                    decoration: inputDecoration,
                                    textInputAction: TextInputAction.done,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.email(),
                                    ]),
                                    initialValue: kDebugMode
                                        ? "leo.radocaj2+comps@gmail.com"
                                        : null,
                                    name: 'email',
                                  ).withTitle("Email"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!ref.watch(keyboardOnProvider))
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 52,
                  ),
                  NextButton(
                    onTap: () async {
                      bool saveAndValidate =
                          _formKey.currentState!.saveAndValidate();

                      setState(() {});
                      if (saveAndValidate) {
                        final data = _formKey.currentState!.value;
                        ref
                            .read(companyRegistrationNotifierProvider.notifier)
                            .nextPage(data);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 52,
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}

class _CompanyImagePicker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilderField<Object?>(
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
      name: "logo",
      builder: (FormFieldState<Object?> field) {
        Object? image = field.value;
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
                      }
                    });
                  },
                  child: SizedBox(
                    height: 90,
                    width: 260,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Assets.images.companyLogoBorder.image(),
                        FittedBox(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: ClipOval(
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.white,
                                    child: image is String
                                        ? CachedNetworkImage(
                                            imageUrl: image,
                                            fit: BoxFit.cover,
                                          )
                                        : image == null
                                            ? Assets.images.companyLogo.image()
                                            : Image.file(
                                                image as File,
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Logo firme",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.white)),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "Učitajte logo vaše firme",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 16,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 8),
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
