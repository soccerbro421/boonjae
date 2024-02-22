import 'package:boonjae/src/policies/initialization_helper.dart';
import 'package:flutter/material.dart';

class InitializeScreen extends StatefulWidget {
  final Widget targetWidget;
  const InitializeScreen({
    super.key,
    required this.targetWidget,
  });

  @override
  State<InitializeScreen> createState() => _InitializeScreenState();
}

class _InitializeScreenState extends State<InitializeScreen> {
  final _initializerHelper = InitializerHelper();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final navigator = Navigator.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializerHelper.initialize();
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => widget.targetWidget),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
