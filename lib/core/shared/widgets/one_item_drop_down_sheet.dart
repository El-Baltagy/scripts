import 'package:flutter/Material.dart';
import 'package:newf/core/extension/context.dart';
import 'package:newf/core/extension/double.dart';
import 'package:newf/core/shared/widgets/circle_radio.dart';
import 'package:newf/core/theming/app_colors.dart';

class OneItemDropBottomSheetItem extends StatelessWidget {
  const OneItemDropBottomSheetItem({
    super.key,
    required this.onTap,
    required this.title,
    required this.isLastItem,
    required this.isSelected,
      this.style,
    this.showOptionBesideRadioSelect = true,
    this.isRadio = true,
  });

  final void Function()? onTap;
  final String title;
  final bool isLastItem, isRadio,isSelected, showOptionBesideRadioSelect;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(1.5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                crossAxisAlignment: .start,
                children: [
                  15.horizontalSpace,

                  CustomSelectedCircleAndSquare(isSelected: isSelected,
                  isRadio: isRadio,
                  ),
                  if (showOptionBesideRadioSelect)
                    15.horizontalSpace
                  else
                    Spacer(),
                  Text(title,style:style),
                ],
              ),

              if (!isLastItem)
                Container(
                  height: 0.5,
                  margin: const EdgeInsetsDirectional.fromSTEB(15, 15, 0, 15),
                  color: AppColors.contractorGreyText,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
