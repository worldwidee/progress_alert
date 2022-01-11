

import 'dart:async';

import 'package:get/get.dart';

import '../progress_alert.dart';

class ProgressController extends GetxController {
  final _progresses = [];
  final _fails = [];
  late Duration _failDuration;
  bool removeFailAfterDuration;
  ProgressController(
      {this.removeFailAfterDuration = true, Duration? failDuration}) {
    if (failDuration != null) {
      _failDuration = failDuration;
    } else {
      _failDuration = const Duration(seconds: 10);
    }
  }
  get progresses => _progresses;
  get fails => _fails;
  get failDuration => _failDuration;
  set setFailDuration(Duration duration) {
    _failDuration = duration;
  }

  void addProcess(ProgressItem progress) {
    if (_fails.any((element) => element == progress)) {
      _fails.remove(progress);
    }
    _progresses.add(progress);
    progress.start();
    update();
  }

  void removeFail(ProgressItem progress) {
    if (_fails.any((element) => element == progress)) {
      _fails.remove(progress);
      update();
    }
  }

  void removeProgress(ProgressItem progress) {
    _progresses.remove(progress);
    update();
  }

  void addFail(ProgressItem progress) {
    _fails.add(progress);
    if (removeFailAfterDuration) {
      bool reRun = false;
      var timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!_fails.any((element) => element == progress)) {
          reRun = true;
          timer.cancel();
        }
      });
      Future.delayed(_failDuration).then((value) {
        if (timer.isActive) {
          timer.cancel();
        }
        if (!reRun) {
          removeFail(progress);
        }
      });
    }
    update();
  }
}
