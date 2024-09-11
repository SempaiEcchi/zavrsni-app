import 'package:collection/collection.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/view/pages/job_op_creation/other_job_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FieldTitle extends StatelessWidget {
  final String title;
  final bool required;
  final bool invertColor;
  FieldTitle({
    required this.title,
    required this.required,
    this.invertColor = false,
  }) : super(key: ValueKey(title));

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: invertColor ? null : Colors.white),
            children: <InlineSpan>[
          if (required)
            TextSpan(
                text: '*',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.error))
        ]));
  }
}

extension WithTitle on Widget {
  Widget withTitle(String title,
      {bool large = false, bool required = true, bool invertColor = false}) {
    bool hasError = false;

    Widget child = this;
    if (this is Stack) {
      child = (this as Stack)
              .children
              .firstWhereOrNull((element) => element is FormBuilderDropdown) ??
          this;
    }
    String? errorText;

    return Builder(builder: (context) {
      try {
        errorText = FormBuilder.of(context)?.errors[(child as dynamic).name];

        if (child is FormBuilderFieldDecoration) {
          hasError =
              FormBuilder.of(context)?.errors.containsKey((child).name) ??
                  false;
        } else if (child is FullscreenPickerField) {
          hasError =
              FormBuilder.of(context)?.errors.containsKey((child).name) ??
                  false;
        } else if (child is FormBuilderDateTimePicker) {
          hasError =
              FormBuilder.of(context)?.errors.containsKey((child).name) ??
                  false;
        } else {
          hasError = FormBuilder.of(context)
                  ?.errors
                  .containsKey((child as dynamic).name) ??
              false;
        }
      } catch (e) {
        logger.info(e);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: FieldTitle(
                title: title, required: required, invertColor: invertColor),
          ),
          const SizedBox(height: 10),
          SizedBox(height: large ? null : (hasError ? 68 : 48), child: this),
          if (invertColor == false)
            if (errorText != null)
              if (errorText!.isNotEmpty)
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: SizedBox(
                    height: 26,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                          top: 6, left: 16, right: 8, bottom: 6),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFEEFEF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        errorText!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFDA1414),
                          fontSize: 9,
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                )
        ],
      );
    });
  }
}
