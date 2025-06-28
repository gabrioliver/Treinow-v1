import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _leftController;
  late AnimationController _rightController;
  late Animation<Offset> _leftAnimation;
  late Animation<Offset> _rightAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _leftController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _rightController = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _leftAnimation = Tween<Offset>(
      begin: const Offset(-2.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _leftController, curve: Curves.easeOut));

    _rightAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _rightController, curve: Curves.easeOut));

    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _leftController.forward();
    _rightController.forward();
    _fadeController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SlideTransition(
              position: _leftAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF0077B6),
                ),
              ),
            ),
            SlideTransition(
              position: _rightAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF00B386),
                ),
              ),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                'lib/assets/logo.png',
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
