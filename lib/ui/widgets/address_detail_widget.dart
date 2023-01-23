import 'package:address_transfer/ui/provider/address_detail_provider.dart';
import 'package:address_transfer/ui/widgets/simple_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddressDetailWidget extends StatelessWidget {
  AddressDetailWidget({super.key});

  late AddressDetailProvider _addressDetailProvider;

  List<String> images = [
    "https://ichef.bbci.co.uk/news/640/cpsprodpb/E172/production/_126241775_getty_cats.png",
    "https://www.sisain.co.kr/news/photo/202110/45791_82634_4851.jpg",
    "https://src.hidoc.co.kr/image/lib/2022/5/4/1651651323632_0.jpg"
  ];

  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    _addressDetailProvider = Provider.of<AddressDetailProvider>(context);

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
            padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
            child: SimpleTextWidget(
              text: _addressDetailProvider.address.toString(),
              fontSize: 16.sp,
              color: Colors.grey,
            ),
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
            child: SimpleTextWidget(
              text: "도도부현",
              fontSize: 16.sp,
              color: Colors.black54,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
            child: borderContainer(_addressDetailProvider.dodobuKen.toString()),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: SimpleTextWidget(
              text: "시구정촌명",
              fontSize: 16.sp,
              color: Colors.black54,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
            child:
                borderContainer(_addressDetailProvider.shiChouSon.toString()),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: SimpleTextWidget(
              text: "이후의 주소",
              fontSize: 16.sp,
              color: Colors.black54,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
            child:
                borderContainer(_addressDetailProvider.etcAddress.toString()),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: SimpleTextWidget(
              text: "체류지 · 호텔명",
              fontSize: 16.sp,
              color: Colors.black54,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
            child:
                borderContainer(_addressDetailProvider.locationName.toString()),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: SimpleTextWidget(
              text: "일본 내 연락 가능한 전화번호",
              fontSize: 16.sp,
              color: Colors.black54,
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
          color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      width: double.infinity,
      height: 38.h,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SimpleTextWidget(
          text: text,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget borderContainer(String text) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey),
          color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      width: double.infinity,
      height: 38.h,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SimpleTextWidget(
          text: text,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildPlaceList(List<String> images) {
    return SizedBox(
      height: 300.h,
      child: ListView.builder(
          itemCount: 1,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return addressResult();
          }),
    );
  }
}
