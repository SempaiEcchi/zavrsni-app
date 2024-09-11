import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FirmusTextField extends StatelessWidget {
  final String name;
  final String title;
  final bool inverted;
  final validator;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool large;
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      cursorColor: Theme.of(context).primaryColor,
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      validator: validator ??
          FormBuilderValidators.compose(
            [
              FormBuilderValidators.required(),
            ],
          ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: [
        if (keyboardType == TextInputType.number ||
            keyboardType ==
                const TextInputType.numberWithOptions(signed: true) ||
            keyboardType == TextInputType.phone ||
            keyboardType ==
                const TextInputType.numberWithOptions(
                    decimal: true, signed: true))
          FilteringTextInputFormatter.digitsOnly,
      ],
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: inverted ? null : Colors.white),
      decoration:
          (inverted ? invertedInputDecoration : inputDecoration).copyWith(
        hintText: hint,
      ),
      name: name,
    ).withTitle(title, invertColor: inverted, large: large);
  }

  const FirmusTextField({
    super.key,
    this.keyboardType,
    this.large = false,
    this.textInputAction = TextInputAction.next,
    required this.name,
    required this.title,
    this.inverted = false,
    this.validator,
    this.hint,
  });
}
