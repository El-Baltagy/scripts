import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';
import 'package:newf/core/shared/widgets/text_inputs/base_text_input_data.dart';

class PhoneInputData extends BaseTextInputData {
  PhoneInputData({
    super.controller,
    super.isLabel,
    IconData? icon,
    super.field
  }) : super(
    icon: Icons.phone,
     keyboardType:  .phone,
     labelText: 'phone'.tr(),
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    validator: (value) {
      if (value?.isEmpty == true) {
        return "can't_be_empty".tr();
      }

      return null;
    },
  );
}