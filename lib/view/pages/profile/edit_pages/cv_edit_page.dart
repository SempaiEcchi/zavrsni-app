import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/models/student_experience.dart';
import 'package:firmus/view/pages/onboarding/pick_registation_type.dart';
import 'package:firmus/view/pages/registration/registration_image_cropper.dart';
import 'package:firmus/view/pages/registration/widgets/experience_tile.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../registration/experience_creator.dart';
import '../../registration/widgets/constrained_body.dart';

class CVEditPage extends ConsumerStatefulWidget {
  const CVEditPage({super.key});

  @override
  ConsumerState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<CVEditPage> {
  final key = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(
      height: 24,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: FirmusAppBar(
        onPressed: () {
          GoRouter.of(context).pop();
        },
        text: 'Firmus CV',
      ),
      body: FormBuilder(
        key: key,
        initialValue:
            ref.read(studentNotifierProvider).requireValue.toExperienceForm(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ConstrainedBody(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.loc.pickExperience,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            context.loc.pickExperienceSubtitle,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Expanded(
                            child:
                                FormBuilderField<List<StudentExperienceEntity>>(
                              name: "experiences",
                              builder: (state) {
                                final count = (state.value?.length ?? 0) + 1;

                                return ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 16,
                                  ),
                                  itemCount: count,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    if (index == count - 1) {
                                      return AnimatedTapButton(
                                        onTap: () {
                                          createExperience(state);
                                        },
                                        child: Center(
                                          child: SizedBox(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Assets.images.roundedAdd
                                                    .image(width: 90),
                                                Assets.images
                                                    .dodajPoslovnoIskustvo
                                                    .image(width: 232),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    final item = state.value![index];
                                    return Dismissible(
                                      onDismissed: (direction) {
                                        final experiences = state.value ?? [];
                                        experiences.removeWhere(
                                            (element) => element.id == item.id);
                                        state.didChange(experiences);
                                      },
                                      key: ValueKey(item.id),
                                      child: ExperienceTile(
                                        experience: item,
                                        onTap: () {
                                          createExperience(state,
                                              initial: item);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 52,
                    ),
                  ],
                ),
              ),
            ),
            SaveButton(
              onTap: () async {
                key.currentState!.save();

                if (key.currentState!.saveAndValidate()) {
                  showLoadingDialog(context);
                  final data = key.currentState!.value;
                  logger.info(data);
                  ref
                      .read(studentNotifierProvider.notifier)
                      .updateCV(data)
                      .then((v) => GoRouter.of(context).popPop());
                }
              },
            ),
            const SizedBox(
              height: 52,
            ),
          ],
        ),
      ),
    );
  }

  void createExperience(FormFieldState<List<StudentExperienceEntity>> state,
      {StudentExperienceEntity? initial}) async {
    final value = await ExperienceCreator(
      initialExperience: initial,
    ).show(context);
    if (value is StudentExperienceEntity) {
      final experiences = state.value ?? [];
      experiences.removeWhere((element) => element.id == value.id);
      experiences.add(value);
      state.didChange(experiences);
    }
  }
}
