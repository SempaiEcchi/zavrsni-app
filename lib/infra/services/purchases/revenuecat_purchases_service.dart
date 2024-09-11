// import 'dart:io';
//
// import 'package:firmus/infra/services/purchases/entity/product.dart';
// import 'package:firmus/infra/services/purchases/entity/purchase_entity.dart';
// import 'package:firmus/infra/services/purchases/purchases_service.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// import '../../../helper/logger.dart';
//
// class RevenuecatPurchasesService implements PurchasesService {
//   bool initialized = false;
//
//   @override
//   Future<PurchaseEntity> init() async {
//     if (initialized) {
//       return _getPurchaseStatus();
//     }
//     await Purchases.setLogLevel(LogLevel.verbose);
//
//     late PurchasesConfiguration configuration;
//     if (Platform.isAndroid) {
//       configuration = PurchasesConfiguration("");
//     } else if (Platform.isIOS) {
//       configuration =
//           PurchasesConfiguration("appl_vaCBmNtrsmlrCFVpBhcpzagyizc");
//     } else {
//       throw Exception("Platform not supported");
//     }
//
//     await Purchases.configure(configuration);
//     final status = await _getPurchaseStatus();
//     initialized = true;
//     return status;
//   }
//
//   @override
//   Future<List<ProductEntity>> getProducts() {
//     return Purchases.getOfferings().then((value) {
//       logger.info(value.all);
//       return value.current?.availablePackages
//               .map((e) => RevenuecatProduct(
//                     implRef: e,
//                     id: e.identifier,
//                     name: e.storeProduct.title,
//                     description: e.storeProduct.description,
//                     price: e.storeProduct.priceString,
//                   ))
//               .toList() ??
//           [];
//     });
//   }
//
//   @override
//   Future<PurchaseEntity> purchaseProduct(ProductEntity product) {
//     return Purchases.purchasePackage((product as RevenuecatProduct).implRef)
//         .then((value) async {
//       await Purchases.syncPurchases();
//       return _getPurchaseStatus();
//     });
//   }
//
//   @override
//   Future<PurchaseEntity> restorePurchases() async {
//     await Purchases.restorePurchases();
//     return _getPurchaseStatus();
//   }
//
//   Future<PurchaseEntity> _getPurchaseStatus() async {
//     final customer = await _getCustomerInfo();
//     return PurchaseEntity(
//       premiumActive: customer.entitlements.all["pro"]?.isActive ?? false,
//       isTrial: customer.entitlements.all["pro"]?.periodType == PeriodType.trial,
//     );
//   }
//
//   Future<CustomerInfo> _getCustomerInfo() async {
//     await Purchases.invalidateCustomerInfoCache();
//     return Purchases.getCustomerInfo();
//   }
// }
