import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final Widget content;
  const TopBar({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 2
          ))
        ),
        height: 70,
        child: content
    );
  }
}