// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/Material.dart';
// import 'package:newf/core/base/base_cubit.dart';
// import 'package:newf/core/base/base_service.dart';
// import 'package:newf/core/internet/connected_bloc.dart';
// import 'package:newf/core/shared/methods/print.dart';
// import 'package:newf/core/storage/hive_storage.dart';
// import 'package:newf/core/shared/methods/location_Service.dart';
// import 'package:newf/features/screens/login/data/model/login_res/login_res.dart';
// import 'package:newf/features/screens/main_home/service/main_home_service.dart';
// import 'package:newf/features/screens/projects/data/model/create_project_parameters.dart';
// import 'package:newf/features/screens/projects/service/projects_service.dart';
// import 'package:newf/core/constants/app_locator.dart';
//  import 'package:newf/features/screens/projects/data/model/create_project_res/create_project_res.dart';
// import 'package:newf/features/screens/projects/ui/add_edit_pj/widgets/location_selection.dart';
//
// class OfflineSyncService {
//   OfflineSyncService._();
//   static final OfflineSyncService _instance = OfflineSyncService._();
//   factory OfflineSyncService() => _instance;
//
//   final ValueNotifier<bool> isSyncingNotifier = ValueNotifier<bool>(false);
//
//   void init() {
//     ConnectivityService.connectivityStream.listen((hasInternet) {
//       if (hasInternet) {
//         _syncOfflineProjectRequests();
//       }
//     });
//   }
//
//   Future<void> _syncOfflineProjectRequests() async {
//     if (isSyncingNotifier.value) return;
//
//     final offlineRequestsJson = HiveStorage().readData<List<String>>('offline_project_requests');
//     if (offlineRequestsJson == null || offlineRequestsJson.isEmpty) return;
//
//     // Check the user's role before proceeding with sync.
//     // A Completer is used to capture the async callback result so we can
//     // properly guard the rest of this method with an early return.
//     final mainHomeService = AppLocator().call()<MainHomeService>();
//     final isAdminCompleter = Completer<bool>();
//
//     await mainHomeService.getProfileDataServ(RequestCallbackObserver<User, NoParameter>(
//       parameter: NoParameter(),
//       onLoadCallback: () {},
//       baseRequestBackType: Init(),
//       onRightCallback: (data) {
//         isAdminCompleter.complete(data?.role == 'admin');
//       },
//       onLeftCallback: (failure) {
//         isAdminCompleter.complete(false);
//       },
//     ));
//
//     final isAdmin = await isAdminCompleter.future;
//     if (!isAdmin) return;
//
//     isSyncingNotifier.value = true;
//     List<String> failedRequests = [];
//
//     for (String requestJson in offlineRequestsJson) {
//       try {
//         final Map<String, dynamic> requestMap = jsonDecode(requestJson) as Map<String, dynamic>;
//         final CreateProjectParameters parameter = CreateProjectParameters.fromJson(requestMap);
//
//         String locationAddress = parameter.location;
//
//         if (locationAddress.isEmpty && parameter.latitude.isNotEmpty && parameter.longitude.isNotEmpty) {
//           final lat = double.tryParse(parameter.latitude);
//           final lng = double.tryParse(parameter.longitude);
//           if (lat != null && lng != null) {
//             final addressModel = await LocationService().reverseGeocode(LatLng(lat, lng));
//             if (addressModel != null) {
//               locationAddress = addressModel.toString();
//             }
//           }
//         }
//
//         final updatedParameter = CreateProjectParameters(
//           name: parameter.name,
//           owner_name: parameter.owner_name,
//           start_date: parameter.start_date,
//           end_date: parameter.end_date,
//           latitude: parameter.latitude,
//           longitude: parameter.longitude,
//           contract_value: parameter.contract_value,
//           currency: parameter.currency,
//           extra_details: parameter.extra_details,
//           description: parameter.description,
//           projectId: parameter.projectId,
//           location: locationAddress,
//         );
//
//         final projectsService = AppLocator().call()<ProjectsService>();
//
//
//         bool success = false;
//
//         await projectsService.createProjectServ(
//           RequestCallbackObserver<(CreateProjectRes,bool), CreateProjectParameters>(
//             parameter: updatedParameter,
//             onLoadCallback: () {},
//             onRightCallback: (data) {
//               success = true;
//             },
//             onLeftCallback: (failure) {
//               if (failure.error is SocketException) {
//                  success = false;
//               } else {
//                  success = true;
//               }
//             },
//           ),
//         );
//
//         if (!success) {
//           failedRequests.add(requestJson);
//         }
//       } catch (e) {
//       }
//     }
//
//     if (failedRequests.isEmpty) {
//       await HiveStorage().deleteData('offline_project_requests');
//     } else {
//       await HiveStorage().writeData('offline_project_requests', failedRequests);
//     }
//
//     isSyncingNotifier.value = false;
//   }
// }
