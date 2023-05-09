import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_2/Laya.dart';
import 'package:project_2/gen/assets.gen.dart';
import 'package:project_2/heart.dart';
import 'package:project_2/home.dart';
import 'package:project_2/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then(
      (value) {
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) =>  OnBordingScreen()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Assets.img.background.splash.image(fit: BoxFit.cover)),
          Center(
            child: Assets.img.icons.logo.svg(width: 100),
          )
        ],
      ),
    );
  }
}
