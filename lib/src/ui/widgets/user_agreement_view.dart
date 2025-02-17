import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';

class UserAgreementView extends StatelessWidget {
  const UserAgreementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    body: const SafeArea(
        child: Browser(
          initialUriString: 'https://boonjae.com/terms-of-use/',
        ),
      ),
    
    );

  }
}