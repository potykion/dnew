import 'dart:ui' as ui;
import 'package:flutter/material.dart';

OverlayEntry showLoadingOverlay(BuildContext context) {
  var loadingOverlay = OverlayEntry(
    builder: (_) => Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(color: Colors.transparent),
        ),
        Center(child: CircularProgressIndicator()),
      ],
    ),
  );
  Overlay.of(context)!.insert(loadingOverlay);
  return loadingOverlay;
}
