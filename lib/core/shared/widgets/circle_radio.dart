import 'package:flutter/material.dart';
import 'package:newf/core/constants/app_assets.dart';
import 'package:newf/core/extension/context.dart';
import 'package:newf/core/shared/widgets/asset_image.dart';


class CustomSelectedCircleAndSquare extends StatelessWidget {
  const CustomSelectedCircleAndSquare({
    super.key,
    required this.isSelected,
    required this.isRadio,
  });
  final  bool isSelected,isRadio;
  @override
  Widget build(BuildContext context) {

    if(!isRadio){
      return Icon(isSelected?Icons.check_circle_rounded:Icons.circle_outlined,color: context.theme.primaryColor, );
    }


    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        const CustomAssetImageWidget(AppAssets.imagesCircleSvg,
          width: 24,
          height:24 ,
        ),
        if(isSelected)
            CustomAssetImageWidget(AppAssets.imagesDotSvg,
            color: context.theme.primaryColor,
            width: 12,
            height:12 ,
          ),
      ],
    );
  }
}
