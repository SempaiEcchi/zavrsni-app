import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/observables/job_creation_state.dart';
import 'package:firmus/infra/stores/job_creation_notifier.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:firmus/view/pages/registration/widgets/next_button.dart';
import 'package:firmus/view/pages/student_home/home_page.dart';
import 'package:firmus/view/shared/form/full_screen_list_selector.dart';
import 'package:firmus/view/shared/form/text_field.dart';
import 'package:firmus/view/shared/popups/generic_error_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OtherJobDetails extends ConsumerStatefulWidget {
  static const language = "language";
  static const jobType = "jobType";
  static const employeesNeeded = "employeesNeeded";
  static const acceptOnlyStudents = "acceptOnlyStudents";
  static const jobProfile = "jobProfile";
  const OtherJobDetails({super.key});

  @override
  ConsumerState createState() => _OtherJobDetailsState();
}

class _OtherJobDetailsState extends ConsumerState<OtherJobDetails> {
  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(
      height: 24,
    );
    final jobProfiles = ref
            .watch(jobProfilesProvider)
            .valueOrNull
            ?.map((e) => e.name)
            .toList() ??
        [];
    final List<String>? languages = ref.watch(languagesProvider).valueOrNull;

    final formKey =
        ref.watch(formKeyProvider)[JobCreationStatePage.otherDetails];

    return FormBuilder(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: initialValue(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ConstrainedBody(
              center: false,
              child: SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Ostale informacije",
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
                          FullscreenPickerField<List<String?>>(
                                  inverted: true,
                                  name: "language",
                                  displayText: (item) {
                                    return item.join(", ");
                                  },
                                  onTap: (state) {
                                    final initial = state.value;
                                    FullScreenListSelector<String>(
                                      initialSelectedItems: [
                                        if (initial != null) ...initial,
                                      ],
                                      initialItems: languages ?? <String>[],
                                      title: "Jezik",
                                      subtitle: "Odaberite jezik",
                                      multi: true,
                                      onSave: (selectedItems) async {
                                        state.didChange(selectedItems);
                                        setState(() {});
                                      },
                                    ).show(context);
                                  })
                              .withTitle("Potrebni jezici", invertColor: true),
                          spacer,
                          Stack(
                            children: [
                              FormBuilderDropdown(
                                iconSize: 0,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                style: Theme.of(context).textTheme.bodyLarge!,
                                decoration: invertedInputDecoration,
                                name: 'jobType',
                                initialValue: JobType.FULL_TIME,
                                items: [
                                  ...JobType.values,
                                ]
                                    .map((e) => DropdownMenuItem(
                                          alignment: Alignment.centerLeft,
                                          value: e,
                                          child: Container(
                                            child: Text(
                                              e.formattedName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Assets.images.dropdown.image(
                                      width: 14,
                                      height: 14,
                                      color: FigmaColors.neutralNeutral7),
                                ),
                              )
                            ],
                          ).withTitle("Tip posla", invertColor: true),
                          spacer,
                          const FirmusTextField(
                            name: 'employeesNeeded',
                            title: 'Broj potrebnih radnika',
                            inverted: true,
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                          ),
                          spacer,
                          FullscreenPickerField<String>(
                              inverted: true,
                              name: OtherJobDetails.jobProfile,
                              displayText: (item) => item,
                              onTap: (state) {
                                final initial = state.value;
                                FullScreenListSelector<String>(
                                  initialSelectedItems: [
                                    if (initial != null) initial
                                  ],
                                  displayText: (item) => item,
                                  initialItems: jobProfiles ?? <String>[],
                                  title: "Pozicija",
                                  subtitle: "Odaberite naziv pozicije",
                                  multi: false,
                                  onSave: (List<String> selectedItems) async {
                                    state.didChange(selectedItems.firstOrNull);
                                    setState(() {});
                                  },
                                ).show(context);
                              }).withTitle("Naziv pozicije", invertColor: true),
                          spacer,
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
          ),
          NextButton(
            invertColors: true,
            onTap: () async {
              bool valid = formKey.currentState!.saveAndValidate();
              setState(() {});
              if (valid) {
                ref
                    .read(jobOpCreationNotifierProvider.notifier)
                    .save(formKey.currentState!.value);
                setState(() {});
                //
                try {
                  await ref
                      .read(jobOpCreationNotifierProvider.notifier)
                      .createJob();
                  ref
                      .read(currentPageProvider.notifier)
                      .changePage(HomePages.savedJobs);
                  GoRouter.of(context).pushReplacement(RoutePaths.home);
                  logger.info("Job created");
                } catch (e, st) {
                  FirebaseCrashlytics.instance.recordError(e, st);
                  const GenericErrorPopup(
                    title: "Greška prilikom izrade oglasa",
                    description:
                        "Došlo je do greške prilikom izrade oglasa. Molimo pokušajte ponovo.",
                  ).showPopup(context);
                }
              }
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
        .state[JobCreationStatePage.otherDetails];
  }
}

class FullscreenPickerField<T> extends HookWidget {
  final String name;
  final Function(FormBuilderFieldState state) onTap;
  final String Function(T item)? displayText;
  final bool inverted;
  @override
  Widget build(BuildContext context) {
    final key = useMemoized(
      () => GlobalKey<FormBuilderFieldState>(),
    );
    return InkWell(
      onTap: () {
        FormBuilder.of(context)?.save();
        onTap.call(key.currentState!);
      },
      child: FormBuilderField<T?>(
        key: key,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
        name: name,
        builder: (FormFieldState<T?> field) {
          String text = field.value.toString() ?? "";
          if (text.isEmpty) text = "Odaberite";
          if (text == "null") text = "Odaberite";
          if (displayText != null && field.value != null)
            text = displayText!(field.value as T);

          final decoration =
              inverted ? invertedInputDecoration : inputDecoration;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.fromBorderSide(field.hasError
                        ? decoration.errorBorder!.borderSide
                        : decoration.border!.borderSide),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          text,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: inverted ? null : Colors.white,
                                  ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Assets.images.dropdown.image(
                            width: 14,
                            height: 14,
                            color: FigmaColors.neutralNeutral7),
                      )
                    ],
                  )),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8.0),
                  child: Text(field.errorText!,
                      style:
                          (inverted ? invertedInputDecoration : inputDecoration)
                              .errorStyle
                              ?.copyWith()),
                )
            ],
          );
        },
      ),
    );
  }

  const FullscreenPickerField({
    super.key,
    required this.name,
    required this.onTap,
    this.displayText,
    this.inverted = false,
  });
}
