
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatingModal extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const FloatingModal({
    Key? key,
    required this.child,
    this.backgroundColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.w, right: 20.w, left: MediaQuery.of(context).size.width * 0.4),
        child: Material(
          color: backgroundColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
    );
  }
}

Future<T> showFloatingModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  Color? barrierColor
}) async {
  final result = await showCustomModalBottomSheet(
      context: context,
      builder: builder,
      barrierColor: barrierColor,
      containerWidget: (_, animation, child) => FloatingModal(
        child: child,
      ),
      expand: false);

  return result;
}