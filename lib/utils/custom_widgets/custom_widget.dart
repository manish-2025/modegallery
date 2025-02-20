import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mode_gallery/common/app_constants.dart';
import 'package:mode_gallery/utils/app_colors.dart';
import 'package:mode_gallery/utils/app_sizes.dart';
import 'package:shimmer/shimmer.dart';

class CustomWidget {
  static customAppBar(
      {Color? color,
      Widget? leading,
      required String title,
      List<Widget>? actionButtons}) {
    return Container(
      height: AppSizes().appBarHeight,
      width: ScreenUtil().screenWidth,
      padding: EdgeInsets.only(top: 15.h),
      decoration: BoxDecoration(
          color: AppColors.appBarColor.withOpacity(0.5),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(AppSizes().bodyCurveRadius),
            bottomLeft: Radius.circular(AppSizes().bodyCurveRadius),
          ),
          gradient: LinearGradient(colors: [
            AppColors.appBarColor,
            AppColors.appBarColor,
            AppColors.blueColor,
            AppColors.blueColor,
          ])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 10.w),
          leading ?? SizedBox(width: 16.w),
          const Spacer(),
          Text(title,
              style: TextStyle(
                  color: AppColors.appBarTitleColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          actionButtons == null || actionButtons.isEmpty
              ? SizedBox(width: 25.w)
              : Row(
                  children: actionButtons,
                ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }

  static imageBuilder({required String url, required bool circularImage}) {
    print("object === ${url}");
    if (url.startsWith("http") || url.startsWith("https")) {
      return Container(
        alignment: Alignment.center,
        clipBehavior: circularImage ? Clip.antiAlias : Clip.none,
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
        decoration: BoxDecoration(
          color: AppColors.transparentColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: CachedNetworkImage(
          imageUrl: url,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
          placeholder: (context, url) {
            return CustomWidget.buildSimmer();
          },
          errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error)),
        ),
      );
    }

    if (url.endsWith(".png") ||
        url.endsWith(".jpg") ||
        url.endsWith(".jpeg") ||
        url.endsWith(".gif")) {
      return Container(
        alignment: Alignment.center,
        clipBehavior: circularImage ? Clip.antiAlias : Clip.none,
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          // borderRadius: BorderRadius.circular(15),
        ),
        child: Image.asset(
          url,
          filterQuality: FilterQuality.high,
          fit: BoxFit.fill,
        ),
      );
    }
    return const SizedBox();
  }

  static buildSimmer() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
      child: Shimmer.fromColors(
        highlightColor: Colors.white.withOpacity(0.2),
        baseColor: Colors.black.withOpacity(0.2),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.blackColor),
        ),
      ),
    );
  }

  static backButton(
      {required BuildContext context, required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.arrow_back_ios_rounded,
        color: AppColors.whiteColor,
        size: AppSizes().appBarIconSize,
      ),
    );
  }

  static loadingWidget({String? loadingText}) {
    // return SpinKitPumpingHeart(
    //   size: 100.h,
    //   color: AppColors.appBarColor,
    // );
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      // width: 200.w,
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: AppColors.blueColor,
            semanticsLabel: "semanticsLabel",
          ),
          SizedBox(
            width: 30.w,
          ),
          Text(
            loadingText ?? "Loading",
            style: TextStyle(color: AppColors.blackColor, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  static appBarMenuButton({required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: AppSizes().appBarButtonSize,
          width: AppSizes().appBarButtonSize,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.appBarColor,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(-2, -2),
                    color: AppColors.appBarTitleColor,
                    blurRadius: 12.r,
                    spreadRadius: 1.r)
              ]),
          child: Icon(
            Icons.more_vert,
            color: AppColors.appBarTitleColor,
          )),
    );
  }

  static downloadButton({required VoidCallback callback}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: 50.h,
        width: 50.h,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.appBarColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.appBarTitleColor,
                offset: Offset(0.h, 0.h),
                blurRadius: 10.r,
                spreadRadius: 5.r,
              ),
            ]),
        child: Icon(
          Icons.file_download_outlined,
          color: AppColors.appBarTitleColor,
        ),
      ),
    );
  }

  static favoriteButton() {
    return Container(
      height: 50.h,
      width: 50.h,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.appBarColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.appBarTitleColor,
              offset: Offset(0.h, 0.h),
              blurRadius: 10.r,
              spreadRadius: 5.r,
            ),
          ]),
      child: Icon(
        Icons.favorite_border_outlined,
        color: AppColors.appBarTitleColor,
      ),
    );
  }

  static setAsWallpaperButton() {
    return Container(
      height: 50.h,
      width: 50.h,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.appBarColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.appBarTitleColor,
              offset: Offset(0.h, 0.h),
              blurRadius: 10.r,
              spreadRadius: 5.r,
            ),
          ]),
      child: Icon(
        Icons.settings_cell_rounded,
        color: AppColors.appBarTitleColor,
      ),
    );
  }

  static watchAdPopupWidget(
      {required BuildContext context, required void Function() showAd}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                AppConstant.disclaimer,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.blackColor),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppConstant.watchAdToDownloadImage,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.blackColor),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    button(
                        actionTitle: "Cancel",
                        onTap: () {
                          Navigator.pop(context);
                        },
                        context: context),
                    button(
                        actionTitle: "OK",
                        onTap: () {
                          showAd();
                        },
                        context: context),
                  ],
                ),
              ],
            ),
          );
        });
  }

  static button(
      {required BuildContext context,
      required String actionTitle,
      double? height,
      double? width,
      required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 30.h,
        width: width ?? 70.w,
        decoration: BoxDecoration(
          color: AppColors.appBarColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
            child: Text(
          actionTitle,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.whiteColor),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
