part of 'main_screen_screen.dart';

abstract class MainScreenPageBaseState extends State<MainScreenPage> {
  late final MainScreenCubit mainScreenCubit;

  @override
  void initState() {
    mainScreenCubit = MainScreenCubit.get(context: context);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
