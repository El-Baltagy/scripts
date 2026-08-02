import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/Material.dart';
 import 'package:newf/core/shared/widgets/text_inputs/base_text_input_data.dart';

class DOPInputData extends BaseTextInputData {

  DOPInputData({
    super.controller,
    super.onTap,
    super.fontSize,
    super.fontWeight,
    super.contentPadding,
    String? labelText,
      super.field
  }) : super(
    icon: Icons.calendar_month,
     keyboardType:  .emailAddress,
     readOnly: true,
     isLabel: false,
     labelText:labelText??  'date_of_birth'.tr(),

    validator: (value) {
      if (value?.isEmpty == true) {
        return "can't_be_empty".tr();
      }
      return null;
    },
  );
}