
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
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: SimpleTextWidget(text: "일본, 810-0004 Fukuoka, Chuo Ward, Watanabe",fontSize: 16.sp, color: Colors.grey,),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                backgroundColor: Colors.blue
              ),
              onPressed: () {
                _addressDetailProvider.setVisibility(!visibility);
                visibility = !visibility;
              },
              child: SimpleTextWidget(text: "주소 변환", fontSize: 16.sp, color: Colors.white,),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            child: Visibility(
              visible: _addressDetailProvider.visibility,
              child: addressResult()
            ),
          )
        ],
      ),
    );
  }

  Widget addressResult() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
          child: SimpleTextWidget(text: "테스트 주소1", fontSize: 16.sp, color: Colors.grey,),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
          child: SimpleTextWidget(text: "테스트 주소2", fontSize: 16.sp, color: Colors.grey,),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
          child: SimpleTextWidget(text: "테스트 주소3", fontSize: 16.sp, color: Colors.grey,),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
          child: SimpleTextWidget(text: "테스트 주소4", fontSize: 16.sp, color: Colors.grey,),
        )
      ],
    );
  }

  Widget buildPlaceImageList(List<String> images) {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(images[index]),
          );
        }
      ),
    );
  }
}