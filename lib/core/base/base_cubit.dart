// lib/core/base/base_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';



abstract class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);

  bool _isDisposed = false;

  Future<void> init();
  @protected
  void safeEmit(T state) {
    if (!_isDisposed && !isClosed) emit(state);
  }

  @protected
  void handleError(Object error, [StackTrace? stackTrace]) {
    debugPrint('[$runtimeType] Cubit error: $error');
  }

  @override
  Future<void> close() {
    _isDisposed = true;
    return super.close();
  }


// void cancelRequest(int id) => CancelManager.cancel(id);

}


enum RequestTypeBackV1 { init, reload, pagination }

abstract class BaseRequestBackType {}

class Init extends BaseRequestBackType {
  Init._();
  static final Init _instance = Init._();
  factory Init() => _instance;
}

class Reload extends BaseRequestBackType {
  Reload._();
  static final Reload _instance = Reload._();
  factory Reload() => _instance;
}

class PaginationInfo<P> extends BaseRequestBackType {
  final int? currentPage, lastPage;
  final P? oldDataToCombine;
  PaginationInfo({required this.currentPage, required this.lastPage, required this.oldDataToCombine});
}
