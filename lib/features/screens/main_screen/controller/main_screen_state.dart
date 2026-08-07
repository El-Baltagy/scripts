part of 'main_screen_cubit.dart';

@immutable
abstract class MainScreenState {}

class MainScreenLoaded extends MainScreenState {

  MainScreenLoaded({
     this.allWorkersEmit,
    this.refreshOrInit,
   });
  final BaseEmit? allWorkersEmit ;
  final MainScreenState? refreshOrInit;

  MainScreenLoaded copyWith({
    BaseEmit? allWorkersEmit, 
    MainScreenState? refreshOrInit,
  }) {
    return MainScreenLoaded(
      refreshOrInit: refreshOrInit ?? this.refreshOrInit,
       allWorkersEmit: allWorkersEmit ?? this.allWorkersEmit,
     );
  }
}

 
