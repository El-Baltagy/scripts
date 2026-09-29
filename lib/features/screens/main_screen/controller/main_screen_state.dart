part of 'main_screen_cubit.dart';

@immutable
abstract class MainScreenState {}

class MainScreenLoaded extends MainScreenState {

  MainScreenLoaded({
    this.getProjectsState,
     this.allWorkersEmit,
    this.refreshOrInit,
   });
  final BaseEmit? allWorkersEmit , getProjectsState;
  final MainScreenState? refreshOrInit;

  MainScreenLoaded copyWith({
    BaseEmit? getProjectsState,
    BaseEmit? allWorkersEmit, 
    MainScreenState? refreshOrInit,
  }) {
    return MainScreenLoaded(
      getProjectsState: getProjectsState ?? this.getProjectsState,
      refreshOrInit: refreshOrInit ?? this.refreshOrInit,
       allWorkersEmit: allWorkersEmit ?? this.allWorkersEmit,
     );
  }
}

 
