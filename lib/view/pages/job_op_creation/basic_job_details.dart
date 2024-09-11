import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/infra/observables/job_creation_state.dart';
import 'package:firmus/infra/stores/job_creation_notifier.dart';
import 'package:firmus/main.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:firmus/view/pages/registration/widgets/next_button.dart';
import 'package:firmus/view/shared/form/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class BasicJobDetails extends ConsumerStatefulWidget {
  static const title = "title";
  static const location = "location";
  static const payment = "payment";
  static const applyDeadline = "applyDeadline";
  static const workStartDate = "workStartDate";
  static const workEndDate = "workEndDate";
  static const description = "description";
  const BasicJobDetails({Key? key}) : super(key: key);

  @override
  ConsumerState<BasicJobDetails> createState() => _BasicJobDetailsState();
}

class _BasicJobDetailsState extends ConsumerState<BasicJobDetails> {
  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(
      height: 24,
    );
    final formKey =
        ref.watch(formKeyProvider)[JobCreationStatePage.basicJobDetails];
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
                      "Unesite osnovne podatke o poslu",
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
                          FormBuilderTextField(
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            style: Theme.of(context).textTheme.bodyLarge!,
                            decoration: invertedInputDecoration.copyWith(
                              hintText: "Naziv posla..",
                              hintStyle: hintStyle(context),
                            ),
                            textInputAction: TextInputAction.next,
                            name: BasicJobDetails.title,
                          ).withTitle("Naziv posla", invertColor: true),
                          spacer,
                          FormBuilderTextField(
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            style: Theme.of(context).textTheme.bodyLarge!,
                            decoration: invertedInputDecoration.copyWith(
                              hintStyle: hintStyle(context),
                              hintText: "Adresa obavljanja posla..",
                            ),
                            textInputAction: TextInputAction.next,
                            name: BasicJobDetails.location,
                          ).withTitle("Adresa", invertColor: true),
                          spacer,
                          const FirmusTextField(
                            name: BasicJobDetails.payment,
                            title: "Satnica",
                            hint: "Iznos eura po satu..",
                            inverted: true,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                          ),
                          // FormBuilderTextField(
                          //   autocorrect: false,
                          //   validator: FormBuilderValidators.compose([
                          //     FormBuilderValidators.required(),
                          //   ]),
                          //   style: Theme.of(context).textTheme.bodyLarge!,
                          //   decoration: invertedInputDecoration.copyWith(
                          //     hintText: "Iznos eura po satu..",
                          //     hintStyle: hintStyle(context),
                          //   ),
                          //   keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          //
                          //   textInputAction: TextInputAction.done,
                          //   name: BasicJobDetails.payment,
                          // ).withTitle("Satnica", invertColor: true),
                          spacer,

                          FormBuilderDateTimePicker(
                            firstDate: DateTime.now(),
                            inputType: InputType.date,
                            style: _textStyle,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            name: BasicJobDetails.applyDeadline,
                            scrollPadding: const EdgeInsets.only(bottom: 120),
                            textInputAction: TextInputAction.done,
                            cursorColor: Theme.of(context).primaryColor,
                            format: DateFormat("dd.MM.yyyy"),
                            decoration: invertedInputDecoration.copyWith(
                                hintText: "Rok za prijave",
                                hintStyle: hintStyle(context),
                                suffixIcon: const Icon(
                                  Icons.calendar_today_rounded,
                                  color: FigmaColors.neutralNeutral3,
                                )),
                          ).withTitle("Rok za prijave", invertColor: true),
                          spacer,
                          FormBuilderDateTimePicker(
                            firstDate: DateTime.now(),
                            inputType: InputType.date,
                            style: _textStyle,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            name: BasicJobDetails.workStartDate,
                            scrollPadding: const EdgeInsets.only(bottom: 120),
                            textInputAction: TextInputAction.done,
                            cursorColor: Theme.of(context).primaryColor,
                            format: DateFormat("dd.MM.yyyy"),
                            decoration: invertedInputDecoration.copyWith(
                                hintText: "Početak rada",
                                hintStyle: hintStyle(context),
                                suffixIcon: const Icon(
                                  Icons.calendar_today_rounded,
                                  color: FigmaColors.neutralNeutral3,
                                )),
                          ).withTitle("Početak rada", invertColor: true),
                          spacer,
                          FormBuilderDateTimePicker(
                            firstDate: DateTime.now(),
                            inputType: InputType.date,
                            style: _textStyle,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            name: BasicJobDetails.workEndDate,
                            scrollPadding: const EdgeInsets.only(bottom: 120),
                            textInputAction: TextInputAction.done,
                            cursorColor: Theme.of(context).primaryColor,
                            format: DateFormat("dd.MM.yyyy"),
                            decoration: invertedInputDecoration.copyWith(
                                hintText: "Završetak rada",
                                hintStyle: hintStyle(context),
                                suffixIcon: const Icon(
                                  Icons.calendar_today_rounded,
                                  color: FigmaColors.neutralNeutral3,
                                )),
                          ).withTitle("Završetak rada", invertColor: true),
                          spacer,
                          FormBuilderTextField(
                                  autocorrect: false,
                                  minLines: 2,
                                  maxLines: 5,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                  decoration: invertedInputDecoration.copyWith(
                                    hintText:
                                        "Kratki opis pozicije, ukoliko je postojeća pozicija unesite kao link..",
                                    hintStyle: hintStyle(context),
                                  ),
                                  textInputAction: TextInputAction.done,
                                  name: BasicJobDetails.description)
                              .withTitle("Opis posla",
                                  invertColor: true, large: true),
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
          if (!ref.watch(keyboardOnProvider))
            NextButton(
              invertColors: true,
              onTap: () async {
                bool valid = formKey.currentState!.saveAndValidate();

                if (valid) {
                  ref
                      .read(jobOpCreationNotifierProvider.notifier)
                      .nextPage(formKey.currentState!.value);
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

  Map<String, dynamic> initialValue() {
    return ref
            .read(jobOpCreationNotifierProvider)
            .state[JobCreationStatePage.basicJobDetails] ??
        {};
  }
}

TextStyle get _textStyle => const TextStyle(
    fontFamily: "SourceSansPro",
    color: Color(0xFF535D68),
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 16 / 14,
    letterSpacing: 1);
