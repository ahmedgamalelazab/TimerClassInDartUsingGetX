import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';

class TimerModel extends GetxController {
  var _timerInString = "".obs;
  Stopwatch _sw = new Stopwatch();
  // var _tickedTime = 0.obs;
  var _t;
  var _isStarted = false.obs;
  double _totalSecondsToScreen;
  var _initialTick = 0.0.obs;

  double get initialTick => _initialTick.value;
  double get totalSecondsToScreen => _totalSecondsToScreen;

  double onInitialDoubleState() {
    if (initialTick == null || totalSecondsToScreen == null) {
      return 0.0;
    }
    return (initialTick / totalSecondsToScreen);
  }

//  engine setters
  String _hours;
  String _minutes;
  String _seconds;

  String get hours => this._hours;

  set hours(String value) => this._hours = value;

  get minutes => this._minutes;

  set minutes(value) => this._minutes = value;

  get seconds => this._seconds;

  set seconds(value) => this._seconds = value;
//engine setters

  //section of getters
  String get timerToScreen => _timerInString.value;
  Timer get t => _t;
  bool get isStarted => _isStarted.value;
  //int get tickedTime => _tickedTime.value;
  //Stopwatch get sw => _sw;

  //section of setters
  set timerToScreen(String value) => this._timerInString.value = value;

  //timer Convertor
  String _convertSecondsToHumanTimeReadable({@required int totalSeconds}) {
    //convertor controller
    String str = "";
    //convertor core
    if (totalSeconds < 60) {
      str = '00:00:${totalSeconds.toString().padLeft(2, "0")}';
    } else if (totalSeconds < 3600) {
      int m = (totalSeconds ~/ 60);
      int s = (totalSeconds - (m * 60));
      str =
          '00:${m.toString().padLeft(2, "0")}:${s.toString().padLeft(2, "0")}';
    } else {
      //im in hours
      int h = (totalSeconds ~/ 3600);
      int r = (totalSeconds - (h * 3600));
      int m = (r ~/ 60);
      int s = (r - (m * 60));
      str =
          '${h.toString().padLeft(2, "0")}:${m.toString().padLeft(2, "0")}:${s.toString().padLeft(2, "0")}';
    }

    return str;
  }

  //convert time to total timer
  int _convertTimerToSeconds(
      {@required String xHours,
      @required String xMinutes,
      @required String xSeconds}) {
    int totalSeconds = 0;

    //parsing
    int hours = int.parse(xHours ?? "0");
    int minutes = int.parse(xMinutes ?? "0");
    int seconds = int.parse(xSeconds ?? "0");

    totalSeconds = (hours) * 3600 + minutes * 60 + seconds;
    _totalSecondsToScreen = (totalSeconds.toDouble());
    return totalSeconds;
  }
  //designing the Engine

  String _buildString() {
    _initialTick.value++;

    String str = "";
    int totalSeconds = 0;
    totalSeconds = _convertTimerToSeconds(
        xHours: _hours, xMinutes: _minutes, xSeconds: _seconds);
    // if i ticked the stopwatch the timer is going to decreased automatic
    //check if the time finished or not ?
    if (_sw.elapsed.inSeconds >= totalSeconds) {
      reset();
      checkTicksToToalSeconds();
      return str;
    }

    totalSeconds = (totalSeconds - (_sw.elapsed.inSeconds));
    str = _convertSecondsToHumanTimeReadable(totalSeconds: totalSeconds);
    return str;
  }

  void _onStartStopWatch() {
    _t = Timer.periodic(Duration(seconds: 1), (t) {
      _timerInString.value = _buildString();
      print(_timerInString.value);
    });
  }

  //designing the callbacks
  void startTimer() {
    if (!_sw.isRunning) {
      _isStarted.value = true;
      _sw.start();
      _onStartStopWatch();
    }
  }

  void pause() {
    if (_sw.isRunning) {
      _isStarted.value = false;
      _sw.stop();
      _t.cancel();
    }
  }

  void reset() {
    if (_sw.isRunning) {
      _isStarted.value = false;
      _sw.stop();
      _timerInString.value =
          '${_hours.padLeft(2, "0")}:${_minutes.padLeft(2, "0")}:${_seconds.padLeft(2, "0")}';
      _sw.reset();
      _t.cancel();
    }
  }

  //extra function to the init state for my timer
  String displayOninitialState() {
    String str = "";
    str =
        '${_hours.padLeft(2, "0")}:${_minutes.padLeft(2, "0")}:${_seconds.padLeft(2, "0")}';
    return str;
  }

  void checkTicksToToalSeconds() {
    if (initialTick == totalSecondsToScreen) {
      pause();
      reset();
      _initialTick.value = 0.0;
      _t.cancel();
    }
  }
}
