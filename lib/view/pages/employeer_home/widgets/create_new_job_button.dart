import 'package:firmus/view/pages/job_op_creation/pick_creation_type_popup.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateNewJobButton extends ConsumerWidget {
  const CreateNewJobButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox();

    return AnimatedTapButton(
      onTap: () async {
        await const PickJobCreationTypePopup().show(context);
      },
      child: Container(
        width: 167,
        height: 44,
        decoration: ShapeDecoration(
          color: const Color(0xFF007AFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 20,
              offset: Offset(0, 6.25),
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Izradi oglas",
                        maxLines: 1,
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 0.09,
                                )),
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
