import 'package:firmus/infra/actor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseService extends BaseActor {
  BaseService(ProviderContainer providerContainer) : super(providerContainer);
}
