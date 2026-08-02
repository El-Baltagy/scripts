 import 'package:flutter/Material.dart';

class LoadingWidgetApp extends StatelessWidget {
  const LoadingWidgetApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      strokeWidth: 2,
      valueColor: AlwaysStoppedAnimation<Color>(
        Colors.white,
      ),
    );
  }
}