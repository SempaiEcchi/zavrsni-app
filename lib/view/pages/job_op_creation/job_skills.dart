import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/helper/keyboard_on.dart';
import 'package:firmus/infra/observables/job_creation_state.dart';
import 'package:firmus/infra/stores/job_creation_notifier.dart';
import 'package:firmus/models/job_skill.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/next_button.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class JobSkillPicker extends ConsumerStatefulWidget {
  static const skills = "skills";
  const JobSkillPicker({super.key});

  @override
  ConsumerState createState() => _JobSkillPickerState();
}

class _JobSkillPickerState extends ConsumerState<JobSkillPicker> {
  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(
      height: 24,
    );
    final AsyncValue<List<JobSkill>> jobSkills = ref.watch(jobSkillsProvider);
    final formKey = ref.watch(formKeyProvider)[JobCreationStatePage.skills];

    return FormBuilder(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: initialValue(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Odaberite potrebne vještine",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: FigmaColors.neutralNeutral1),
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
                        if (jobSkills.valueOrNull != null)
                          TagPickerFormField<JobSkill>(
                            name: JobSkillPicker.skills,
                            inverted: true,
                            builder: (item, isSelected, state) {
                              return SelectableJobSkillChip(
                                  tag: item, isSelected: isSelected);
                            },
                            values: jobSkills.requireValue,
                          ),
                        const SizedBox(
                          height: 52,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!ref.isKeyboardOn)
            NextButton(
              invertColors: true,
              onTap: () async {
                bool valid = formKey.currentState!.saveAndValidate();

                if (valid) {
                  ref.read(jobOpCreationNotifierProvider.notifier).nextPage(
                        formKey.currentState!.value,
                      );
                }

                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  TextStyle hintStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5));
  }

  initialValue() {
    return ref
        .read(jobOpCreationNotifierProvider)
        .state[JobCreationStatePage.skills];
  }
}

class SelectableJobSkillChip extends StatelessWidget {
  final JobSkill tag;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedTapButton(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : FigmaColors.neutralNeutral4,
            width: 2,
          ),
          color: isSelected ? const Color(0xffEEF2FA) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tag.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "SourceSansPro",
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : FigmaColors.neutralNeutral4,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  const SelectableJobSkillChip({
    super.key,
    required this.tag,
    required this.isSelected,
    this.onTap,
  });
}

class TagPickerFormField<T> extends HookWidget {
  final String name;
  final List<T> values;
  final Widget Function(T item, bool isSelected, FormFieldState<List<T>>)
      builder;
  final bool inverted;
  const TagPickerFormField({
    super.key,
    required this.name,
    required this.values,
    required this.builder,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    final query = useState("");
    return FormBuilderField<List<T>>(
      validator: FormBuilderValidators.compose([
        (value) {
          if (value!.isEmpty) {
            return "Odaberite barem jednu vještinu";
          }
          return null;
        },
      ]),
      builder: (state) {
        final selected = state.value!;
        final items = values
            .where((element) => element
                .toString()
                .toLowerCase()
                .contains(query.value.toLowerCase()))
            .toList();
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: TextFormField(
                onChanged: (value) {
                  query.value = value;
                },
                decoration:
                    (inverted ? invertedInputDecoration : inputDecoration)
                        .copyWith(
                  hintText: "Pretraži vještine",
                  suffixIcon: Icon(Icons.search,
                      color: inverted
                          ? FigmaColors.neutralNeutral4
                          : Theme.of(context).primaryColor),
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  state.errorText!,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              // alignment: WrapAlignment.spaceAround,
              runAlignment: WrapAlignment.center,
              alignment: WrapAlignment.center,
              // alignment: WrapAlignment.spaceAround,
              runSpacing: 10,
              spacing: 8,
              children: [
                ...items.map(
                  (T e) => AnimatedTapButton(
                      onTap: () {
                        if (selected.contains(e)) {
                          selected.remove(e);
                        } else {
                          selected.add(e);
                        }
                        state.didChange(selected);
                        state.save();
                      },
                      child: builder(e, selected.contains(e), state)),
                ),
              ],
            ),
          ],
        );
      },
      name: name,
    );
  }
}
