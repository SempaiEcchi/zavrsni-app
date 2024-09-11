import 'package:collection/collection.dart';
import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/infra/actions/registration_action.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/models/job_profiles.dart';
import 'package:firmus/models/registration.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/registration/widgets/next_button.dart';
import 'package:firmus/view/pages/student_home/widges/job_tag_chip.dart';
import 'package:firmus/view/shared/popups/job_profile_frequency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../infra/observables/registration_observable.dart';

class TagPickerPage extends ConsumerStatefulWidget {
  const TagPickerPage({super.key});

  @override
  ConsumerState<TagPickerPage> createState() => _TagPickerPageState();
}

class _TagPickerPageState extends ConsumerState<TagPickerPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  String query = "";

  @override
  Widget build(BuildContext context) {
    final jobProfiles = ref.watch(jobProfilesProvider);
    return FormBuilder(
      key: _formKey,
      initialValue: ref
              .read(registrationOProvider)
              .state[StudentRegistrationPage.tagPicker] ??
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
                          context.loc.pickJobs,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        SizedBox(
                          height: 48,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                query = value;
                              });
                            },
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              fillColor: Colors.white.withOpacity(0.2),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              hintText: 'Pretraži',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (jobProfiles.value != null)
                          Expanded(
                            child: SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                              child: FadeAndTranslate(
                                autoStart: true,
                                translate: const Offset(0.0, 20.0),
                                duration: const Duration(milliseconds: 300),
                                child:
                                    FormBuilderField<List<SelectedJobProfile>>(
                                  initialValue: ref
                                                  .read(registrationOProvider)
                                                  .state[
                                              StudentRegistrationPage.tagPicker]
                                          ?["jobProfiles"] ??
                                      [],
                                  builder: (state) {
                                    bool isSelected(int it) {
                                      return state.value!.any((element) =>
                                          element.jobProfile.id == it);
                                    }

                                    return Wrap(
                                        runSpacing: 10,
                                        spacing: 8,
                                        children: list(jobProfiles)
                                            .map((e) =>
                                                SelectableJobProfileChip(
                                                    onLongPress: () async {
                                                      //todo: no adjustments
                                                      return;
                                                      final SelectedJobProfile
                                                          existing =
                                                          state.value!.firstWhereOrNull(
                                                                  (element) =>
                                                                      element
                                                                          .jobProfile
                                                                          .id ==
                                                                      e.id) ??
                                                              SelectedJobProfile(
                                                                jobProfile: e,
                                                              );

                                                      final updated =
                                                          await JobProfileFrequencyPopup(
                                                        profile: existing,
                                                      ).show(context);

                                                      final List<
                                                              SelectedJobProfile>
                                                          updatedState =
                                                          state.value!.toList();
                                                      updatedState
                                                          .remove(existing);
                                                      if (updated.frequency !=
                                                          MIN_FREQUENCY) {
                                                        updatedState
                                                            .add(updated);
                                                      }
                                                      state.didChange(
                                                          updatedState);
                                                      _formKey.currentState
                                                          ?.save();
                                                    },
                                                    large: true,
                                                    tag: e,
                                                    isSelected:
                                                        isSelected(e.id),
                                                    onTap: () {
                                                      var newState =
                                                          state.value!.toList();
                                                      if (isSelected(e.id)) {
                                                        newState.removeWhere(
                                                            (element) =>
                                                                element
                                                                    .jobProfile
                                                                    .id ==
                                                                e.id);
                                                      } else {
                                                        newState.add(
                                                            SelectedJobProfile(
                                                          jobProfile: e,
                                                        ));
                                                      }

                                                      state.didChange(newState);
                                                    }))
                                            .toList());
                                  },
                                  name: 'jobProfiles',
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 24,
                        ),
                        NextButton(
                          onTap: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              RegistrationAction.of(ref).saveStateAndNext(
                                  StudentRegistrationPage.tagPicker,
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

  List<JobProfile> list(AsyncValue<List<JobProfile>> jobProfiles) =>
      jobProfiles.value!
          .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
}
