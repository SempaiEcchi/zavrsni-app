import 'dart:developer';

import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/infra/actions/registration_action.dart';
import 'package:firmus/infra/services/user/user_service.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/models/registration.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:firmus/view/pages/registration/widgets/next_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../infra/observables/registration_observable.dart';

class CityPickerPage extends ConsumerStatefulWidget {
  const CityPickerPage({super.key});

  @override
  ConsumerState<CityPickerPage> createState() => _CityPickerPageState();
}

class _CityPickerPageState extends ConsumerState<CityPickerPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    Future(() {
      Permission.location.request();
      setState(() {
        _formKey.currentState?.save();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool asStudent = ref
            .watch(registrationOProvider)
            .state[StudentRegistrationPage.basicInfo]?["asStudent"]
            .toString() ==
        "true";
    final university = ref.watch(universityProvider);
    final init = ref
        .read(registrationOProvider)
        .state[StudentRegistrationPage.cityPicker];

    return FormBuilder(
      key: _formKey,
      initialValue: {},
      child: !asStudent
          ? _asRegularBody()
          : Stack(
              children: [
                Positioned(
                    top: 0,
                    right: 0,
                    child: Assets.images.marker
                        .image(fit: BoxFit.cover, height: 300)
                        .animate()
                        // inherits duration from fadeIn
                        .move(
                            duration:
                                300.ms) // runs after the above w/new duration

                    ),
                Positioned.fill(
                  child: ConstrainedBody(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 120,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                context.loc.pickCity,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              const SizedBox(
                                height: 24,
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
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Stack(
                                      children: [
                                        FormBuilderDropdown(
                                          iconSize: 0,
                                          onChanged: (value) {
                                            setState(() {
                                              _formKey.currentState!.save();
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
                                      key: ValueKey(
                                          "${_formKey.currentState?.value["city"]}uni"),
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
                                      key: ValueKey(
                                          "${_formKey.currentState?.value["city"]}uniy"),
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
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              const Spacer(),
                              NextButton(
                                onTap: () {
                                  if (_formKey.currentState!
                                      .saveAndValidate()) {
                                    RegistrationAction.of(ref).saveStateAndNext(
                                        StudentRegistrationPage.cityPicker,
                                        _formKey.currentState!.value);
                                  }
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
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

  Widget _asRegularBody() {
    return Stack(
      children: [
        Positioned(
            top: 0,
            right: 0,
            child: Assets.images.marker
                .image(fit: BoxFit.cover, height: 300)
                .animate()
                // inherits duration from fadeIn
                .move(duration: 300.ms) // runs after the above w/new duration

            ),
        Positioned.fill(
          child: ConstrainedBody(
            child: Column(
              children: [
                const SizedBox(
                  height: 120,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dozvoli pristup lokaciji",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 90.0),
                        child: Text(
                          "Da bi ti mogli prikazati poslove u tvojoj blizini, potrebno je da nam dozvoliš pristup lokaciji. Ako ne želiš da se tvoja lokacija koristi, odaberi grad u kojem se nalaziš.",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.white),
                        ),
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
                                  dropdownColor: Theme.of(context).primaryColor,
                                  validator: FormBuilderValidators.compose([
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
                                    ...ref.watch(cityProvider),
                                  ]
                                      .map((e) => DropdownMenuItem(
                                            alignment: Alignment.centerLeft,
                                            value: e,
                                            child: Container(
                                              child: Text(
                                                e,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Assets.images.dropdown
                                        .image(width: 14, height: 14),
                                  ),
                                )
                              ],
                            ).withTitle("Grad"),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Spacer(),
                      NextButton(
                        onTap: () {
                          if (_formKey.currentState!.saveAndValidate()) {
                            RegistrationAction.of(ref).saveStateAndNext(
                                StudentRegistrationPage.cityPicker,
                                _formKey.currentState!.value);
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 52,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final cityProvider = Provider<List<String>>((ref) {
  List<String> najveciGradoviUHrvatskoj = [
    "Zagreb",
    "Split",
    "Rijeka",
    "Osijek",
    "Zadar",
    "Pula",
    "Slavonski Brod",
    "Karlovac",
    "Sisak",
    "Varaždin",
    "Šibenik",
    "Dubrovnik",
    "Vukovar",
    "Bjelovar",
    "Koprivnica",
    "Poreč",
    "Vinkovci",
    "Virovitica",
    "Samobor",
    "Kutina",
  ];
  return najveciGradoviUHrvatskoj;
});

final universityProvider = FutureProvider<Map<String, List<String>>>((ref) {
  final service = ref.read(userServiceProvider);

  return service.getUniversityList();
});
