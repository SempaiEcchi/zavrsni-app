import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<T> warmupProvider<T>(WidgetRef ref, FutureProvider<T> provider) async {
  return ref.read(provider.future);
}
