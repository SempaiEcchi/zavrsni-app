import 'package:firmus/view/shared/popups/generic_action_popup.dart';
import 'package:flutter/material.dart';

class DislikeTutorialPopup extends StatelessWidget {
  const DislikeTutorialPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericActionPopup(
        title: "Odbacivanje oglasa",
        icon: const SizedBox(),
        description:
            "Upravo ste odbacili oglas za posao, ovaj oglas više se neće pojavljivati ukoliko ga odbacite. Jeste li sigurni da želite odbaciti oglas?",
        actionText: "Odbaci oglas",
        onActionPressed: () {
          Navigator.of(context).pop();
        });
  }

  Future<T?> show<T>(BuildContext context) async {
    return await showDialog<T?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => this,
    );
  }
}

class LikeTutorialPopup extends StatelessWidget {
  const LikeTutorialPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericActionPopup(
        title: "Prijava na oglas",
        icon: const SizedBox(),
        description:
            "Nakon prijave na oglas poslodavac dobija obavijest o tome te vam u roku od 3 dana mora odgovoriti na zahtjev za zapošljavanjem.",
        actionText: "Prijavi me",
        subDescription:
            "*moguće je prijaviti se na više poslova odjednom te samo prihvatiti matcheve koji vama odgovaraju",
        onActionPressed: () {
          Navigator.of(context).pop();
        });
  }

  Future<T?> show<T>(BuildContext context) async {
    return await showDialog<T?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => this,
    );
  }
}
