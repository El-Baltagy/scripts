part of '../main_screen_screen.dart';

/// Extracted widget: MainScreenBody
/// Semantics is applied at the call-site in main_screen_screen.dart
class MainScreenBody extends StatelessWidget {
  const MainScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Semantics(
              label: 'SizedBox',
              child: const SizedBox(),
            ),
            Semantics(
              label: 'ColumnBehaviour',
              child: const ColumnBehaviour(),
            ),
          ],
        );
  }
}
