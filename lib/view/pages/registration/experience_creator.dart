import 'package:firmus/models/student_experience.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ExperienceCreator extends ConsumerStatefulWidget {
  final StudentExperienceEntity? initialExperience;

  const ExperienceCreator({
    super.key,
    this.initialExperience,
  });

  Future<Object?> show(context) async {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (context) => this);
  }

  @override
  ConsumerState<ExperienceCreator> createState() => _ExperienceCreatorState();
}

class _ExperienceCreatorState extends ConsumerState<ExperienceCreator> {
  final key = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FormBuilder(
            key: key,
            initialValue: widget.initialExperience?.toMapForm() ?? {},
            child: ConstrainedBody(
              center: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: 120,
                    height: 7,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEAEEF2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    '💼 Unos iskustva ',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderTextField(
                    name: 'jobTitle',
                    style: _textStyle,
                    textInputAction: TextInputAction.next,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: greyRoundedInputDecoration.copyWith(
                      hintText: 'Naziv pozicije',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderTextField(
                    name: 'companyName',
                    style: _textStyle,
                    textInputAction: TextInputAction.next,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: greyRoundedInputDecoration.copyWith(
                      hintText: 'Naziv kompanije',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderTextField(
                    name: 'description',
                    style: _textStyle,
                    minLines: 3,
                    maxLines: 6,
                    scrollPadding: const EdgeInsets.only(bottom: 120),
                    textInputAction: TextInputAction.newline,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: greyRoundedInputDecoration.copyWith(
                      hintText: 'Kratki opis pozicije',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: FormBuilderDateTimePicker(
                            firstDate: DateTime(1990),
                            lastDate: DateTime.now(),
                            inputType: InputType.date,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            name: "start",
                            style: _textStyle,
                            scrollPadding: const EdgeInsets.only(bottom: 120),
                            textInputAction: TextInputAction.done,
                            cursorColor: Theme.of(context).primaryColor,
                            format: DateFormat("dd.MM.yyyy"),
                            decoration: greyRoundedInputDecoration.copyWith(
                                hintText: "Početak rada",
                                suffixIcon: const Icon(
                                  Icons.calendar_today_rounded,
                                  color: FigmaColors.neutralNeutral3,
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: FormBuilderDateTimePicker(
                            format: DateFormat("dd.MM.yyyy"),
                            firstDate: DateTime(1990),
                            lastDate: DateTime.now(),
                            initialEntryMode: DatePickerEntryMode.calendar,
                            inputType: InputType.date,
                            name: "end",
                            style: _textStyle,
                            scrollPadding: const EdgeInsets.only(bottom: 120),
                            textInputAction: TextInputAction.done,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: greyRoundedInputDecoration.copyWith(
                                hintText: "Kraj rada (neobavezno)",
                                suffixIcon: const Icon(
                                  Icons.calendar_today_rounded,
                                  color: FigmaColors.neutralNeutral3,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderCheckbox(
                    onChanged: (value) {
                      this.key.currentState?.save();

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
                        title: "Trenutno radim na ovoj poziciji",
                        required: false),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  PrimaryButton(
                      onTap: () {
                        key.currentState?.saveAndValidate();
                        final experience = StudentExperienceEntity.fromMap({
                          ...key.currentState!.value,
                          if (widget.initialExperience != null)
                            "id": widget.initialExperience?.id,
                        });
                        Navigator.of(context).pop(experience);
                      },
                      text: 'Spremi'),
                  const SizedBox(
                    height: 16,
                  ),
                  AnimatedTapButton(
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: Center(
                        child: Text(
                          "Odustani",
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle get _textStyle {
  return const TextStyle(
    fontFamily: "SourceSansPro",
    color: FigmaColors.neutralNeutral3,
    fontSize: 14,
    letterSpacing: 0.7,
    fontWeight: FontWeight.w600,
    height: 16 / 14,
  );
}

// Color(0xFFF4F6F9)
// radius 8
InputDecoration get greyRoundedInputDecoration => InputDecoration(
      hintStyle: _textStyle,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      fillColor: const Color(0xFFF4F6F9),
      filled: true,
    );
