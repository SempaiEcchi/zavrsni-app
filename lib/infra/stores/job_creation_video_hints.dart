import 'package:hooks_riverpod/hooks_riverpod.dart';

final jobCreationVideoHintsTags = FutureProvider<List<String>>((ref) {
  return [
    "Naziv posla",
    "Mjesto rada",
    "Period rada",
    "Satnica/Plaća",
    "Broj radnika",
    "Smjena",
  ];
});
