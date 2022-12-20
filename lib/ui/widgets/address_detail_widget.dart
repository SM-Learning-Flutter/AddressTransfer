import 'package:address_transfer/ui/widgets/simple_text_widget.dart';
import '../screens/main_google_map_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provider/address_detail_provider.dart';

class AddressDetailWidget extends StatelessWidget {
  AddressDetailWidget({super.key});
  late AddressDetailProvider _addressDetailProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 16.w),
            child: SimpleTextWidget(
              text: _addressDetailProvider.title.toString(),
              fontSize: 24.sp,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: SimpleTextWidget(
              text: _addressDetailProvider.address.toString(),
              fontSize: 16.sp,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
          )
        ],
      ),
    );
  }
}
