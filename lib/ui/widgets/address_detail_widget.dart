
import 'package:address_transfer/ui/provider/address_detail_provider.dart';
import 'package:address_transfer/ui/widgets/simple_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddressDetailWidget extends StatelessWidget {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  AddressDetailWidget({super.key});

  late AddressDetailProvider _addressDetailProvider;

  List<String> images = [
    "https://ichef.bbci.co.uk/news/640/cpsprodpb/E172/production/_126241775_getty_cats.png",
    "https://www.sisain.co.kr/news/photo/202110/45791_82634_4851.jpg",
    "https://src.hidoc.co.kr/image/lib/2022/5/4/1651651323632_0.jpg"
  ];

  bool visibility = false;

  void copyToClipboard() {
    logger.i(_addressDetailProvider.phoneNum.toString());
    Clipboard.setData(ClipboardData(text: _addressDetailProvider.phoneNum.toString()));
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: "$message 복사되었습니다.", // 메시지 내용
        toastLength: Toast.LENGTH_SHORT, // 메시지 시간 - 안드로이드
        gravity: ToastGravity.BOTTOM, // 메시지 위치
        timeInSecForIosWeb: 1, // 메시지 시간 - iOS 및 웹
        backgroundColor: Colors.white, // 배경
        textColor: Color(0xffcdffb7), // 글자
        fontSize: 16.0 // 글자 크기
    );
  }

  @override
  Widget build(BuildContext context) {
    _addressDetailProvider = Provider.of<AddressDetailProvider>(context);

    return SizedBox(
      height: 400.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h, left: 16.w),
            child: SimpleTextWidget(
              text: _addressDetailProvider.title.toString(),
              fontSize: 15.sp,
              color: Colors.black87,
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 15.h, left: 8.w, right: 8.w),
          //   child: SimpleTextWidget(text: "일본, 810-0004 Fukuoka, Chuo Ward, Watanabe",fontSize: 16.sp, color: Colors.grey,),
          // ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
            child: SimpleTextWidget(text: _addressDetailProvider.address.toString(),fontSize: 16.sp, color: Colors.grey,),
          ),
          addressResult()
        ],
      ),
    );
  }

  Widget addressResult() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: SimpleTextWidget(text: "도도부현", fontSize: 16.sp, color: Colors.black54,),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
            child: borderContainer(_addressDetailProvider.dodobuKen.toString()),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: SimpleTextWidget(text: "시구정촌명", fontSize: 16.sp, color: Colors.black54,),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
            child: borderContainer(_addressDetailProvider.shiChouSon.toString()),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: SimpleTextWidget(text: "이후의 주소", fontSize: 16.sp, color: Colors.black54,),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
            child: borderContainer(_addressDetailProvider.etcAddress.toString()),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: SimpleTextWidget(text: "체류지 · 호텔명", fontSize: 16.sp, color: Colors.black54,),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
            child: borderContainer(_addressDetailProvider.locationName.toString()),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: TextButton.icon(
              onPressed: () {
                copyToClipboard();
                showToast("전화번호");
                },
              icon: const Icon(Icons.copy),
              label: Text('일본 내 연락 가능한 전화번호'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
            child: borderContainer(_addressDetailProvider.phoneNum.toString()),
          ),
        ],
      ),
    );
  }
  
  Widget borderContainer(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey),
        color: Colors.white
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      width: double.infinity,
      height: 38.h,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SimpleTextWidget(text: text, fontSize: 16, color: Colors.black,),
      ),
    );
  }
}
