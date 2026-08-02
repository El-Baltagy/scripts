import 'package:flutter/material.dart';
import 'package:newf/core/extension/context.dart';
import 'package:newf/core/theming/app_colors.dart';
import 'package:newf/core/theming/app_values.dart';
import 'package:newf/core/shared/widgets/text_inputs/base_text_input_data.dart';
import 'package:newf/core/shared/widgets/text_inputs/password_text_input_data.dart';

class TextInputWidget extends StatefulWidget {
  const TextInputWidget({super.key, required this.data});

  final BaseTextInputData data;

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  late bool _obscureText=widget.data.isObscureText;



  @override
  Widget build(BuildContext context) {
    return widget.data.isSingleOrMultiSelect
        ? GestureDetector(
            onTap: widget.data.onTap,
            child: AbsorbPointer(child: _buildTextFormField(widget.data, context)),
          )
        : _buildTextFormField(widget.data, context);
  }

  Widget _buildTextFormField(BaseTextInputData data, BuildContext context) {
    final bool isPassword = data is PasswordInputData;

    return TextFormField(
      focusNode: data.field?.$2,
      key: data.field?.$1,
      controller: data.controller,
      keyboardType: data.keyboardType,
      readOnly: data.readOnly,
      enabled: data.enabled,
      obscureText: isPassword ? _obscureText : data.isObscureText,
      validator:
      data.enableValidation && data.field != null
          ?
      data.validator
          : null
      ,inputFormatters: data.inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: data.onTap,
      maxLines:data.maxLines ,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: AppColors.contractorGreyText,
          fontWeight: data.fontWeight,
          fontSize: data.fontSize,
        ),
        labelStyle: TextStyle(
          color: AppColors.contractorGreyText,
          fontWeight: data.fontWeight,
          fontSize: data.fontSize,
        ),
        hintText: data.isLabel ? null : data.labelText,
        labelText: data.isLabel ? data.labelText : null,
        prefix: data.widgetPrefix,
        prefixIcon: data.widgetPrefix != null
            ? null
            : data.icon == null
            ? null
            : Icon(data.icon, color: Theme.of(context).primaryColor),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.contractorGreyText,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: context.theme.scaffoldBackgroundColor,
        contentPadding: data.contentPadding??const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.s8),
          borderSide: BorderSide(color: context.theme.canvasColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.s8),
          borderSide: BorderSide(color: context.theme.canvasColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.s8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}


