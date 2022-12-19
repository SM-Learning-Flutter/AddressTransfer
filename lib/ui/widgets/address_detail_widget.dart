import 'package:address_transfer/ui/widgets/simple_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressDetailWidget extends StatelessWidget {
  AddressDetailWidget({super.key});

  List<String> images = [
    "https://ichef.bbci.co.uk/news/640/cpsprodpb/E172/production/_126241775_getty_cats.png",
    "https://www.sisain.co.kr/news/photo/202110/45791_82634_4851.jpg",
    "https://src.hidoc.co.kr/image/lib/2022/5/4/1651651323632_0.jpg"
  ];

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
              text: "하카타역",
              fontSize: 24.sp,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 8.w, right: 8.w),
            child: SimpleTextWidget(
              text: "일본, 810-0004 Fukuoka, Chuo Ward, Watanabe",
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(fontSize: 20)),
            onPressed: () {
              print("주소변환");
            },
            child: const Text('주소변환'),
          ),
        ],
      ),
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
          }),
    );
  }
}
