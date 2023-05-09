import 'package:flutter/material.dart';
import 'package:project_2/gen/assets.gen.dart';
import 'package:project_2/heart.dart';

class LayaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Center(
            child: HeartWidget(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Center(
                child: Text(
              'Laya',
              style:
                  Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 85),
            )),
          )
        ],
      ),
    ));
  }
}
