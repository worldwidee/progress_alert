import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/progress_controller.dart';

class ProgressAlert extends StatefulWidget {
  String redoText, hideText, cancelText;
  Widget? errorIcon, progressIcon;
  double height;
  bool isTop;
  ProgressAlert(
      {Key? key,
      this.redoText = "Redo",
      this.hideText = "Hide",
      this.cancelText = "Cancel",
      this.errorIcon,
      this.progressIcon,
      this.height = 50,
      this.isTop = true})
      : super(key: key) {
    Get.put(ProgressController());
    errorIcon ??= Icon(
      Icons.error,
      size: 20,
      color: Colors.orange[700],
    );
    progressIcon ??= const CircularProgressIndicator();
  }

  @override
  _ProgressAlertState createState() => _ProgressAlertState(
      redoText, hideText, cancelText, errorIcon, progressIcon, height, isTop);
}

class _ProgressAlertState extends State<ProgressAlert> {
  final controller = Get.find<ProgressController>();

  String redoText, hideText, cancelText;
  Widget? errorIcon, progressIcon;
  double height;
  bool isTop;
  double extraPadding = 0;
  _ProgressAlertState(this.redoText, this.hideText, this.cancelText,
      this.errorIcon, this.progressIcon, this.height, this.isTop) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      extraPadding = 32;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(builder: (_) {
      return Positioned(
          top: isTop ? extraPadding : null,
          bottom: isTop ? null : 0,
          child: Column(
            children: [
              for (var progress in controller.fails)
                showProgress(progress, failed: true),
              for (var progress in controller.progresses) showProgress(progress)
            ],
          ));
    });
  }

  Widget showProgress(ProgressItem progress, {bool failed = false}) {
    return Opacity(
      opacity: 0.8,
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: height,
          color: Colors.black,
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: !failed ? progressIcon : errorIcon,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  !failed ? "${progress.processText}..." : progress.errorText,
                  style: GoogleFonts.titilliumWeb(
                      color: !failed ? Colors.white : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
              if (failed)
                TextButton(
                    onPressed: () {
                      controller.addProcess(progress);
                    },
                    child: Text(redoText,
                        style: GoogleFonts.titilliumWeb(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w500))),
              TextButton(
                  onPressed: () {
                    if (failed) {
                      controller.removeFail(progress);
                    } else {
                      progress.cancel();
                    }
                  },
                  child: Text(failed ? hideText : cancelText,
                      style: GoogleFonts.titilliumWeb(
                          color: failed ? Colors.grey : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)))
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressPanel {
  get failDuration => Get.find<ProgressController>().failDuration;

  set setFailDuration(Duration duration) {
    Get.find<ProgressController>().setFailDuration = duration;
  }

  get removeFailAfterDuration =>
      Get.find<ProgressController>().removeFailAfterDuration;

  set changeRemoveFailAfterDuration(bool status) {
    Get.find<ProgressController>().removeFailAfterDuration = status;
  }

  void addProcess(ProgressItem progress) {
    Get.find<ProgressController>().addProcess(progress);
  }

  void removeFail(ProgressItem progress) {
    Get.find<ProgressController>().removeFail(progress);
  }

  void removeProgress(ProgressItem progress) {
    Get.find<ProgressController>().removeProgress(progress);
  }

  void addFail(ProgressItem progress) {
    Get.find<ProgressController>().addFail(progress);
  }
}

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
