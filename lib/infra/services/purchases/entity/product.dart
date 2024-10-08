import 'package:equatable/equatable.dart';
// import 'package:purchases_flutter/models/package_wrapper.dart';
//
typedef RevenuecatProduct = ProductEntity<dynamic>;

class ProductEntity<T> extends Equatable {
  final String id;
  final String name;
  final String description;
  final String price;

  // This is the original object from the purchases library
  final T implRef;
  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.implRef,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        implRef,
      ];
}
