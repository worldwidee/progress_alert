import 'dart:async';

import 'package:get/get.dart';

import 'progress_controller.dart';

class ProgressItem {
  String processText;
  String errorText;
  String? successText;
  Future<void> Function() process;
  void Function()? onCancel;
  void Function(dynamic error)? onError;
  void Function()? onDone;
  late StreamSubscription<void> _streaming;
  void start() {
    _streaming = process().asStream().listen((event) {}, onDone: () {
      Get.find<ProgressController>().removeProgress(this);
      if (onDone != null) onDone!();
    }, onError: (e) {
      Get.find<ProgressController>().removeProgress(this);
      Get.find<ProgressController>().addFail(this);
      if (onError != null) onError!(e);
      if (onDone != null) onDone!();
    });
  }

  void cancel() {
    _streaming.pause();
    _streaming.cancel().then((value) {
      Get.find<ProgressController>().removeProgress(this);
      if (onCancel != null) onCancel!();
      if (onDone != null) onDone!();
    });
  }

  ProgressItem(
      {required this.process,
      this.onCancel,
      this.onError,
      this.onDone,
      this.processText = "Processing",
      this.errorText = "Process Failed!",
      this.successText});
}
