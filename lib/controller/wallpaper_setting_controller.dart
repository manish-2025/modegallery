import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:mode_gallery/utils/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_handler/wallpaper_handler.dart';

class WallpaperSettingController extends GetxController {
  bool isLoading = false;
  String loadingText = "Loading";

  setAsWallpaper({
    required String imageUrl,
    required int wallpaperLocation,
  }) async {
    setLoadingState(state: true, text: "Setting Wallpaper");

    try {
      final Dio dio = Dio();
      final String url = imageUrl; // Example image URL
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/downloaded_image.jpg';
      print("object = wallpaperLocation ${wallpaperLocation}");
      await dio.download(url, filePath);
      bool result = await WallpaperHandler.instance.setWallpaperFromFile(
        filePath,
        wallpaperLocation == 1
            ? WallpaperLocation.homeScreen
            : WallpaperLocation == 2
                ? WallpaperLocation.lockScreen
                : WallpaperLocation.bothScreens,
      );

      print("object => Set => $result");

      setLoadingState(state: false, text: "Setting Wallpaper");
    } on PlatformException {
      setLoadingState(state: false, text: "Setting Wallpaper");
    }
    update();
  }

  downloadImage({required String imageUrl}) async {
    setLoadingState(state: true, text: 'Downloading Image');
    var response = await Dio().get(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );
    final result = await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(response.data),
        quality: 90,
        name: "PM_${DateTime.now().millisecondsSinceEpoch}");
    if (result['isSuccess'] == true) {
      Fluttertoast.showToast(
        msg: "Image Downloaded Successfully",
        backgroundColor: AppColors.greenColor,
        textColor: AppColors.whiteColor,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Something Went Wrong, Please Try Again!",
        backgroundColor: AppColors.appBarColor,
        textColor: AppColors.whiteColor,
      );
    }
    setLoadingState(state: false, text: '');
    update();
  }

  void setLoadingState({required bool state, required String text}) {
    isLoading = state;
    loadingText = text;
    update();
  }
}
