import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mode_gallery/model/home_data_model.dart';
import 'package:mode_gallery/screens/full_screen_image_view_screen.dart';
import 'package:mode_gallery/utils/app_colors.dart';
import 'package:mode_gallery/utils/app_sizes.dart';
import 'package:mode_gallery/utils/custom_widgets/custom_widget.dart';

class ImageListScreen extends StatefulWidget {
 final ImageData imageData;

  const ImageListScreen({super.key, required this.imageData});


  @override
  State<ImageListScreen> createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {

  ImageData? imageData;
  ScrollController? controller;

  @override
  void initState() {
    imageData  = widget.imageData;
    controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: buildBody(context),
        )
    );
  }

 Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        CustomWidget.customAppBar(
          title: imageData!.categoryTitle!,
          leading: CustomWidget.backButton(
              context: context,
              onTap: ()=> Navigator.pop(context),
          ),
          actionButtons: [],
        ),
        Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          margin: EdgeInsets.only(top: 60.h),
          decoration: BoxDecoration(
            color: AppColors.appBackgroundColor,
            borderRadius: BorderRadius.circular(AppSizes().bodyCurveRadius),
          ),
          child: buildGridView(),
        ),
      ],
    );
 }

  Widget buildGridView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.h),
      child: GridView.builder(
        controller: controller,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
        ),
        itemCount: imageData?.categoryImages?.length,
        itemBuilder: (BuildContext ctx, index) {
          return  Padding(
            padding:  EdgeInsets.only(top: index==0 || index==1 ?5.h:0),
            child: imageWidget(imageData!.categoryImages![index], index),
          );
        },
      ),
    );
  }

  Widget imageWidget(String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImageViewScreen(
              imageData: widget.imageData,
              index: index,
            )
          ),
        );
      },
      child: CustomWidget.imageBuilder(url: imageUrl, circularImage: true),
    );
  }

}
