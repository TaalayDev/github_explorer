import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/assets.dart';
import '../../../../config/router/router.dart';

const splashDuration = Duration(seconds: 3);
const _logoSize = 288.0;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(splashDuration, _openUsers);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _openUsers() {
    if (!mounted) return;
    context.go(AppRoutes.users);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(Assets.images.logo, width: _logoSize, height: _logoSize),
      ),
    );
  }
}
