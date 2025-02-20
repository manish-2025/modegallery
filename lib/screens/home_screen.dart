import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mode_gallery/common/app_constants.dart';
import 'package:mode_gallery/controller/ad_controller/ad_controller.dart';
import 'package:mode_gallery/controller/home_screen_controller.dart';
import 'package:mode_gallery/screens/full_screen_image_view_screen.dart';
import 'package:mode_gallery/screens/image_slider_viewer.dart';
import 'package:mode_gallery/utils/app_colors.dart';
import 'package:mode_gallery/utils/custom_widgets/custom_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? currentBackPressTime;
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  AdController adController = Get.put(AdController());
  ScrollController? controller;
  bool interShown = false;

  BannerAd? _bannerAd;
  bool _isLoaded = false;

  NativeAd? nativeAd;
  NativeAd? dialogNativeAd;
  bool _nativeAdIsLoaded = false;
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

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
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
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

  void loadDialogNativeAd() {
    dialogNativeAd = NativeAd(
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

  /// Loads a banner ad.
  void loadAd() {
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

  @override
  void initState() {
    homeScreenController.getHomeData(pageNum: 0);
    adController.createRewardedAd();

    ///TODO load interestrial ad
    // adController.createInterstitialAd();
    // adController.createRewardedInterstitialAd();
    adController.createBannerAd();
    loadAd();
    loadNativeAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.whiteColor),
          backgroundColor: AppColors.appBarColor,
          title: Text(
            AppConstant.homeScreenTitle,
            style: TextStyle(
                color: AppColors.appBarTitleColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
        drawer: Drawer(
          backgroundColor: AppColors.appBarColor,
          child: buildDrawer(),
        ),
        backgroundColor: AppColors.appBarColor,
        body: buildBody(context),
        floatingActionButton: floatingButton(),
        // floatingActionButton: GetBuilder<AdController>(
        //   builder: (newAdController){
        //     return newAdController.rewardedAd!=null? floatingButton():SizedBox();
        //   }
        //   ),
      ),
    );
  }

  Widget floatingButton() {
    return GestureDetector(
      onTap: () {
        // loadDialogNativeAd();
        // _showAlertDialog();
        adController.showRewardedAd();
        // adController.showInterstitialAd();
        // adController.showRewardedInterstitialAd();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blueColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.red),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Watch Ads",
            style: TextStyle(color: AppColors.whiteColor),
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return GetBuilder<AdController>(builder: (newAdController) {
      // if(newAdController.interstitialAd!=null && interShown==false){
      //   newAdController.showInterstitialAd();
      //   interShown = true;
      // }
      return Stack(
        children: [
          GetBuilder<HomeScreenController>(builder: (context) {
            return Container(
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              // padding: EdgeInsets.only(top: AppSizes().appBarHeight),
              decoration: BoxDecoration(
                  color: AppColors.appBackgroundColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.whiteColor,
                      AppColors.blackColor,
                    ],
                  )),
              child: buildImageDataList(),
            );
          }),
          // CustomWidget.customAppBar(
          //   title: AppConstant.homeScreenTitle,
          //   actionButtons: [],
          // ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: getBannerAd(),
          ),
        ],
      );
    });
  }

  Widget buildImageDataList() {
    return Container(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: homeScreenController.homeDataList.length,
        separatorBuilder: (context, index) {
          if (index == 0 && _nativeAdIsLoaded == true) {
            return ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 320, // minimum recommended width
                minHeight: 90, // minimum recommended height
                maxWidth: 400,
                maxHeight: 260,
              ),
              child: AdWidget(ad: nativeAd!),
            );
          } else {
            return const SizedBox();
          }
        },
        itemBuilder: (context, index) {
          var data = homeScreenController.homeDataList[index];
          return Container(
            padding: index == 0 ? EdgeInsets.only(top: 15.h) : EdgeInsets.zero,
            width: ScreenUtil().screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(data.categoryTitle!,
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "poppins")),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          if (adController.interstitialAd != null) {
                            adController.showInterstitialAd();
                          }
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ImageSliderViewer(imageData: data)))
                              .then((value) {
                            loadAd();
                          });
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                              color: AppColors.blueColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
                SizedBox(
                  height: 170.h,
                  width: ScreenUtil().screenWidth,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.categoryImages!.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 10.w);
                    },
                    itemBuilder: (context, index) {
                      var imageData = data.categoryImages?[index];
                      return GestureDetector(
                        onTap: () {
                          ///TODO show interestrial ad
                          // if(adController.interstitialAd!=null){
                          //   adController.showInterstitialAd();
                          // }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageViewScreen(
                                imageData: data,
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 120.h,
                          child: CustomWidget.imageBuilder(
                            url: imageData!,
                            circularImage: true,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getBannerAd() {
    if (_isLoaded == true) {
      print("object = ==");
      return Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Future<void> showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          // title: const Text('Watch Ads'),
          // actions: <Widget>[
          //   TextButton(
          //     child: const Text('No'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          //   TextButton(
          //     child: const Text('Yes'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //       },
          //   ),
          //  ],
          content: Container(
            height: 150,
            width: 400,
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 400,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  buildDrawer() {
    return Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: AppColors.appBarColor,
          ),
          child: Column(
            children: [
              Container(
                height: 100,
                width: 300,
                child: CustomWidget.imageBuilder(
                    url: "assets/1024.png", circularImage: true),
              ),
              Text(AppConstant.appName,
                  style: TextStyle(
                      color: AppColors.appBarTitleColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        drawerMenuWidget(
            title: 'About Us',
            onTap: () {},
            leading: Icon(Icons.person, color: AppColors.appBackgroundColor)),
        Divider(
          height: 0.1,
          thickness: 1,
          color: AppColors.appBackgroundColor,
        ),
        drawerMenuWidget(
          title: 'Privacy Policy',
          onTap: () {},
          leading: Icon(Icons.privacy_tip, color: AppColors.appBackgroundColor),
        ),
        Divider(
          height: 0.1,
          thickness: 1,
          color: AppColors.appBackgroundColor,
        ),
        drawerMenuWidget(
          title: 'FeedBack',
          onTap: () {},
          leading: Icon(Icons.feedback, color: AppColors.appBackgroundColor),
        ),
        Divider(
          height: 0.1,
          thickness: 1,
          color: AppColors.appBackgroundColor,
        ),
        drawerMenuWidget(
          title: 'Rate Us',
          onTap: () {},
          leading: Icon(Icons.star, color: AppColors.appBackgroundColor),
        ),
        Divider(
          height: 0.1,
          thickness: 1,
          color: AppColors.appBackgroundColor,
        ),
        drawerMenuWidget(
          title: 'Share App',
          onTap: () {},
          leading: Icon(Icons.share, color: AppColors.appBackgroundColor),
        ),
        Divider(
          height: 0.1,
          thickness: 1,
          color: AppColors.appBackgroundColor,
        ),
        drawerMenuWidget(
          title: 'More Apps',
          onTap: () {},
          leading: Icon(Icons.more, color: AppColors.appBackgroundColor),
        ),
        Divider(
          height: 0.1,
          thickness: 1,
          color: AppColors.appBackgroundColor,
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 20.w,
            ),
            Text(
              "App Version : 0.0.1",
              style: TextStyle(color: AppColors.appBackgroundColor),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Widget drawerMenuWidget({
    required String title,
    required Widget leading,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: TextStyle(color: AppColors.appBackgroundColor),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 20,
        color: AppColors.appBackgroundColor,
      ),
      onTap: onTap,
    );
  }
}
