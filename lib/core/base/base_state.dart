 import '../../core/api_helper/dio_error_handler.dart';
 import 'base_cubit.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared emit wrappers (used inside every feature-specific state)
// ─────────────────────────────────────────────────────────────────────────────

abstract class BaseEmit {
  @override
  String toString();
}

class Loading<T> extends BaseEmit {
  final T? item;
  Loading([this.item ]);
  @override
  String toString() => 'Loading';
}

class ErrorState extends BaseEmit {
  final Failure failure;
  ErrorState(this.failure);
  @override
  String toString() => 'ErrorState';
}

class Success<T> extends BaseEmit {
  final T? data;
  final BaseRequestBackType? requestType;
  Success([this.data, this.requestType]);
  @override
  String toString() => 'Success<$T>';
}

