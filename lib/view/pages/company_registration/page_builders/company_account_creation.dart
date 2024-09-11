import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/infra/services/job/entity/industry.dart';
import 'package:firmus/infra/stores/company_registration.dart';
import 'package:firmus/infra/stores/industry_notifier.dart';
import 'package:firmus/main.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/company_registration/company_registration_page.dart';
import 'package:firmus/view/pages/job_op_creation/other_job_details.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:firmus/view/shared/form/full_screen_list_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../registration/widgets/constrained_body.dart';
import '../../registration/widgets/next_button.dart';

class CompanyDataPage extends ConsumerStatefulWidget {
  const CompanyDataPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CompanyDataPage> createState() => _CompanyDataPageState();
}

class _CompanyDataPageState extends ConsumerState<CompanyDataPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(
      height: 24,
    );
    final industries = ref.watch(industryProvider).valueOrNull;

    return FormBuilder(
      key: _formKey,
      initialValue: ref
              .read(companyRegistrationNotifierProvider)
              .state[CompanyRegistrationPage.accountCreation] ??
          {},
      child: Stack(
        children: [
          Positioned.fill(
            child: ConstrainedBody(
              center: false,
              child: SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Osnovne informacije o\nfirmi",
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        FadeAndTranslate(
                          autoStart: true,
                          translate: const Offset(0.0, 20.0),
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  FormBuilderTextField(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white),
                                    decoration: inputDecoration,
                                    textInputAction: TextInputAction.next,
                                    name: 'representative',
                                    initialValue:
                                        kDebugMode ? "leo company" : null,
                                  ).withTitle("Predstavnik firme"),
                                  spacer,
                                  FormBuilderTextField(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white),
                                    decoration: inputDecoration,
                                    textInputAction: TextInputAction.next,
                                    name: 'location',
                                    initialValue:
                                        kDebugMode ? "leo company" : null,
                                  ).withTitle("Lokacija"),
                                  spacer,
                                  FullscreenPickerField<IndustryModel>(
                                      name: "industry",
                                      displayText: (item) => item.text,
                                      onTap: (state) {
                                        final initial = state.value;
                                        FullScreenListSelector<IndustryModel>(
                                          initialSelectedItems: [
                                            if (initial != null) initial
                                          ],
                                          displayText: (item) => item.text,
                                          initialItems:
                                              industries ?? <IndustryModel>[],
                                          title: "Industrija",
                                          subtitle:
                                              "Odaberite naziv industrije",
                                          multi: false,
                                          onSave: (List<IndustryModel>
                                              selectedItems) async {
                                            state.didChange(
                                                selectedItems.firstOrNull);
                                            setState(() {});
                                          },
                                        ).show(context);
                                      }).withTitle(
                                    "Industrija",
                                  ),
                                  spacer,
                                  FormBuilderTextField(
                                    minLines: 2,
                                    maxLines: 3,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white),
                                    decoration: inputDecoration,
                                    // keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.done,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                    initialValue:
                                        kDebugMode ? "leo company" : null,

                                    name: 'description',
                                  ).withTitle("Ukratko o firmi", large: true),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!ref.watch(keyboardOnProvider))
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 52,
                  ),
                  NextButton(
                    onTap: () async {
                      bool saveAndValidate =
                          _formKey.currentState!.saveAndValidate();

                      setState(() {});
                      if (saveAndValidate) {
                        final data = _formKey.currentState!.value;
                        ref
                            .read(companyRegistrationNotifierProvider.notifier)
                            .nextPage(data);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 52,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
