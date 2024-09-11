import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class GenderField extends StatelessWidget {
  const GenderField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String?>(
      builder: (state) {
        return Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: state.value == "M"
                        ? Colors.white.withOpacity(0.2)
                        : null,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    border: state.value != "F"
                        ? Border.all(color: Colors.white, width: 1)
                        : null,
                  ),
                  child: InkWell(
                    onTap: () {
                      state.didChange("M");
                    },
                    child: genderColumn(
                      Assets.images.male.image(width: 35),
                      "Muško",
                      context,
                    ),
                  ),
                ),
              ),
              const VerticalDivider(
                color: Colors.white,
                width: 1,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: state.value == "F"
                        ? Colors.white.withOpacity(0.2)
                        : null,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: state.value == "F"
                        ? Border.all(color: Colors.white, width: 1)
                        : null,
                  ),
                  child: InkWell(
                    onTap: () {
                      state.didChange("F");
                    },
                    child: genderColumn(
                      Assets.images.female.image(width: 35),
                      "Žensko",
                      context,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      name: "gender",
    ).withTitle("Spol", large: true);
  }

  Widget genderColumn(Widget image, String text, context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 2),
          Expanded(child: image),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
