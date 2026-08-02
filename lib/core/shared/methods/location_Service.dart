// import 'package:dio/dio.dart';
// import 'package:flutter/services.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:newf/core/shared/methods/print.dart';
// import 'package:newf/features/screens/projects/data/model/address_model.dart';
// import 'package:newf/features/screens/projects/ui/add_edit_pj/widgets/location_selection.dart';
//
// class LocationService {
//   LocationService._();
//
//   static final LocationService _instance = LocationService._();
//
//   factory LocationService() => _instance;
//
//   /// Get current device location
//   Future<Position?> getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//
//       if (!serviceEnabled) {
//         await Geolocator.openLocationSettings();
//         return null;
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         return null;
//       }
//
//       return await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//         ),
//       );
//     } catch (e) {
//       PrintHelper().ordinaryPrint('Location Error: $e');
//       return null;
//     }
//   }
//
//   /// Convert Position to Placemark
//   Future<Placemark?> getPlacemark(Position? position) async {
//     if (position == null) return null;
//
//     try {
//       final placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//         // localeIdentifier: "en",
//       );
//
//       if (placemarks.isEmpty) {
//         return null;
//       }
//
//       return placemarks.first;
//     } on PlatformException catch (e, stack) {
//       PrintHelper().ordinaryPrint("Reverse Geocode Error:");
//       PrintHelper().ordinaryPrint(e);
//       PrintHelper().ordinaryPrint(stack);
//       return null;
//     }catch(e){}
//   }
//
//   /// Create readable address
//   String? localOfPlaceMark(Placemark? place) {
//     if (place == null) return null;
//
//     final parts = <String>[
//       ?place .street,
//       ?place.subLocality,
//       ?place.locality,
//       ?place.subAdministrativeArea,
//       ?place.administrativeArea,
//       ?place.country,
//     ].where((e) => e.trim().isNotEmpty).toList();
//
//     if (parts.isEmpty) {
//       return null;
//     }
//
//     return parts.join(", ");
//   }
//
//   /// Get formatted address directly
//   Future<String?> getCurrentAddress() async {
//     final position = await getCurrentLocation();
//
//     if (position == null) return null;
//
//     final place = await getPlacemark(position);
//
//     return localOfPlaceMark(place);
//   }
//
//
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: 'https://nominatim.openstreetmap.org/',
//       headers: {
//         'User-Agent': 'MkaweelApp/1.0',
//         // 'lang': 'ar',
//       },
//     ),
//   );
//
//
//
//   final Map<String, AddressModel?> _geocodeCache = {};
//
//   Future<AddressModel?> reverseGeocode(LatLng? position) async {
//     if (position == null) return null;
//
//     final cacheKey = '${position.lat},${position.lng}';
//     if (_geocodeCache.containsKey(cacheKey)) {
//       return _geocodeCache[cacheKey];
//     }
//
//     try {
//       final response = await _dio.get(
//         'reverse',
//         queryParameters: {
//           'lat': position.lat,
//           'lon': position.lng,
//           'format': 'jsonv2',
//         },
//       );
//
//       final result = AddressModel.fromJson(response.data as Map<String,dynamic>);
//       _geocodeCache[cacheKey] = result;
//       return result;
//     } catch (e) {
//       PrintHelper().ordinaryPrint(e);
//       return null;
//     }
//   }
// }
// extension PositionExt on Position?{
//   LatLng? toGetLatlngFromPos()=>this==null?null:LatLng(this!.latitude,this!.longitude);
// }