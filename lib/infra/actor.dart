import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseActor {
  final ProviderContainer providerContainer;

  BaseActor(this.providerContainer);

  @protected
  @visibleForTesting
  T readObservable<T>(StateProvider<T> provider) {
    return providerContainer.read(provider);
  }

  @protected
  @visibleForTesting
  T read<T>(Provider<T> provider) {
    return providerContainer.read(provider);
  }

  @protected
  @visibleForTesting
  void writeObservable<T>(StateProvider<T> provider, T value,
      {bool cache = false}) {
    providerContainer.read(provider.notifier).state = value;
  }

  @mustCallSuper
  void dispose() {
    debugPrint('disposing $runtimeType');
  }
}
