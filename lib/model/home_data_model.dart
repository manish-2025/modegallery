class HomeDataModel {
  List<ImageData>? imageData;

  HomeDataModel({this.imageData});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    if (json['imageData'] != null) {
      imageData = <ImageData>[];
      json['imageData'].forEach((v) {
        imageData!.add(ImageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (imageData != null) {
      data['imageData'] = imageData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageData {
  int? categoryId;
  String? categoryTitle;
  List<String>? categoryImages;

  ImageData({this.categoryId, this.categoryTitle, this.categoryImages});

  ImageData.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryTitle = json['category_title'];
    categoryImages = json['category_images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category_title'] = categoryTitle;
    data['category_images'] = categoryImages;
    return data;
  }
}
