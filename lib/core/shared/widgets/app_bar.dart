import 'package:flutter/Material.dart';
import 'package:newf/core/extension/context.dart';
import 'package:newf/core/theming/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.titleWDG,
  });

  final Widget? leading,titleWDG;
  final String? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title:titleWDG??(title==null?null: Text(
          title!, style: AppTextStyles.font18SemiBold.copyWith(color: context.theme.scaffoldBackgroundColor))),
      centerTitle: true,
      leading:leading  ,
      actions:actions,
    );
  }


  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}