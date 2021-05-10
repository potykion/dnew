import 'dart:math';

import 'package:flutter/material.dart';

class WebPadding extends StatelessWidget {
  final Widget child;
  final double maxWebWidth;

  const WebPadding({Key? key, required this.child, this.maxWebWidth = 800})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              max(0, (MediaQuery.of(context).size.width - maxWebWidth) / 2),
        ),
        child: child,
      ),
    );
  }
}
