import 'package:flutter/material.dart';

class UserSkeletonLoading extends StatelessWidget {
  const UserSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const ValueKey(0),
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.04),
              shape: BoxShape.circle,
            ),
          ),
        ),
        title: Container(
          height: 5,
          width: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.04),
            shape: BoxShape.rectangle,
          ),
        ),
        subtitle: Container(
          height: 5,
          width: 20,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.04),
            shape: BoxShape.rectangle,
          ),
        ),
      ),
    );
  }
}
