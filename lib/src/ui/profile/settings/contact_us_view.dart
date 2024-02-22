import 'package:flutter/material.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('contact us'),
      ),
      body: const Center(
        child: Text('contact us at: boonjae.help@gmail.com',
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
