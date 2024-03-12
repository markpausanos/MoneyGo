import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  final Widget child;

  const BaseCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      surfaceTintColor: Theme.of(context).cardColor,
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(15),
        alignment: Alignment.topLeft,
        child: child,
      ),
    );
  }
}
