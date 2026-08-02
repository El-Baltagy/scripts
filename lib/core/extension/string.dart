import 'package:newf/core/shared/methods/print.dart';


extension StringExtension on String {
  String get lowerCaseFirst {
    if (isEmpty) return this;
    return this[0].toLowerCase() + substring(1);
  }
  // Future<void>  redirectToPhoneCall( ) async {
  //
  //   try{
  //     var url = Uri.parse('tel:$this');
  //     await launchUrl(url);
  //   }catch(e){
  //     PrintHelper().ordinaryPrint(e.toString());
  //   }
  //
  // }
  // Future<void> openDialer( ) async {
  //   final uri = Uri(
  //     scheme: 'tel',
  //     path: this,
  //
  //   );
  //
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   }
  // }
}