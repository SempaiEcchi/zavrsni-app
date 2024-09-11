import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadingCV extends Equatable {
  final String id;
  final File? thumbnail;

  const UploadingCV({
    required this.thumbnail,
    required this.id,
  });

  @override
  List<Object?> get props => [id, thumbnail];
}

final uploadingVideosProvider =
    NotifierProvider<UploadingCVNotifier, List<UploadingCV>>(() {
  return UploadingCVNotifier();
});

class UploadingCVNotifier extends Notifier<List<UploadingCV>> {
  @override
  List<UploadingCV> build() {
    return [];
  }

  void add(UploadingCV uploadingCV) {
    remove(uploadingCV.id);
    state = [...state, uploadingCV];
  }

  void remove(String id) {
    state = state.where((element) => element.id != id).toList();
  }
}
