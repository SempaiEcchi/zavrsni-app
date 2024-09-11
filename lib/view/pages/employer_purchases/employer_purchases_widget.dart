import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/purchases/entity/product.dart';
import 'package:firmus/view/pages/employer_purchases/controller/employer_purchases_controller.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmployerPurchasesSheet extends ConsumerStatefulWidget {
  const EmployerPurchasesSheet({super.key});

  Future<Object?> show(BuildContext context) async {
    final value = await showModalBottomSheet<Object?>(
      context: context,
      isScrollControlled: true,
      builder: (context) => this,
    );
    return value;
  }

  @override
  ConsumerState<EmployerPurchasesSheet> createState() =>
      _EmployerPurchasesSheetState();
}

class _EmployerPurchasesSheetState
    extends ConsumerState<EmployerPurchasesSheet> {
  RevenuecatProduct? _selectedProduct;

  set selectedProduct(RevenuecatProduct? product) {
    setState(() {
      _selectedProduct = product;
    });
  }

  RevenuecatProduct? get selectedProduct => _selectedProduct;

  @override
  Widget build(
    BuildContext context,
  ) {
    final notifier = ref.read(employerPurchasesControllerProvider.notifier);
    return Container(
        constraints: const BoxConstraints(maxHeight: 550),
        child: FutureBuilder(
          future: ref.watch(employerPurchasesControllerProvider.future),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              logger.info(snapshot.stackTrace);
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.hasData) {
              final products = (snapshot.requireData).products;
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Firmus pretplate",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontFamily: "SourceSansPro",
                        color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ListTile(
                          leading: Radio<RevenuecatProduct>(
                            value: product,
                            groupValue: selectedProduct,
                            onChanged: (RevenuecatProduct? value) {
                              setState(() {
                                selectedProduct = value;
                              });
                            },
                          ),
                          title: Text(product.name),
                          subtitle: Text(product.description),
                          trailing: Text(product.price),
                          onTap: () async {
                            selectedProduct = product;
                          },
                        );
                      },
                    ),
                  ),
                  if (selectedProduct != null)
                    PrimaryButton(
                        onTap: () {
                          notifier.purchaseProduct(selectedProduct!);
                        },
                        text: "Kupi"),
                  const SizedBox(
                    height: 52,
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
