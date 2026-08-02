import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:newf/core/internet/connected_bloc.dart';
import 'package:dio/dio.dart';

import '../../core/api_helper/dio_error_handler.dart';
import 'base_cubit.dart';

abstract class BaseService{

}
class RequestCallbackObserver<T, P>   {
  RequestCallbackObserver({
      this.baseRequestBackType,
      this.parameter,
    required this.onLoadCallback,
    required this.onRightCallback,
    required this.onLeftCallback,
    this.cancelToken,
  });

  final BaseRequestBackType? baseRequestBackType;
  final P? parameter;
  final void Function() onLoadCallback;
  final void Function(T? data) onRightCallback;
  final void Function(Failure failure) onLeftCallback;
  final CancelToken? cancelToken;
}

extension RequestHandler<T, P> on RequestCallbackObserver<T, P> {
  Future<void> handleRequest({
    required Future<Either<Failure, T>> Function(CancelToken? token) fetchFromClient,
     Future<T?> Function()? fetchLocal,
    Future<void> Function(T? old, T? newData)? saveLocal,
    Future<void> Function()? clearLocal,
    T Function(T oldData, T newData)? combinePagination, // <--- 1. ADD THIS
  }) async {
    final BaseRequestBackType type = baseRequestBackType??Reload();

     if (type is Init) {
      if (fetchLocal != null) {
        final localData = await fetchLocal();
        if (localData != null) {
          Future.microtask(() => onRightCallback(localData));
          return;
        }
      }
    } else if (type is Reload) {
      // final hasInternet = await ConnectivityService.validateInternetConnection();
      // if (!hasInternet) {
      //   onLeftCallback(Failure('No internet connection.', null, const SocketException('No internet')));
      //   return;
      // }
      if(clearLocal!=null){
        await clearLocal?.call();
      }
    } else if (type is PaginationInfo) {
      if ((type.currentPage??0) >= (type.lastPage??0)) return;
    }

    // ── Notify loading ─────────────────────────────────────────────────────
    onLoadCallback();

    // ── Fetch from remote repo ─────────────────────────────────────────────
    // Pass the cancelToken from the observer to the fetch function
    final result = await fetchFromClient(cancelToken);

    // ── Handle result ──────────────────────────────────────────────────────
    await result.fold(
          (failure) async {
            if (fetchLocal != null) {
              final localData = await fetchLocal();
              if (localData != null) {
                onRightCallback(localData);
                return;
              }
            }
            onLeftCallback(failure);
          },
          (newData) async {
            T finalData = newData;
            T? oldData;
            
        // ── Combine pagination data if needed ──────────────────────────────
        if (type is PaginationInfo && fetchLocal != null) {
          oldData = await fetchLocal.call();
          if (oldData != null && combinePagination != null) {
            finalData = combinePagination(oldData, newData);
          }
        }

        if(saveLocal != null){
          await saveLocal(oldData, finalData); // Save the combined finalData!
        }

        onRightCallback(finalData); // Yield the combined finalData to the Cubit!
      },
    );
  }
}
