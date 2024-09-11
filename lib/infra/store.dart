import 'package:firmus/infra/actor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseStore extends BaseActor {
  BaseStore(ProviderContainer providerContainer) : super(providerContainer);
}
