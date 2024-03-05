import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SleepyEllie extends StatelessWidget {
  const SleepyEllie({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(delegate: SliverChildListDelegate([
      const SizedBox(
        height: 125.0,
        child: RiveAnimation.asset('assets/rive/sleepy_lottie.riv'),
      ),
    ]), itemExtent: 125.0);
  }
}