import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/helper/image_picker.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../helper/logger.dart';
import '../../pages/registration/widgets/constrained_body.dart';
import 'admin_home.dart';

class CompaniesView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = ref.watch(companiesProvider);
    return ConstrainedBody(
      child: companies.when(
        data: (companies) {
          final scaffold = Scaffold.of(context);
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                CreateCompanyDialog().show(context);
              },
              child: const Icon(Icons.add),
            ),
            body: ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
                return ListTile(
                  onTap: () {
                    ref.read(adminNavProvider.notifier).navigateTo(
                          JobOffersPage(company),
                        );
                  },
                  title: Text(company.name),
                  subtitle: Text(company.phoneNumber),
                  leading: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(company.logoUrl),
                  ),
                  trailing: Text(company.rating.toString()),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
    );
  }
}

class CreateCompanyDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreateCompanyDialog> createState() =>
      _CreateCompanyDialogState();

  //show
  Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return this;
      },
    );
  }
}

class _CreateCompanyDialogState extends ConsumerState<CreateCompanyDialog> {
  final key = GlobalKey<FormBuilderState>();

  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBody(
      child: Dialog(
        child: FormBuilder(
            key: key,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormBuilderTextField(
                    name: "name",
                    decoration: InputDecoration(labelText: "Name"),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderTextField(
                    name: "description",
                    decoration: InputDecoration(labelText: "Description"),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderTextField(
                    name: "representative",
                    decoration: InputDecoration(labelText: "Representative"),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderTextField(
                    name: "oib",
                    decoration: InputDecoration(labelText: "OIB"),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderTextField(
                    name: "phone_number",
                    decoration: InputDecoration(labelText: "Phone number"),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderTextField(
                    name: "location_name",
                    decoration: InputDecoration(labelText: "Location"),
                    validator: FormBuilderValidators.required(),
                  ),
                  //Select image button that works on web
                  Row(
                    children: [
                      if (image != null)
                        Container(
                          width: 100,
                          height: 100,
                          child: Image.memory(image!),
                        ),
                      ElevatedButton(
                        onPressed: () async {
                          pickImage().then((v) async {
                            final bytes = await v!.readAsBytes();
                            setState(() {
                              image = bytes;
                            });
                          });
                        },
                        child: Text("Select image"),
                      ),
                    ],
                  ),

                  PrimaryButton(
                    onTap: () async {
                      if (image == null) return;
                      if (key.currentState!.saveAndValidate()) {
                        logger.info("Creating company");
                        await ref.read(httpServiceProvider).request(
                          converter: (resp) {
                            return resp;
                          },
                          PostRequest(
                            endpoint: "/user/admin-company",
                            body: {
                              "logo": base64Encode(image!),
                              ...key.currentState!.value
                            },
                          ),
                        );
                        ref.invalidate(companiesProvider);
                        Navigator.of(context).pop();
                      } else {
                        print("Validation failed");
                      }
                    },
                    text: "Create",
                  ),
                ].padChildren())),
      ),
    );
  }
}

final companiesProvider =
    FutureProvider.autoDispose<List<SimpleCompany>>((ref) async {
  return ref
      .read(httpServiceProvider)
      .request(GetRequest(endpoint: "/user/companies"), converter: (resp) {
    return (resp["data"] as List).map((e) => SimpleCompany.fromMap(e)).toList();
  });
});

extension PadChildren on List<Widget> {
  List<Widget> padChildren() {
    const spacer = SizedBox(height: 16);
    final result = <Widget>[];
    for (var i = 0; i < length; i++) {
      result.add(spacer);
      result.add(elementAt(i));
    }
    result.add(spacer);
    return result;
  }
}
