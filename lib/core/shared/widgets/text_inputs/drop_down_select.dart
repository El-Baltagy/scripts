import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/Material.dart';
 import 'package:newf/core/shared/widgets/text_inputs/base_text_input_data.dart';

class DropDownSingleSelectData extends BaseTextInputData {
  DropDownSingleSelectData({
    super.controller,
    super.isLabel,
    super.widgetPrefix,
    super.onTap,
    String? labelText,
    IconData? icon,
    String? Function(String?)? validator,
    super.field
  }) : super(
      readOnly: false,
      isSingleOrMultiSelect:true,
     icon:icon ,
      labelText:labelText?? 'tap_to_select'.tr(),
    validator: validator??(value) {
      if (value?.isEmpty == true) {
        return "can't_be_empty".tr();
      }

      return null;
    },
  );
}