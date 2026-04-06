import 'package:flutter/material.dart';

class ToolboxScreen extends StatelessWidget {
  const ToolboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Toolbox Page',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
