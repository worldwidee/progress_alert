import 'dart:async';

import 'package:get/get.dart';

import 'progress_item.dart';

class ProgressController extends GetxController {
  final _progresses = [];
  final _fails = [];
  get progresses => _progresses;
  get fails => _fails;
  late int _failDuration;
  bool removeFailAfterDuration;
  ProgressController(
      {this.removeFailAfterDuration = true, int failDuration = 10}) {
    _failDuration = failDuration;
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
      Future.delayed(Duration(seconds: _failDuration)).then((value) {
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
