import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mode_gallery/common/app_constants.dart';
import 'package:mode_gallery/controller/ad_controller/ad_controller.dart';
import 'package:mode_gallery/controller/wallpaper_setting_controller.dart';
import 'package:mode_gallery/model/home_data_model.dart';
import 'package:mode_gallery/screens/full_screen_image_view_screen.dart';
import 'package:mode_gallery/utils/app_colors.dart';
import 'package:mode_gallery/utils/app_sizes.dart';
import 'package:mode_gallery/utils/custom_widgets/custom_widget.dart';

class ImageSliderViewer extends StatefulWidget {
  final ImageData imageData;

  const ImageSliderViewer({super.key, required this.imageData});

  @override
  State<ImageSliderViewer> createState() => _ImageSliderViewerState();
}

class _ImageSliderViewerState extends State<ImageSliderViewer> {
  late PageController pageController;
  WallpaperSettingController wallpaperSettingController =
      Get.put(WallpaperSettingController());
  int selectedIndex = 0;
  AdController adController = Get.put(AdController());

  NativeAd? nativeAd;
  bool _nativeAdIsLoaded = false;
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  BannerAd? _bannerAd;
  bool _isLoaded = false;

  /// Loads a banner ad.
  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          print("object = ==");
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');

          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
    )..load();
  }

  /// Loads a native ad.
  void loadNativeAd() {
    nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle: NativeTemplateStyle(
            templateType: TemplateType.small,
            mainBackgroundColor: Colors.purple,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

  @override
  void initState() {
    pageController = PageController();
    loadAd();
    loadNativeAd();
    // adController.createInterstitialAd();
    super.initState();
  }

  Future<bool> _onWillPop() async {
    if (adController.interstitialAd != null) {
      adController.showInterstitialAd();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  if (adController.interstitialAd != null) {
                    adController.showInterstitialAd();
                  }
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.appBarTitleColor,
                )),
            centerTitle: true,
            title: Text(
              widget.imageData.categoryTitle ?? '',
              style: TextStyle(color: AppColors.appBarTitleColor),
            ),
            backgroundColor: AppColors.appBarColor,
          ),
          body: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.black, Colors.black54]),
              boxShadow: [
                BoxShadow(
                    offset: Offset.zero,
                    blurRadius: 12.r,
                    spreadRadius: 2.r,
                    color: AppColors.appBackgroundColor)
              ]),
        ),
        buildCarousel(),
        // customAppBar(),
        GetBuilder<WallpaperSettingController>(builder: (context) {
          return Visibility(
            visible: wallpaperSettingController.isLoading,
            child: Center(
              child: CustomWidget.loadingWidget(
                  loadingText: AppConstant.settingWallpaperText),
            ),
          );
        }),
      ],
    );
  }

  Widget buildCarousel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 10.h),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullScreenImageViewScreen(
                          imageData: widget.imageData, index: selectedIndex)));
            },
            child: Container(
              width: ScreenUtil().screenWidth * 0.7,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.black, Colors.black54]),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(-5, -5),
                        blurRadius: 20.r,
                        spreadRadius: 1.r,
                        color: AppColors.appBackgroundColor)
                  ]),
              child: CustomWidget.imageBuilder(
                  url: widget.imageData.categoryImages![selectedIndex],
                  circularImage: true),
            ),
          ),
        ),
        if (_nativeAdIsLoaded) ...{
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 250,
              minHeight: 90,
              maxWidth: 300,
              maxHeight: 100,
            ),
            child: AdWidget(ad: nativeAd!),
          )
        },

        ///TODO Horizontal slider
        SizedBox(
          height: ScreenUtil().screenHeight * 0.2,
          child: PageView.builder(
            itemCount: widget.imageData.categoryImages?.length,
            controller: PageController(viewportFraction: 0.30),
            itemBuilder: (BuildContext context, int itemIndex) {
              return GestureDetector(
                  onTap: () {
                    selectedIndex = itemIndex;
                    setState(() {});
                  },
                  child: buildCarouselItem(context, itemIndex));
            },
            onPageChanged: (index) {
              selectedIndex = index;
              setState(() {});
            },
          ),
        ),

        ///TODO Ad Widget
        Visibility(
          visible: _isLoaded == true && _bannerAd != null,
          child: Container(
            height: _bannerAd!.size.height.toDouble(),
            width: _bannerAd!.size.width.toDouble(),
            color: AppColors.appBarColor,
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
      ],
    );
  }

  Widget buildCarouselItem(BuildContext context, int itemIndex) {
    return Container(
      height: selectedIndex == itemIndex
          ? ScreenUtil().screenHeight * 0.3
          : ScreenUtil().screenHeight * 0.1,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(
            width: selectedIndex == itemIndex ? 4.w : 2.w,
            color: selectedIndex == itemIndex
                ? AppColors.appBarColor
                : AppColors.appBackgroundColor),
        color: selectedIndex == itemIndex
            ? AppColors.appBarColor
            : AppColors.appBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(4.w)),
      ),
      child: CustomWidget.imageBuilder(
          url: widget.imageData.categoryImages![itemIndex],
          circularImage: false),
    );
  }

  void openBottomMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.symmetric(vertical: 30.h),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: const Alignment(0.8, 1),
              colors: [
                AppColors.gradientColor3,
                AppColors.gradientColor1,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(AppConstant.bottomModelSheetTitle.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19.sp,
                        color: AppColors.appBarColor,
                        fontWeight: FontWeight.w800)),
              ),
              SizedBox(height: 10.h),
              Divider(color: AppColors.blueColor, height: 10.h, thickness: 1.h),
              buildActionButton(
                title: AppConstant.setOnHomeScreen,
                callBack: () {
                  Navigator.pop(context);
                  wallpaperSettingController.setAsWallpaper(
                    imageUrl: widget.imageData.categoryImages![selectedIndex],
                    wallpaperLocation: 1,
                  );
                },
                iconData: Icons.home,
              ),
              Divider(color: AppColors.blueColor, height: 10.h, thickness: 1.h),
              buildActionButton(
                title: AppConstant.setOnLockScreen,
                callBack: () {
                  Navigator.pop(context);
                  wallpaperSettingController.setAsWallpaper(
                    imageUrl: widget.imageData.categoryImages![selectedIndex],
                    wallpaperLocation: 2,
                  );
                },
                iconData: Icons.lock_clock_rounded,
              ),
              Divider(color: AppColors.blueColor, height: 10.h, thickness: 1.h),
              buildActionButton(
                title: AppConstant.setOnBothScreen,
                callBack: () {
                  Navigator.pop(context);
                  wallpaperSettingController.setAsWallpaper(
                    imageUrl: widget.imageData.categoryImages![selectedIndex],
                    wallpaperLocation: 3,
                  );
                },
                iconData: Icons.home_work,
              ),
              Divider(color: AppColors.blueColor, height: 10.h, thickness: 1.h),
              buildActionButton(
                title: AppConstant.downloadImage,
                callBack: () {
                  adController.showRewardedAd();
                  Navigator.pop(context);
                  wallpaperSettingController.downloadImage(
                    imageUrl: widget.imageData.categoryImages![selectedIndex],
                  );
                },
                iconData: Icons.save_alt_rounded,
              ),
              Divider(color: AppColors.blueColor, height: 10.h, thickness: 1.h),
            ],
          ),
        );
      },
    );
  }

  Widget buildActionButton(
      {required String title,
      required Callback callBack,
      required IconData iconData}) {
    return GestureDetector(
      onTap: () {
        callBack();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.appBarColor.withOpacity(0.4)),
              child: Center(
                child: Icon(
                  iconData,
                  color: AppColors.bottomBarIconColor,
                  size: 20.h,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(title,
                style: TextStyle(
                    fontSize: 16.sp, color: AppColors.bottomBarButtonColor)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.bottomBarIconColor, size: 15.h),
          ],
        ),
      ),
    );
  }

  customAppBar() {
    return Container(
      height: AppSizes().appBarHeight,
      width: ScreenUtil().screenWidth,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 10.w),
          Container(
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
            child: CustomWidget.backButton(
              context: context,
              onTap: () => Navigator.pop(context),
            ),
          ),
          const Spacer(),
          CustomWidget.appBarMenuButton(
            onTap: () {
              openBottomMenu();
            },
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }
}
