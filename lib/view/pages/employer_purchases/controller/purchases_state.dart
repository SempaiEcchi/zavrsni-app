import 'package:equatable/equatable.dart';
import 'package:firmus/infra/services/purchases/entity/product.dart';

class EmployerPurchasesState extends Equatable {
  final List<RevenuecatProduct> products;

  const EmployerPurchasesState({required this.products});

  @override
  List<Object?> get props => [products];
}
