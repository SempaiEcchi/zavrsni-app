import 'package:firmus/models/job_offers.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class BasicJobInfoEditSheet extends ConsumerStatefulWidget {
  final JobOpportunity jobOpportunity;

  const BasicJobInfoEditSheet({
    super.key,
    required this.jobOpportunity,
  });

  Future<Object?> show(context) async {
    return showModalBottomSheet(
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
  ConsumerState<BasicJobInfoEditSheet> createState() =>
      _BasicJobInfoEditSheetState();
}

class _BasicJobInfoEditSheetState extends ConsumerState<BasicJobInfoEditSheet> {
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
            initialValue: {
              "jobTitle": widget.jobOpportunity.jobTitle,
              "location": widget.jobOpportunity.location,
              "rate": widget.jobOpportunity.payment.amount.toString(),
              "applyDeadline": widget.jobOpportunity.applyDeadline,
            },
            child: SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

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
                      "Uredi detalje oglasa",
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
                      name: 'location',
                      style: _textStyle,
                      textInputAction: TextInputAction.next,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: greyRoundedInputDecoration.copyWith(
                        hintText: 'Lokacija',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    FormBuilderDateTimePicker(
                      firstDate: DateTime(1990),
                      lastDate: DateTime(2026),
                      inputType: InputType.date,
                      initialEntryMode: DatePickerEntryMode.calendar,
                      name: "applyDeadline",
                      style: _textStyle,
                      scrollPadding: const EdgeInsets.only(bottom: 120),
                      textInputAction: TextInputAction.done,
                      cursorColor: Theme.of(context).primaryColor,
                      format: DateFormat("dd.MM.yyyy"),
                      decoration: greyRoundedInputDecoration.copyWith(
                          hintText: "Rok za prijavu",
                          suffixIcon: const Icon(
                            Icons.calendar_today_rounded,
                            color: FigmaColors.neutralNeutral3,
                          )),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    FormBuilderTextField(
                      name: 'rate',
                      style: _textStyle,
                      textInputAction: TextInputAction.next,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: greyRoundedInputDecoration.copyWith(
                        suffixIcon: const Icon(
                          Icons.euro_rounded,
                          color: FigmaColors.neutralNeutral3,
                        ),
                        hintText: 'Satnica',
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    PrimaryButton(
                        onTap: () {
                          key.currentState?.saveAndValidate();

                          Navigator.of(context).pop();
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
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle get _textStyle => const TextStyle(
    fontFamily: "SourceSansPro",
    color: Color(0xFF535D68),
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 16 / 14,
    letterSpacing: 1);
// Color(0xFFF4F6F9)
// radius 8
InputDecoration get greyRoundedInputDecoration => InputDecoration(
      hintStyle: _textStyle.copyWith(color: _textStyle.color!.withOpacity(0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      fillColor: const Color(0xFFF4F6F9),
      filled: true,
    );
