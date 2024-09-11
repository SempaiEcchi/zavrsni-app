import 'package:firmus/view/shared/popups/generic_action_popup.dart';
import 'package:flutter/material.dart';

class EmployerDislikeTutorialPopup extends StatelessWidget {
  const EmployerDislikeTutorialPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericActionPopup(
        title: "Odbacivanje profila",
        icon: const SizedBox(),
        description:
            "Upravo ste odbacili profil radnika, ovaj profil više se neće pojavljivati ukoliko ga odbacite. Jeste li sigurni da želite odbaciti profil?",
        actionText: "Odbaci profil",
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

class EmployerLikeTutorialPopup extends StatelessWidget {
  const EmployerLikeTutorialPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericActionPopup(
        title: "Zahtjev za zaposlenjem",
        icon: const SizedBox(),
        description:
            "Nakon zahtjeva za zaposlenjem radnik dobija obavijest o tome te vam u roku od 3 dana mora odgovoriti na zahtjev za zaposlenjem.",
        actionText: "Pošalji zahtjev",
        subDescription:
            "*moguće je poslati  više zahtjeva odjednom te samo prihvatiti matcheve koji vama odgovaraju",
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
