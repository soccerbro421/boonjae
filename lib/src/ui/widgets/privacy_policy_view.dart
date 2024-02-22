import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    body: SafeArea(
        child: Browser(
          initialUriString: 'https://soccerbro421.github.io/boonjae-website/privacy_policy.html',
        ),
      ),
    
    );

  }
}