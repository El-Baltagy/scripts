part of 'main_home_screen.dart';

abstract class MainHomePageBaseState extends State<MainHomePage> {
  late final MainHomeCubit mainHomeCubit;

  @override
  void initState() {
    mainHomeCubit = MainHomeCubit.get(context: context);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
