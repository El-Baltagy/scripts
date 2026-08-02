import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/Material.dart';
import 'package:newf/core/shared/widgets/text_inputs/base_text_input_data.dart';

class PasswordInputData extends BaseTextInputData {
  PasswordInputData({
    super.controller,
    String? labelText,
    String? Function(String?)? additionalValidator,
    super.isLabel,
    super.field,
  }) : super(
         icon: Icons.lock,
         isObscureText: true,
         labelText: labelText ?? 'password'.tr(),
         validator: (String? val) {
           if (val?.isEmpty == true) {
             return "can't_be_empty".tr();
           }
           if ((val ?? '').toString().length < 6) {
             return '${'the_password_must_be_at_least_6_characters'.tr()}.';
           }
           if (additionalValidator != null) {
             return additionalValidator(val);
           }
           return null;
         },
       );

}
