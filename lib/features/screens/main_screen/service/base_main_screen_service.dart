import 'package:newf/core/constants/app_typedef.dart';
import 'package:newf/core/base/base_service.dart';

/// Abstract contract for the main_screen service layer.
/// The cubit depends on this, not on a concrete implementation.
abstract class BaseMainScreenService extends BaseService {
  // TODO: declare service method signatures here

  /// Abstract contract — implemented by [MainScreenRemoteService].
  Future<void> getProjectsServ(
    RequestCallbackObserver<PojectsData, NoParameters> requestInfo,
  );
}
