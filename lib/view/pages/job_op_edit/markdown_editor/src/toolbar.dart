import 'package:flutter/material.dart';

class ToolbarResult {
  final int baseOffset;
  final int extentOffset;
  final String text;

  ToolbarResult({
    required this.baseOffset,
    required this.text,
    required this.extentOffset,
  });
}

class Toolbar {
  final TextEditingController controller;
  final VoidCallback? bringEditorToFocus;

  Toolbar({required this.controller, this.bringEditorToFocus});

  /// Returns true if  controller contains selection text
  ///
  /// else returns false
  bool get hasSelection =>
      (controller.selection.baseOffset - controller.selection.extentOffset) !=
      0;

  // get selection text pffset
  TextSelection getSelection(TextSelection selection) {
    return !selection.isValid
        ? selection.copyWith(
            baseOffset: controller.text.length,
            extentOffset: controller.text.length,
          )
        : selection;
  }

  // toolbar action
  void action(String left, String right, {TextSelection? textSelection}) {
    // Keep this as it is
    // Dont remove or place in the end
    bringEditorToFocus?.call();

    // if (!focusNode.hasFocus) {
    //   logger.info('Editor is not in focus');

    //   isEditorFocused(true);
    //   focusNode.requestFocus();
    // }

    // default parameter
    final String currentTextValue = controller.value.text;
    TextSelection selection = textSelection ?? controller.selection;
    selection = getSelection(selection);

    final String middle = selection.textInside(currentTextValue);
    String selectionText = '$left$middle$right';
    int baseOffset = left.length + middle.length;
    int extentOffset = selection.extentOffset + left.length + right.length;

    // check if middle text have char \n
    if (middle.split("\n").length > 1) {
      ToolbarResult result =
          _multiLineFormating(left, middle, right, selection.extentOffset);
      selectionText = result.text;
      baseOffset = result.baseOffset;
      extentOffset = result.extentOffset;
    }

    // check if middle not have char \n
    if (middle.contains(left) &&
        middle.contains(right) &&
        middle.split("\n").length < 2) {
      selectionText = middle.replaceFirst(left, "").replaceFirst(right, "");
      baseOffset = middle.length - (left.length + right.length);
      extentOffset = selection.extentOffset - (left.length + right.length);
    }

    final String newTextValue = selection.textBefore(currentTextValue) +
        selectionText +
        selection.textAfter(currentTextValue);

    // logger.info(selection.extentOffset - (left.length + right.length));

    controller.value = controller.value.copyWith(
      text: newTextValue,
      selection: selection.baseOffset == selection.extentOffset
          ? TextSelection.collapsed(
              offset: selection.baseOffset + baseOffset,
            )
          : TextSelection(
              baseOffset: selection.baseOffset,
              extentOffset: extentOffset,
            ),
    );
  }

  // multiline formating
  ToolbarResult _multiLineFormating(
    String left,
    String middle,
    String right,
    int selection,
  ) {
    final List<String> splitData = middle.split("\n");
    int index = 0;
    int resetLength = 0;
    int addLength = 0;

    final String selectionText = splitData.map((text) {
      index++;
      addLength += left.length + right.length;

      if (text.contains(left) && text.contains(right)) {
        resetLength += left.length + right.length;

        return index == splitData.length
            ? text.replaceFirst(left, "").replaceFirst(right, "")
            : "${text.replaceFirst(left, "").replaceFirst(right, "")}\n";
      }

      if (text.trim().isEmpty) {
        addLength -= left.length + right.length;
      }

      final String newText = text.trim().isEmpty ? text : "$left$text$right";
      return index == splitData.length ? newText : "$newText\n";
    }).join();

    final int baseOffset = addLength + (middle.length - (resetLength * 2));
    final int extentOffset = selection + addLength - (resetLength * 2);

    return ToolbarResult(
      baseOffset: baseOffset,
      text: selectionText,
      extentOffset: extentOffset,
    );
  }

  void selectSingleLine() {
    TextSelection currentPosition = controller.selection;
    if (!currentPosition.isValid) {
      currentPosition = currentPosition.copyWith(
        baseOffset: 0,
        extentOffset: 0,
      );
    }
    String textBefore = currentPosition.textBefore(controller.text);
    String textAfter = currentPosition.textAfter(controller.text);

    textBefore = textBefore.split("\n").last;
    textAfter = textAfter.split("\n")[0];

    final int firstTextPosition =
        controller.text.indexOf(textBefore + textAfter);
    controller.value = controller.value.copyWith(
      selection: TextSelection(
        baseOffset: firstTextPosition,
        extentOffset: firstTextPosition + (textBefore + textAfter).length,
      ),
    );
  }
}
