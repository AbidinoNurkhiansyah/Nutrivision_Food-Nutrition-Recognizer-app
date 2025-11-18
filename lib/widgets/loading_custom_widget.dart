import 'dart:io';

import 'package:flutter/material.dart';

class LoadingCustomWidget extends StatelessWidget {
  const LoadingCustomWidget({
    super.key,
    this.width,
    this.height,
    this.color,
    this.strokeWidth,
  });

  final double? width;
  final double? height;
  final double? strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth ?? 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
          backgroundColor: Platform.isAndroid ? Colors.transparent : null,
        ),
      ),
    );
  }
}
