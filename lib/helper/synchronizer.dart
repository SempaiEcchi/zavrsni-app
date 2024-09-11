import 'package:flutter/material.dart';

class Synchronizer {
  final VoidCallback call;
  bool called = false;
  Synchronizer(this.call);

  void runOnce() {
    if (called) return;
    called = true;
    call();
  }
}
