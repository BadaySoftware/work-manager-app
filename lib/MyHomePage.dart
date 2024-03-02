import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;
  int _startTime = 0;
  String _workTitle = "";
  Timer? _timer;
  TextEditingController _workTitleController = TextEditingController();
  bool _completed = false;
  double _value = 0.0;
  Color backgroundColor = Colors.grey.withOpacity(0.25);
  List<AnimatedText> phrases = [
    TyperAnimatedText("It's time to hustle!"),
    TyperAnimatedText("It's time to study with intent."),
    TyperAnimatedText("It's time to rise and grind!"),
    TyperAnimatedText("It's time to tackle challenges head-on."),
    TyperAnimatedText("It's time to focus and achieve."),
    TyperAnimatedText("It's time to excel through effort."),
    TyperAnimatedText("It's time to sharpen your skills."),
    TyperAnimatedText("It's time to embrace the grind."),
    TyperAnimatedText("It's time to work towards success."),
    TyperAnimatedText("It's time to push your limits!"),
    TyperAnimatedText("It's time to give it your all."),
    TyperAnimatedText("It's time to strive for greatness."),
    TyperAnimatedText("It's time to invest in yourself."),
    TyperAnimatedText("It's time to make it happen!"),
    TyperAnimatedText("It's time to conquer the day."),
    TyperAnimatedText("It's time to shine through hard work."),
    TyperAnimatedText("It's time to chase your dreams."),
    TyperAnimatedText("It's time to learn and grow."),
    TyperAnimatedText("It's time to make progress."),
    TyperAnimatedText("It's time to make a difference!"),
    TyperAnimatedText("You're gonna wake up and work hard at it!"),
    TyperAnimatedText("Don't let your dreams be dreams."),
    TyperAnimatedText("Make your dreams come true."),
    TyperAnimatedText("Nothing is impossible!"),
    TyperAnimatedText("Just do it!"),
    TyperAnimatedText("Just do it!"),
    TyperAnimatedText("Yesterday you said tommorow."),
    TyperAnimatedText(
        "You should get to the point where anyone else would quit."),
    TyperAnimatedText("what are you waiting for?"),
    TyperAnimatedText("Just do it!"),
  ];

  @override
  void initState() {
    super.initState();
    _isWorking = SharedPrefs().isWorking;
    _workTitle = SharedPrefs().workTitle;
    _startTime = SharedPrefs().startTime;
    _controllerCenterRight =
        ConfettiController(duration: const Duration(milliseconds: 250));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(milliseconds: 250));
    if (_isWorking) {
      startTimer();
    }
  }

  @override
  void dispose() {
    _workTitleController.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;
    var highlightStyle = Theme.of(context)
        .textTheme
        .headlineLarge!
        .copyWith(fontSize: 30, color: textColor);
    var normalStyle = Theme.of(context)
        .textTheme
        .headlineLarge!
        .copyWith(color: Theme.of(context).colorScheme.outline, fontSize: 28);
    Color navColor = Theme.of(context).colorScheme.surface;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness:
              Theme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
          systemNavigationBarColor: navColor,
          systemNavigationBarDividerColor: navColor),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 20,
          title: const Text("Work Timer"),
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ConfettiWidget(
                confettiController: _controllerCenterRight,
                blastDirection: pi,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.05,
                shouldLoop: false,
                colors: const [Colors.green, Colors.blue, Colors.pink],
                strokeWidth: 1,
                strokeColor: Colors.white,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ConfettiWidget(
                confettiController: _controllerCenterLeft,
                blastDirection: 0,
                emissionFrequency: 0.6,
                minimumSize: const Size(10, 10),
                maximumSize: const Size(50, 50),
                numberOfParticles: 1,
                gravity: 0.1,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _completed
                                ? SizedBox()
                                : Column(
                                    children: [
                                      Visibility(
                                          visible: _isWorking ? true : false,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Started working on",
                                                style: normalStyle,
                                              ),
                                              DefaultTextStyle(
                                                style: GoogleFonts.nunito(
                                                    fontSize: 30.0,
                                                    color: textColor),
                                                child: AnimatedTextKit(
                                                  totalRepeatCount: 1,
                                                  animatedTexts: [
                                                    TyperAnimatedText(
                                                        '$_workTitle'),
                                                  ],
                                                  onTap: () {
                                                    print("Tap Event");
                                                  },
                                                ),
                                              ),
                                            ],
                                          )),
                                      Visibility(
                                          visible: _isWorking ? false : true,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Welcome",
                                                style: normalStyle,
                                              ),
                                              DefaultTextStyle(
                                                style: GoogleFonts.nunito(
                                                    fontSize: 30.0,
                                                    color: textColor),
                                                child: AnimatedTextKit(
                                                  pause: Duration(seconds: 5),
                                                  repeatForever: true,
                                                  animatedTexts: [
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                    getRandomPhrase(phrases),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                            _completed
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Completed working on",
                                        style: normalStyle,
                                      ),
                                      DefaultTextStyle(
                                        style: GoogleFonts.nunito(
                                            fontSize: 30.0, color: textColor),
                                        child: AnimatedTextKit(
                                          totalRepeatCount: 1,
                                          animatedTexts: [
                                            TyperAnimatedText('$_workTitle'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            value: _value,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                            strokeWidth: 10,
                            strokeCap: StrokeCap.round,
                            backgroundColor: backgroundColor,
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: FittedBox(
                                child: RichText(
                              text: TextSpan(
                                style: normalStyle,
                                children: [
                                  TextSpan(
                                      text: ' $_hours', style: highlightStyle),
                                  TextSpan(text: 'h', style: highlightStyle),
                                  TextSpan(
                                      text: ' $_minutes',
                                      style: highlightStyle),
                                  TextSpan(text: 'm', style: highlightStyle),
                                  TextSpan(
                                      text: " $_seconds",
                                      style: highlightStyle),
                                  TextSpan(text: "s", style: highlightStyle),
                                ],
                              ),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _isWorking
                          ? Text(
                              'Stay focused',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              " ",
                              textAlign: TextAlign.center,
                            ),
                      SizedBox(height: 24),
                      _isWorking
                          ? CupertinoButton(
                              color: Colors.redAccent,
                              onPressed: () {
                                _controllerCenterRight.play();
                                _controllerCenterLeft.play();
                                backgroundColor = Colors.green;
                                _value = 0.0;
                                stopTimer();
                              },
                              child: Text('Stop',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onInverseSurface)),
                              borderRadius: BorderRadius.circular(16),
                            )
                          : CupertinoButton(
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                _workTitleController.clear();
                                _showMyDialog();
                              },
                              child: Text(
                                'Start Working',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onInverseSurface),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
          title: Text(
            'I will work on:',
            style: TextStyle(
                fontSize: 22, color: Theme.of(context).colorScheme.onSurface),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _workTitleController,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
                setState(() {
                  _hours = 0;
                  _minutes = 0;
                  _seconds = 0;
                  _completed = false;
                  _isWorking = true;
                  _workTitle = _workTitleController.text;
                  _startTime = DateTime.now().millisecondsSinceEpoch;
                });
                SharedPrefs().isWorking = true;
                SharedPrefs().workTitle = _workTitleController.text;
                SharedPrefs().startTime = _startTime;
                startTimer();
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
      _value = 1.0;
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
    SharedPrefs().isWorking = false;
    setState(() {
      _isWorking = false;
      _startTime = DateTime.now().millisecondsSinceEpoch;
      _completed = true;
    });
    _timer?.cancel();
    _timer = null;
  }

  AnimatedText getRandomPhrase(List<AnimatedText> phrases) {
    Random random = Random();
    int index = random.nextInt(phrases.length);
    return phrases[index];
  }

  Text _display(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }
}
