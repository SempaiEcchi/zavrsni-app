class FirmusForm {
  final List<FormStep> steps;

  const FirmusForm({
    required this.steps,
  });
}

class FormStep {
  final String title;
  final List<FirmusFormField> fields;

  const FormStep({
    required this.title,
    required this.fields,
  });
}

enum FieldTypes {
  video,
  textField,
  datePicker,
  dropdown,
  fullScreenPicker,
  dropDown,
}

sealed class FirmusFormField {
  late final String name;
  late final String label;
  late final bool isRequired;

  FirmusFormField();

  // factory FirmusFormField.fromMap(Map<String, dynamic> map) {
  //   final type = FieldTypes.values.byName(map["type"].toString());
  //   switch (type) {
  //     case FieldTypes.video:
  //       // return FirmusVideoFormField.fromMap(map);
  //     case FieldTypes.textField:
  //       return FirmusTextFormField.fromMap(map);
  //     case FieldTypes.datePicker:
  //       // return FirmusDatePickerFormField.fromMap(map);
  //     case FieldTypes.dropdown:
  //       // return FirmusDropdownFormField.fromMap(map);
  //     case FieldTypes.fullScreenPicker:
  //       // return FirmusFullScreenPickerFormField.fromMap(map);
  //     case FieldTypes.dropDown:
  //       // return FirmusDropDownFormField.fromMap(map);
  //   }
  // }
}

class FirmusTextFormField extends FirmusFormField {
  final String? hint;
  final bool isNumber;
  final bool isEmail;

  FirmusTextFormField({
    this.hint,
    required this.isNumber,
    required this.isEmail,
  });

  factory FirmusTextFormField.fromMap(Map<String, dynamic> map) {
    return FirmusTextFormField(
      hint: map["hint"] as String?,
      isNumber: map["isNumber"].toString() == "true",
      isEmail: map["isEmail"].toString() == "true",
    );
  }
}
