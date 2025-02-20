import 'dart:io';
import 'dart:ui';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mode_gallery/common/app_constants.dart';
import 'package:mode_gallery/controller/wallpaper_setting_controller.dart';
import 'package:mode_gallery/model/home_data_model.dart';
import 'package:mode_gallery/utils/app_colors.dart';
import 'package:mode_gallery/utils/app_sizes.dart';
import 'package:mode_gallery/utils/custom_widgets/custom_widget.dart';

class FullScreenImageViewScreen extends StatefulWidget {
  final ImageData imageData;
  final int index;

  const FullScreenImageViewScreen(
      {super.key, required this.imageData, required this.index});

  @override
  State<FullScreenImageViewScreen> createState() =>
      _FullScreenImageViewScreenState();
}

class _FullScreenImageViewScreenState extends State<FullScreenImageViewScreen> {
  WallpaperSettingController wallpaperSettingController =
      Get.put(WallpaperSettingController());
  int selectedIndex = 10;
  PageController? controller;

  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  RewardedAd? rewardedAd;
  int numRewardedLoadAttempts = 0;
  int maxFailedLoadAttempts = 2;
  bool rewardEarned = false;
  int settingNum = 0;

  BannerAd? _bannerAd;
  bool _isLoaded = false;

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  String _adUnitId = "ca-app-pub-3940256099942544/2247696110";

  /// Loads a banner ad.
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          print("object = ==");
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    )..load();
  }

  /// Loads a native ad.
  void loadNativeAd() {
    _nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.small,
            // Optional: Customize the ad's style.
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
    selectedIndex = widget.index;
    controller = PageController(initialPage: selectedIndex);
    createRewardedAd();
    loadBannerAd();
    loadNativeAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.appBarTitleColor,
            )),
        title: Text(
          widget.imageData.categoryTitle ?? '',
          style: TextStyle(color: AppColors.appBarTitleColor),
        ),
        backgroundColor: AppColors.appBarColor,
      ),
      body: buildBody(context),
    ));
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        buildImageWidget(),
        // customAppBar(),
        // Positioned(
        //   left: 0,
        //   right: 0,
        //   bottom: 0,
        //   child: Visibility(
        //     visible: _isLoaded == true && _bannerAd!=null,
        //     child: Container(
        //       height: _bannerAd!.size.height.toDouble(),
        //       width: _bannerAd!.size.width.toDouble(),
        //       color: AppColors.transparentColor,
        //       child: AdWidget(ad: _bannerAd!),
        //     ),
        //   ),
        // ),
        GetBuilder<WallpaperSettingController>(builder: (context) {
          return Visibility(
            visible: wallpaperSettingController.isLoading,
            child: Container(
              color: AppColors.transparentColor,
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              child: Center(
                child: CustomWidget.loadingWidget(
                    loadingText: wallpaperSettingController.loadingText),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget customAppBar() {
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
          Container(
            height: 30.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: AppColors.appBarColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                widget.imageData.categoryTitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.appBarTitleColor, fontSize: 20.sp),
              ),
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

  Widget buildImageWidget() {
    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),
        Visibility(
          visible: _isLoaded == true && _bannerAd != null,
          child: Container(
            height: _bannerAd!.size.height.toDouble(),
            width: _bannerAd!.size.width.toDouble(),
            color: AppColors.transparentColor,
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Expanded(
          child: PageView.builder(
            allowImplicitScrolling: true,
            itemCount: widget.imageData.categoryImages?.length,
            controller: controller,
            itemBuilder: (BuildContext context, int itemIndex) {
              return GestureDetector(
                  onTap: () {
                    selectedIndex = itemIndex;
                  },
                  child: buildCarouselItem(context, itemIndex));
            },
            onPageChanged: (index) {
              selectedIndex = index;
            },
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Visibility(
          visible: _nativeAdIsLoaded && _nativeAd != null,
          child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              height: 80.h,
              color: AppColors.appBarColor,
              child: AdWidget(ad: _nativeAd!)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomWidget.button(
                context: context,
                actionTitle: "Set \nWallpaper",
                onTap: () {
                  openBottomMenu();
                },
                height: 40.h,
                width: 100.w),
            CustomWidget.button(
                context: context,
                actionTitle: "Preview",
                onTap: () {
                  openPreview();
                },
                height: 40.h,
                width: 100.w),
            CustomWidget.button(
                context: context,
                actionTitle: "Download \nImage",
                onTap: () {
                  openBottomMenu();
                },
                height: 40.h,
                width: 100.w),
          ],
        ),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }

  void openBottomMenu() {
    showModalBottomSheet<void>(
      backgroundColor: AppColors.transparentColor,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.only(top: 10.h),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            AppColors.gradientColor3,
            AppColors.gradientColor1,
          ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
              SizedBox(height: 5.h),
              Divider(color: AppColors.blueColor, height: 5.h, thickness: 1.h),
              buildActionButton(
                title: AppConstant.setOnHomeScreen,
                callBack: () {
                  Navigator.pop(context);
                  if (rewardedAd != null) {
                    showRewardedAd(id: AsyncWallpaper.HOME_SCREEN);
                  } else {
                    setWallpaper(wallPaperLocation: AsyncWallpaper.HOME_SCREEN);
                  }
                },
                iconData: Icons.home,
              ),
              Divider(color: AppColors.blueColor, height: 5.h, thickness: 1.h),
              buildActionButton(
                title: AppConstant.setOnLockScreen,
                callBack: () {
                  Navigator.pop(context);
                  if (rewardedAd != null) {
                    showRewardedAd(id: AsyncWallpaper.LOCK_SCREEN);
                  } else {
                    setWallpaper(wallPaperLocation: AsyncWallpaper.LOCK_SCREEN);
                  }
                },
                iconData: Icons.lock_clock_rounded,
              ),
              Divider(color: AppColors.blueColor, height: 5.h, thickness: 1.h),
              buildActionButton(
                title: AppConstant.setOnBothScreen,
                callBack: () {
                  Navigator.pop(context);
                  if (rewardedAd != null) {
                    showRewardedAd(id: AsyncWallpaper.BOTH_SCREENS);
                  } else {
                    setWallpaper(
                        wallPaperLocation: AsyncWallpaper.BOTH_SCREENS);
                  }
                },
                iconData: Icons.home_work,
              ),
              Divider(color: AppColors.blueColor, height: 5.h, thickness: 1.h),
              buildActionButton(
                title: AppConstant.downloadImage,
                callBack: () {
                  Navigator.pop(context);
                  CustomWidget.watchAdPopupWidget(
                      context: context,
                      showAd: () {
                        if (rewardedAd != null) {
                          showRewardedAd(id: 10);
                        } else {
                          downloadImage();
                        }
                      });
                },
                iconData: Icons.save_alt_rounded,
              ),
              Divider(color: AppColors.blueColor, height: 5.h, thickness: 1.h),
              SizedBox(height: 10.h),
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
      child: Container(
        color: AppColors.transparentColor,
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

  Widget buildCarouselItem(BuildContext context, int itemIndex) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: CustomWidget.imageBuilder(
          url: widget.imageData.categoryImages![itemIndex],
          circularImage: false),
    );
  }

  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5224354917'
            : 'ca-app-pub-3940256099942544/1712485313',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded. createRewardedAd');
            rewardedAd = ad;
            numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            rewardedAd = null;
            numRewardedLoadAttempts += 1;
            if (numRewardedLoadAttempts < maxFailedLoadAttempts) {
              createRewardedAd();
            }
          },
        ));
  }

  void showRewardedAd({required int id}) {
    if (rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        print('ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        Navigator.pop(context);
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
    );

    rewardedAd!.setImmersiveMode(true);
    rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      print("=================== object ad closed ====================");
      if (id == 10) {
        downloadImage();
      } else {
        setWallpaper(wallPaperLocation: id);
      }
      if (reward.amount > 1) {
        rewardEarned = true;
        setState(() {});
      }
    });
    rewardedAd = null;
  }

  void downloadImage() {
    wallpaperSettingController.downloadImage(
      imageUrl: widget.imageData.categoryImages![selectedIndex],
    );
  }

  void setWallpaper({required int wallPaperLocation}) {
    wallpaperSettingController.setAsWallpaper(
        imageUrl: widget.imageData.categoryImages![selectedIndex],
        wallpaperLocation: wallPaperLocation);
  }

  void openPreview() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          imageUrl: widget.imageData.categoryImages![selectedIndex],
        );
      },
    );
  }
}

class Dialog extends StatelessWidget {
  final String imageUrl;

  const Dialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomWidget.imageBuilder(
                  url: imageUrl, circularImage: false),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                child: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                  size: 40,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
