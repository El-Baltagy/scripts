part of 'main_home_cubit.dart';

@immutable
abstract class MainHomeState {}

class MainHomeLoaded extends MainHomeState {

  MainHomeLoaded({
     this.allWorkersEmit,
    this.refreshOrInit,
   });
  final BaseEmit? allWorkersEmit ;
  final MainHomeState? refreshOrInit;

  MainHomeLoaded copyWith({
    BaseEmit? allWorkersEmit, 
    MainHomeState? refreshOrInit,
  }) {
    return MainHomeLoaded(
      refreshOrInit: refreshOrInit ?? this.refreshOrInit,
       allWorkersEmit: allWorkersEmit ?? this.allWorkersEmit,
     );
  }
}

 
