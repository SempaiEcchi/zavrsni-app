import 'dart:io';

import 'package:firmus/infra/services/purchases/entity/product.dart';
import 'package:firmus/infra/services/purchases/entity/purchase_entity.dart';
import 'package:firmus/infra/services/purchases/mock_purchase_service.dart';
import 'package:firmus/infra/services/purchases/revenuecat_purchases_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final purchaseServiceProvider = Provider<PurchasesService>((ref) {
  // if (Platform.isIOS) {
  //   return RevenuecatPurchasesService();
  // }
  return MockPurchaseService();
});

abstract interface class PurchasesService {
  Future<PurchaseEntity> init();
  Future<List<ProductEntity>> getProducts();
  Future<PurchaseEntity> purchaseProduct(ProductEntity product);
  Future<PurchaseEntity> restorePurchases();
}
