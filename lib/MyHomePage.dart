import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/sharedPrefs.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isWorking = false;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  int _startTime = 0;
  String _workTitle = "";
  Timer? _timer;
  TextEditingController _workTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isWorking = SharedPrefs().isWorking;
    _workTitle = SharedPrefs().workTitle;
    _startTime = SharedPrefs().startTime;

    if (_isWorking) {
      startTimer();
    }
  }

  @override
  void dispose() {
    _workTitleController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var highlightStyle = Theme.of(context)
        .textTheme
        .displaySmall!
        .copyWith(fontWeight: FontWeight.bold);
    var normalStyle = Theme.of(context)
        .textTheme
        .headlineLarge!
        .copyWith(color: Theme.of(context).colorScheme.outline);
    Color navColor = Theme.of(context).colorScheme.surface;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: navColor,
          systemNavigationBarDividerColor: navColor),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Work Manager"),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                _isWorking
                    ? RichText(
                        text: TextSpan(
                          text: 'You have been working on',
                          style: normalStyle,
                          children: [
                            TextSpan(text: " $_workTitle", style: highlightStyle),
                            TextSpan(text: ' for', style: normalStyle),
                            TextSpan(text: ' $_hours', style: highlightStyle),
                            TextSpan(text: 'h', style: highlightStyle),
                            TextSpan(text: ' $_minutes', style: highlightStyle),
                            TextSpan(text: 'm', style: highlightStyle),
                            TextSpan(text: " $_seconds", style: highlightStyle),
                            TextSpan(text: "s", style: normalStyle),
                          ],
                        ),
                      )
                    : Text(
                        "Welcome, Its time to work!",
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
                      ),
              ],
            ),
          ),
        ),
        floatingActionButton: _isWorking
            ? FloatingActionButton.extended(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                label: Text("Stop",style: TextStyle(fontSize: 15,color: Theme.of(context).colorScheme.onErrorContainer),),
                icon: Icon(Icons.close,color: Theme.of(context).colorScheme.onErrorContainer),
                onPressed: () {
                  _isWorking = false;
                  SharedPrefs().isWorking = false;
                  _hours = 0;
                  _minutes = 0;
                  stopTimer();
                  setState(() {});
                },
              )
            : FloatingActionButton.extended(
                label: const Text(
                  "Start Working",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _workTitleController.clear();
                  _showMyDialog();
                },
                icon: const Icon(Icons.add),
              ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.only(bottom: 16, right: 24),
          title: const Text(
            'I will work on:',
            style: TextStyle(fontSize: 22),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _workTitleController,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 12)),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                _isWorking = true;
                SharedPrefs().isWorking = true;
                _workTitle = _workTitleController.text;
                SharedPrefs().workTitle = _workTitleController.text;
                _startTime = DateTime.now().millisecondsSinceEpoch;
                SharedPrefs().startTime = _startTime;
                startTimer();
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void startTimer() {
    setState(() {
      DateTime now = DateTime.now();
      DateTime startTime = DateTime.fromMillisecondsSinceEpoch(_startTime);
      Duration duration = now.difference(startTime);
      _hours = duration.inHours;
      _minutes = (duration.inMinutes % 60);
      _seconds = (duration.inSeconds % 60);
    });
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        DateTime now = DateTime.now();
        DateTime startTime = DateTime.fromMillisecondsSinceEpoch(_startTime);
        Duration duration = now.difference(startTime);
        _hours = duration.inHours;
        _minutes = (duration.inMinutes % 60);
        _seconds = (duration.inSeconds % 60);

      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
