import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:firmus/helper/logger.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SaveButton extends HookWidget {
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    var loading = useState(false);
    return AnimatedTapButton(
      onTap: () {
        if (loading.value) return;

        bool isAsync = onTap.runtimeType.toString().contains('Future');

        if (isAsync) {
          loading.value = true;
          onTap().whenComplete(() => loading.value = false);
        } else {
          onTap();
        }
      },
      child: CircleAvatar(
          radius: 31,
          backgroundColor: Colors.white,
          child: loading.value
              ? const Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator()))
              : Icon(
                  Icons.save,
                  color: Theme.of(context).primaryColor,
                )),
    );
  }

  const SaveButton({
    super.key,
    required this.onTap,
  });
}
