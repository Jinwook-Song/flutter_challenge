import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          // color: Colors.amber,
          elevation: 0,
        ),
        // scaffoldBackgroundColor: Colors.amber,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  static const timesetList = [15, 20, 25, 30, 35];

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _selectedTimeset = 25;
  int _totalSec = 25 * 60;
  int _finishedRound = 0;
  int _finishedGoal = 0;
  bool _isRunning = false;
  bool _isBreaking = false;
  int _totalBreakSec = 5 * 60;

  late Timer _timer;
  late Timer _breakTimer;

  void _handleStart() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 10),
      _handleTick,
    );
    _isRunning = true;
    setState(() {});
  }

  void _handlePause() {
    _timer.cancel();
    _isRunning = false;
    setState(() {});
  }

  void _resetTimer() {
    _totalSec = _selectedTimeset * 60;
    setState(() {});
  }

  void _handleTimeSet(int timeset) {
    if (_isRunning) return;
    _selectedTimeset = timeset;
    _totalSec = timeset * 60;
    setState(() {});
  }

  void _handleTick(Timer timer) {
    if (_totalSec == 0) {
      _isRunning = false;
      _totalSec = _selectedTimeset * 60;
      if (_finishedRound == 4) {
        _finishedRound = 0;
        _finishedGoal++;
      } else {
        _finishedRound++;
      }
      _startBreakTime();
      timer.cancel();
    } else {
      _totalSec--;
    }
    setState(() {});
  }

  void _startBreakTime() {
    _isBreaking = true;
    _breakTimer = Timer.periodic(
      const Duration(milliseconds: 20),
      _handleBreakTick,
    );
  }

  void _handleBreakTick(Timer timer) {
    if (_totalBreakSec == 0) {
      _isBreaking = false;
      _totalBreakSec = 5 * 60;
      _breakTimer.cancel();
    } else {
      _totalBreakSec--;
    }
    setState(() {});
  }

  String getRemainedMinutes(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.substring(2, 4);
  }

  String getRemainedSeconds(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.substring(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            children: [
              Text(
                _isBreaking ? 'Take a break~' : 'POMOTIMER',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            getRemainedMinutes(
                              _isBreaking ? _totalBreakSec : _totalSec,
                            ),
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 36,
                      child: Center(
                        child: Opacity(
                          opacity: 0.8,
                          child: Text(
                            ':',
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade50),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            getRemainedSeconds(
                              _isBreaking ? _totalBreakSec : _totalSec,
                            ),
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var timeset in MyWidget.timesetList) ...[
                    Expanded(
                      child: Opacity(
                        opacity: _isRunning ? 0.3 : 1,
                        child: GestureDetector(
                          onTap: () => _handleTimeSet(timeset),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.amber.shade200,
                                  width: 2,
                                ),
                                color: timeset == _selectedTimeset
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                '$timeset',
                                style: TextStyle(
                                  color: timeset == _selectedTimeset
                                      ? Colors.amber
                                      : Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (timeset != MyWidget.timesetList.last)
                      const SizedBox(
                        width: 12,
                      )
                  ]
                ],
              ),
              const SizedBox(height: 80),
              _isBreaking
                  ? SizedBox(
                      // color: Colors.white,
                      width: 136,
                      height: 136,
                      child: Lottie.asset(
                        'assets/coffee-break.json',
                      ),
                    )
                  : Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          iconSize: 120,
                          onPressed: _isRunning
                              ? () => _handlePause()
                              : () => _handleStart(),
                          icon: Icon(
                            _isRunning ? Icons.pause_circle : Icons.play_circle,
                          ),
                        ),
                        _isRunning
                            ? const Spacer()
                            : Expanded(
                                child: IconButton(
                                  iconSize: 48,
                                  onPressed: _resetTimer,
                                  icon: const Icon(Icons.restore),
                                ),
                              ),
                      ],
                    ),
              const SizedBox(height: 40),
              DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$_finishedRound/4',
                          style: TextStyle(
                            color: Colors.amber.shade100,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'ROUND',
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '$_finishedGoal/12',
                          style: TextStyle(
                            color: Colors.amber.shade100,
                          ),
                        ),
                        const Text('GOAL'),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
