// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/Material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
//  import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mime/mime.dart';
// import 'package:newf/core/shared/methods/print.dart';
// import 'package:path_provider/path_provider.dart';
//
// abstract class ImagePickerInfo {
//
//
// static Future<File?>pickImage(ImageSource source,{bool cropped=true,bool isSquareOnly=false }) async {
//   File? pickedFile;
//   try {
//   XFile? img = await ImagePicker().pickImage(source: source);
//   if (img != null) {
//     if (_determineIfImage(img.path)) {
//       if (true
//       // img.path.endsWith('.jpg') ||
//       //     img.path.endsWith('.jpeg') ||
//       //     img.path.endsWith('.png') ||
//       //     img.path.endsWith('.gif') ||
//       //     img.path.endsWith('.svg')
//
//       ) {
//         pickedFile = await FlutterExifRotation.rotateAndSaveImage(path: img.path);
//
//         if (cropped) {
//           await cropImage(pickedFile,  isSquareOnly).then((value) {
//             pickedFile = value;
//           });
//         }
//         // if (enableCompression) {
//         //   await compressImage(pickedFile!).then((value) {
//         //     pickedFile = value;
//         //   });
//         // }
//       }
//     }
//   }
// } on PlatformException catch (e) {
//   PrintHelper().ordinaryPrint('$e \n PlatformException occured!');
//   } catch (e) {
//     PrintHelper().ordinaryPrint('Access Denied');
//   if (!await Permission.mediaLibrary.status.isGranted) {
//   // Dialouges.showAlertDialog(context, content: AppString.allowAccessToGallery.translate());
//   }
//
//     PrintHelper().ordinaryPrint('$e \nException occured!');
//   }
//
//   return pickedFile;
// }
//
// static   Future<File> cropImage(File imageFile,bool isSquareOnly) async {
//     File crpoedFile = imageFile;
//
//     CroppedFile? cropped = await ImageCropper().cropImage(
//         sourcePath: crpoedFile.path,
//         aspectRatio: isSquareOnly ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null, // Force square crop
//         uiSettings: [
//           AndroidUiSettings(
//               toolbarTitle: 'Crop',
//               showCropGrid: true,
//               cropGridColor: Colors.black,
//               aspectRatioPresets: _aspectRatioPresets,
//               initAspectRatio: CropAspectRatioPreset.original,
//               lockAspectRatio: isSquareOnly),
//           IOSUiSettings(title: 'Crop', aspectRatioPresets: _aspectRatioPresets, aspectRatioLockEnabled: isSquareOnly)
//         ]);
//
//     if (cropped?.path != null) {
//       crpoedFile = File(cropped!.path);
//     }
//     return crpoedFile;
//   }
//
//   // Future<File?> compressImage(File file) async {
//   //   CompressFormat type = CompressFormat.jpeg;
//   //   final targetPath = "${file.parent.path}/compressed_${file.uri.pathSegments.last}.${type.name}";
//   //
//   //   XFile? result = await FlutterImageCompress.compressAndGetFile(
//   //     file.absolute.path,
//   //     targetPath,
//   //     format: type,
//   //     quality: 25,
//   //   );
//   //   if (result == null) return null;
//   //   final int originalSize = await file.length();
//   //   final int newSize = await result.length();
//   //   return newSize < originalSize ? File(result.path) : file;
//   // }
//
//
//
// static final List<CropAspectRatioPreset> _aspectRatioPresets = [
//     CropAspectRatioPreset.square,
//     CropAspectRatioPreset.ratio3x2,
//     CropAspectRatioPreset.original,
//     CropAspectRatioPreset.ratio4x3,
//     CropAspectRatioPreset.ratio16x9
//   ];
//
//
// static bool _determineIfImage(String path) {
//     String? mimeStr = lookupMimeType(path);
//     final fileType = mimeStr!.split('/');
//     if (fileType[0] == 'image') {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }