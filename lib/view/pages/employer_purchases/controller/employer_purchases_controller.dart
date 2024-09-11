import 'dart:async';

import 'package:firmus/infra/services/purchases/entity/product.dart';
import 'package:firmus/infra/services/purchases/purchases_service.dart';
import 'package:firmus/view/pages/employer_purchases/controller/purchases_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final employerPurchasesControllerProvider = AsyncNotifierProvider.autoDispose<
    EmployerPurchasesController, EmployerPurchasesState>(() {
  return EmployerPurchasesController();
});

class EmployerPurchasesController
    extends AutoDisposeAsyncNotifier<EmployerPurchasesState> {
  @override
  FutureOr<EmployerPurchasesState> build() async {
    await ref.read(purchaseServiceProvider).init();
    final products = await ref.read(purchaseServiceProvider).getProducts();

    return EmployerPurchasesState(
        products: [...products as List<RevenuecatProduct>]);
  }

  Future<void> purchaseProduct(RevenuecatProduct product) async {
    final purchase =
        await ref.read(purchaseServiceProvider).purchaseProduct(product);
  }
}
