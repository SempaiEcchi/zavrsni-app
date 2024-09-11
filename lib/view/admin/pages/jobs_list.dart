import 'package:firmus/helper/image_picker.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/infra/stores/job_creation_notifier.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/admin/pages/companies_list.dart';
import 'package:firmus/view/pages/job_op_creation/basic_job_details.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:firmus/view/pages/student_home/single_offer_page.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:firmus/view/shared/tiles/jobs/job_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../gen/assets.gen.dart';
import '../../../helper/logger.dart';
import '../../../theme/_light_theme.dart';
import '../../pages/job_op_creation/job_video.dart';
import '../../pages/job_op_creation/other_job_details.dart';
import '../../pages/registration/widgets/constrained_body.dart';
import '../../shared/form/full_screen_list_selector.dart';
import '../../shared/form/text_field.dart';

class JobView extends ConsumerWidget {
  final SimpleCompany? company;

  JobView([this.company]);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(jobsProvider(this.company?.id));
    return ConstrainedBody(
      child: jobs.when(
        data: (jobsList) {
          final scaffold = Scaffold.of(context);
          return Scaffold(
            floatingActionButton: company == null
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      CreateJobDialog(company!.id).show(context);
                    },
                    child: const Icon(Icons.add),
                  ),
            body: ListView.builder(
              itemCount: jobsList.length,
              itemBuilder: (context, index) {
                final job = jobsList[index];
                return RoundedJobCard(
                  job: job,
                  onTap: () {
                    SingleOfferPage(
                      job,
                      showControls: false,
                    ).show(context);
                  },
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

class CreateJobDialog extends ConsumerStatefulWidget {
  final String company_id;

  CreateJobDialog(this.company_id);

  @override
  ConsumerState<CreateJobDialog> createState() => _CreateJobDialogState();

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

class _CreateJobDialogState extends ConsumerState<CreateJobDialog> {
  final key = GlobalKey<FormBuilderState>();

  XFile? video;

  @override
  Widget build(BuildContext context) {
    final jobProfiles = ref
            .watch(jobProfilesProvider)
            .valueOrNull
            ?.map((e) => e.name)
            .toList() ??
        [];
    return ConstrainedBody(
      child: Dialog(
        child: FormBuilder(
            key: key,
            child: SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FirmusTextField(
                        name: BasicJobDetails.title,
                        title: 'Naziv posla',
                        inverted: true,
                      ),
                      Text("Opis posla"),
                      FormBuilderTextField(
                        minLines: 4,
                        maxLines: 10,
                        style: Theme.of(context).textTheme.bodyLarge!,
                        decoration: invertedInputDecoration,
                        // keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        name: 'description',
                      ),
                      FirmusTextField(
                        name: BasicJobDetails.location,
                        title: 'Lokacija',
                        inverted: true,
                      ),
                      const FirmusTextField(
                        name: BasicJobDetails.payment,
                        title: 'Hourly rate',
                        inverted: true,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                      ),
                      FormBuilderDateTimePicker(
                        name: BasicJobDetails.applyDeadline,
                        initialValue: DateTime.now().add(Duration(days: 30)),
                        inputType: InputType.date,
                        decoration: invertedInputDecoration.copyWith(
                            labelText: "Apply deadline"),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      Stack(
                        children: [
                          FormBuilderDropdown(
                            iconSize: 0,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            style: Theme.of(context).textTheme.bodyLarge!,
                            decoration: invertedInputDecoration,
                            name: OtherJobDetails.jobType,
                            initialValue: JobType.FULL_TIME,
                            items: [
                              ...JobType.values,
                            ]
                                .map((e) => DropdownMenuItem(
                                      alignment: Alignment.centerLeft,
                                      value: e,
                                      child: Container(
                                        child: Text(
                                          e.formattedName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Assets.images.dropdown.image(
                                  width: 14,
                                  height: 14,
                                  color: FigmaColors.neutralNeutral7),
                            ),
                          )
                        ],
                      ).withTitle("Tip posla", invertColor: true),
                      Row(
                        children: [
                          if (video != null)
                            Text("Učitan video ${basename(video!.path)}"),
                          ElevatedButton(
                            onPressed: () async {
                              pickVideo().then((v) async {
                                if (v != null) {
                                  setState(() {
                                    video = v;
                                  });
                                }
                              });
                            },
                            child: Text("Select image/video"),
                          ),
                        ],
                      ),
                      const FirmusTextField(
                        name: OtherJobDetails.employeesNeeded,
                        title: 'Broj potrebnih radnika',
                        inverted: true,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                      ),
                      FullscreenPickerField<String>(
                          inverted: true,
                          name: OtherJobDetails.jobProfile,
                          displayText: (item) => item,
                          onTap: (state) {
                            final initial = state.value;
                            FullScreenListSelector<String>(
                              initialSelectedItems: [
                                if (initial != null) initial
                              ],
                              displayText: (item) => item,
                              initialItems: jobProfiles ?? <String>[],
                              title: "Pozicija",
                              subtitle: "Odaberite naziv pozicije",
                              multi: false,
                              onSave: (List<String> selectedItems) async {
                                state.didChange(selectedItems.firstOrNull);
                                setState(() {});
                              },
                            ).show(context);
                          }).withTitle("Naziv pozicije", invertColor: true),
                      PrimaryButton(
                        onTap: () async {
                          if (video == null) return;
                          try {
                            if (key.currentState!.saveAndValidate()) {
                              logger.info("Creating job");

                              final data = key.currentState!.value;
                              await createJobM({
                                ...data,
                                JobVideo.video: video,
                              }, ref, widget.company_id);
                              ref.invalidate(jobsProvider(widget.company_id));

                              Navigator.of(context).pop();
                            } else {
                              print("Validation failed");
                            }
                          } catch (e, st) {
                            debugPrintStack(stackTrace: st);
                            logger.severe("Error uploading video $e");
                            // show snackbar with copy button
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Error uploading video $e"),
                              action: SnackBarAction(
                                label: "Copy",
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: "$e\n$st"));
                                },
                              ),
                            ));
                            context.pop();
                          }
                        },
                        text: "Create",
                      ),
                    ].padChildren()),
              ),
            )),
      ),
    );
  }
}

final jobsProvider = FutureProvider.autoDispose
    .family<List<JobOpportunity>, String?>((ref, arg) async {
  final id = arg ?? "all";
  return ref
      .read(httpServiceProvider)
      .request(GetRequest(endpoint: "/jobs/company/$id"), converter: (resp) {
    return (resp["data"] as List)
        .map((e) => JobOpportunity.fromMap(e))
        .toList();
  });
});



