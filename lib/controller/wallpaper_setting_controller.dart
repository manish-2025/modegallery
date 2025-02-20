
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:mode_gallery/utils/app_colors.dart';

class WallpaperSettingController extends GetxController{

  bool isLoading = false;
  String loadingText = "Loading";

  setAsWallpaper({required String imageUrl, required int wallpaperLocation}) async {
    setLoadingState(state: true, text: "Setting Wallpaper");
    // String result;
    try {
      // result = 
      await AsyncWallpaper.setWallpaper(
        url: imageUrl,
        wallpaperLocation: wallpaperLocation,
        goToHome: false,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
      setLoadingState(state: false, text: "Setting Wallpaper");
    } on PlatformException {
      // result = 'Failed to get wallpaper.';
      setLoadingState(state: false, text: "Setting Wallpaper");
    }
    update();
  }

  downloadImage({required String imageUrl}) async {
    setLoadingState(state: true, text: 'Downloading Image');
    GallerySaver.saveImage(imageUrl).then((bool? success) {
      if(success == true){
        Fluttertoast.showToast(
          msg: "Image Downloaded Successfully",
          backgroundColor: AppColors.greenColor,
          textColor: AppColors.whiteColor,
        );
      }else{
        Fluttertoast.showToast(
          msg: "Something Went Wrong, Please Try Again!",
          backgroundColor: AppColors.appBarColor,
          textColor: AppColors.whiteColor,
        );
      }

    });
    setLoadingState(state: false, text: 'Downloading Image');
    update();
  }

  void setLoadingState({required bool state, required String text}) {
    isLoading = state;
    loadingText = text;
    update();
  }
}