import 'package:firmus/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension Kb on WidgetRef {
  bool get isKeyboardOn => watch(keyboardOnProvider);
}
