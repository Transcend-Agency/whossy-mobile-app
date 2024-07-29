import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.size = 20,
  });
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: size,
        child: const CircularProgressIndicator.adaptive(
          backgroundColor: Colors.transparent,
          strokeWidth: 2.5,
        ),
      ), //
    );
  }
}
