import 'package:flutter/material.dart';
import 'dart:async';
import 'welcom_screen.dart';
class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _topStroke;
  late Animation<double> _middleStroke;
  late Animation<double> _bottomStroke;

  bool isFinalColor = false;
  String displayedText = "";
  String fullText = "LOVE ENCOUNTER";
  int currentIndex = 0;

  double circleSize = 0.0;
  bool showCircle = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _topStroke = Tween<double>(begin: 0.0, end: 120.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.4, curve: Curves.easeInOut)),
    );

    _middleStroke = Tween<double>(begin: 0.0, end: 80.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.4, 0.7, curve: Curves.easeInOut)),
    );

    _bottomStroke = Tween<double>(begin: 0.0, end: 120.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.7, 1.0, curve: Curves.easeInOut)),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isFinalColor = true;
        });

        _animateText();
      }
    });
  }

  void _animateText() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (currentIndex < fullText.length) {
        setState(() {
          displayedText += fullText[currentIndex];
          currentIndex++;
        });
      } else {
        timer.cancel();
        _startCircleAnimation();
      }
    });
  }

  void _startCircleAnimation() {
    setState(() {
      showCircle = true;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        circleSize = MediaQuery.of(context).size.height * 2;
      });

      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(_createRoute());
      });
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => WelcomScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ELogoPainter(
                        _topStroke.value,
                        _middleStroke.value,
                        _bottomStroke.value,
                        isFinalColor,
                      ),
                      size: Size(220, 220),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  displayedText,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black38,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showCircle)
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              left: MediaQuery.of(context).size.width / 2 - circleSize / 2,
              top: MediaQuery.of(context).size.height / 2 - circleSize / 2,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ELogoPainter extends CustomPainter {
  final double topLength;
  final double middleLength;
  final double bottomLength;
  final bool isFinalColor;

  ELogoPainter(this.topLength, this.middleLength, this.bottomLength, this.isFinalColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isFinalColor ? Colors.pinkAccent : Colors.black
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(20, 40), Offset(20 + topLength, 40), paint);
    canvas.drawLine(Offset(20, 100), Offset(20 + middleLength, 100), paint);
    canvas.drawLine(Offset(20, 160), Offset(20 + bottomLength, 160), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
