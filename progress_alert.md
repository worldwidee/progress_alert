# progress_alert

Progress Alert is customizable alert for showing process which is progressing in background


![support](https://github.com/worldwidee/files/raw/main/progress_alert_noerr.gif)|![support](https://github.com/worldwidee/files/raw/main/progress_alert_witherr.gif)
---|---


## Features

- Single line basic alert
- Customizable Features
	- Change all button texts
	- Change height
	- Change position as top/bottom
	- Change icons
  - Change display time of failed process alert


## Getting started

You must add the library as a dependency to your project.
```yaml
dependencies:
 progress_alert: ^latest
```

Then run `flutter packages get`

## Example Project

There is a detailed example project in the `example` folder. You can directly run and play on it. There are code snippets from example project below.

## Basic Setup
Add ProgressAlert() to Material App's builder as example

```dart
    Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) => Stack(
        children: [child!, ProgressAlert()],
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
```
Start controller

```dart
final controller = ProgressPanel();
```
Create progress

```dart
Future<void> func() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _counter++;
    });
  }
ProgressItem progress = ProgressItem(
    process: func,
    processText: "Counter Incrementing",
    errorText: "Counter Incrementing Failed!",
    onCancel: () {
      print("Progress Cancelled");
    },
    onDone: () {
      print("Progress Done");
    },
    onError: (e) {
      print("Progress Failed:$e");
    });
```
Add and start process

```dart
controller.addProcess(progress);
```
## Customizable Features


ProgressAlert

```dart
ProgressAlert(
    redoText: "Redi",
    height: 50,
    hideText: "Hide",
    cancelText: "Cancel",
    errorIcon: const Icon(Icons.error),
    progressIcon: const CircularProgressIndicator(),
    isTop: true,
    )
```

ProgressItem

```dart
ProgressItem progress = ProgressItem(
    process: func,
    processText: "Counter Incrementing",
    errorText: "Counter Incrementing Failed!",
    onCancel: () {
      print("Progress Cancelled");
    },
    onDone: () {
      print("Progress Done");
    },
    onError: (e) {
      print("Progress Failed:$e");
    });
```

Displaying Fail

```dart
final controller = ProgressPanel();
controller.setFailDuration=const Duration(seconds: 10);
//If you want the error not to be cleared from the screen turn false
controller.changeRemoveFailAfterDuration=true;
```

## Contributions
* If you **found a bug**, open an issue.
* If you **have a feature request**, open an issue.
* If you **want to contribute**, submit a pull request.