import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class IdleEllie extends StatelessWidget {
  const IdleEllie({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(delegate: SliverChildListDelegate([
      const SizedBox(
        height: 125.0,
        child: RiveAnimation.asset('assets/rive/lottie_idle.riv'),
      ),
    ]), itemExtent: 125.0);
  }
}