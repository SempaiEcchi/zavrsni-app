import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/infra/actions/registration_action.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/models/registration.dart';
import 'package:firmus/view/pages/registration/experience_creator.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/registration/widgets/next_button.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../infra/observables/registration_observable.dart';
import '../../../../models/student_experience.dart';
import '../widgets/experience_tile.dart';

class ExperiencePickerPage extends ConsumerStatefulWidget {
  const ExperiencePickerPage({super.key});

  @override
  ConsumerState<ExperiencePickerPage> createState() =>
      _ExperiencePickerPageState();
}

class _ExperiencePickerPageState extends ConsumerState<ExperiencePickerPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      initialValue: ref
              .read(registrationOProvider)
              .state[StudentRegistrationPage.experiencePicker] ??
          {},
      child: Stack(
        children: [
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
                          context.loc.pickExperience,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          context.loc.pickExperienceSubtitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Expanded(
                          child:
                              FormBuilderField<List<StudentExperienceEntity>>(
                            builder: (state) {
                              final count = (state.value?.length ?? 0) + 1;
                              return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 16,
                                ),
                                itemCount: count,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  if (index == count - 1) {
                                    return AnimatedTapButton(
                                      onTap: () {
                                        createExperience(state);
                                      },
                                      child: Center(
                                        child: SizedBox(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Assets.images.roundedAdd
                                                  .image(width: 90),
                                              Assets
                                                  .images.dodajPoslovnoIskustvo
                                                  .image(width: 232),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  final item = state.value![index];
                                  return Dismissible(
                                    onDismissed: (direction) {
                                      final experiences = state.value ?? [];
                                      experiences.removeWhere(
                                          (element) => element.id == item.id);
                                      state.didChange(experiences);
                                    },
                                    key: ValueKey(item.id),
                                    child: ExperienceTile(
                                      experience: item,
                                      onTap: () {
                                        createExperience(state, initial: item);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            name: "experiences",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            context.loc.experienceOptional,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.white.withOpacity(0.8)),
                          ),
                        ),
                        NextButton(
                          onTap: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              saveState();

                              RegistrationAction.of(ref).next();
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

  @override
  void saveState() {
    _formKey.currentState!.save();
    RegistrationAction.of(ref).saveState(
        StudentRegistrationPage.experiencePicker,
        Map.from(_formKey.currentState!.value));
  }

  void createExperience(FormFieldState<List<StudentExperienceEntity>> state,
      {StudentExperienceEntity? initial}) async {
    final value = await ExperienceCreator(
      initialExperience: initial,
    ).show(context);
    if (value is StudentExperienceEntity) {
      final experiences = state.value ?? [];
      experiences.removeWhere((element) => element.id == value.id);
      experiences.add(value);
      state.didChange(experiences);
    }
  }
}
