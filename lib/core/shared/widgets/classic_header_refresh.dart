//  import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:newf/core/extension/context.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
//
//
// class ClassicHeaderRefresh extends StatelessWidget {
//   const ClassicHeaderRefresh({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ClassicHeader(
//       refreshingIcon:  const SizedBox(
//         width: 25.0,
//         height: 25.0,
//         child: CircularProgressIndicator.adaptive(),
//       ),
//       releaseText:'release_to_refresh'.tr()  ,
//       idleText:'pull_down_to_refresh'.tr()   ,
//       completeText:'refresh_completed'.tr()  ,
//       refreshingText:"${'refreshing'.tr()} ...." ,
//       textStyle:   TextStyle(color: context.theme.primaryColor),
//
//       completeIcon:   Icon(Icons.done, color: context.theme.colorScheme.onPrimary),
//       releaseIcon :   Icon(Icons.refresh, color:  context.theme.primaryColor),
//
//       // failedIcon: const Icon(Icons.error, color: Colors.grey),
//       // idleIcon : const Icon(Icons.arrow_downward, color: Colors.grey),
//     );
//   }
// }
