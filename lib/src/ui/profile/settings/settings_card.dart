import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final Function(BuildContext context) onTap;
  final String text;
  final Icon icon;

  const SettingsCard({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        InkWell(
          onTap: () {
            onTap(context);
          },
          child: SizedBox(
            width: double.infinity,
            height: 70,
            child: Row(
              children: [
                icon,
                const SizedBox(width: 10),
                Text(text),
                const Spacer(),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
