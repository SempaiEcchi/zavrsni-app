import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/onboarding/pick_registation_type.dart';
import 'package:firmus/view/pages/registration/registration_image_cropper.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:firmus/view/shared/buttons/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../gen/assets.gen.dart';
import '../../registration/page_builders/city_picker.dart';
import '../../registration/widgets/constrained_body.dart';

class UniversityEditPage extends ConsumerStatefulWidget {
  const UniversityEditPage({super.key});

  @override
  ConsumerState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<UniversityEditPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(
      height: 24,
    );
    final university = ref.watch(universityProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: FirmusAppBar(
        onPressed: () {
          GoRouter.of(context).pop();
        },
        text: 'Fakultet',
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: FormBuilder(
          key: _formKey,
          initialValue:
              ref.read(studentNotifierProvider).requireValue.toUniEdit(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Stack(
                    children: [
                      FormBuilderDropdown(
                        iconSize: 0,
                        onChanged: (value) {
                          setState(() {
                            _formKey.currentState?.save();
                          });
                        },
                        dropdownColor:
                        Theme.of(context).primaryColor,
                        validator:
                        FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                        decoration: inputDecoration,
                        name: 'city',
                        initialValue: "",
                        items: [
                          ...university.requireValue.keys,
                        ]
                            .map((e) => DropdownMenuItem(
                          alignment:
                          Alignment.centerLeft,
                          value: e,
                          child: Container(
                            child: Text(
                              e,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                color:
                                Colors.white,
                              ),
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 12.0),
                          child: Assets.images.dropdown
                              .image(width: 14, height: 14),
                        ),
                      )
                    ],
                  ).withTitle("Grad"),
                  const SizedBox(
                    height: 24,
                  ),
                  Stack(
                    children: [
                      FormBuilderDropdown(
                        iconSize: 0,
                        dropdownColor:
                        Theme.of(context).primaryColor,
                        validator:
                        FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                        decoration: inputDecoration,
                        name: 'uni',
                        items: [
                          ...university.requireValue[_formKey
                              .currentState
                              ?.value["city"]] ??
                              [],
                        ]
                            .map((e) => DropdownMenuItem(
                          alignment:
                          Alignment.centerLeft,
                          value: e,
                          child: Container(
                            child: Text(
                              e,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                color:
                                Colors.white,
                              ),
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 12.0),
                          child: Assets.images.dropdown
                              .image(width: 14, height: 14),
                        ),
                      )
                    ],
                  ).withTitle("Fakultet"),
                  const SizedBox(
                    height: 24,
                  ),
                  Stack(
                    children: [
                      FormBuilderDropdown(
                        iconSize: 0,
                        dropdownColor:
                        Theme.of(context).primaryColor,
                        validator:
                        FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                        decoration: inputDecoration,
                        name: 'uni_year',
                        initialValue: "1. godina",
                        items: [
                          "1. godina",
                          "2. godina",
                          "3. godina",
                          "4. godina",
                          "5. godina",
                          "Ostalo"
                        ]
                            .map((e) => DropdownMenuItem(
                          alignment:
                          Alignment.centerLeft,
                          value: e,
                          child: Container(
                            child: Text(
                              e,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                  color: Colors
                                      .white),
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 12.0),
                          child: Assets.images.dropdown
                              .image(width: 14, height: 14),
                        ),
                      )
                    ],
                  ).withTitle("Godina"),
                ],
              ),
              SaveButton(
                onTap: () async {
                  _formKey.currentState!.save();

                  if (_formKey.currentState!.saveAndValidate()) {
                    showLoadingDialog(context);
                    final data = _formKey.currentState!.value;
                    logger.info(data);
                    ref
                        .read(studentNotifierProvider.notifier)
                        .updateUni(data)
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
