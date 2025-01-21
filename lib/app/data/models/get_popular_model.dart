import 'dart:convert';

class GetPopularModel {
  final int? id;
  final String? businessName;
  final int? productCount;
  final String? phone;
  final String? backPhoto;
  final List<Image>? images;

  GetPopularModel({
    this.id,
    this.businessName,
    this.productCount,
    this.phone,
    this.backPhoto,
    this.images,
  });

  GetPopularModel copyWith({
    int? id,
    String? businessName,
    int? productCount,
    String? phone,
    String? backPhoto,
    List<Image>? images,
  }) =>
      GetPopularModel(
        id: id ?? this.id,
        businessName: businessName ?? this.businessName,
        productCount: productCount ?? this.productCount,
        phone: phone ?? this.phone,
        backPhoto: backPhoto ?? this.backPhoto,
        images: images ?? this.images,
      );

  factory GetPopularModel.fromJson(String str) =>
      GetPopularModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetPopularModel.fromMap(Map<String, dynamic> json) => GetPopularModel(
        id: json['id'],
        businessName: json['businessName'],
        productCount: json['productCount'],
        phone: json['phone'],
        backPhoto: json['back_photo'],
        images: json['images'] == null
            ? []
            : List<Image>.from(json['images']!.map((x) => Image.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'businessName': businessName,
        'productCount': productCount,
        'phone': phone,
        'back_photo': backPhoto,
        'images': images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toMap())),
      };
}

class Image {
  final String? image;

  Image({
    this.image,
  });

  Image copyWith({
    String? image,
  }) =>
      Image(
        image: image ?? this.image,
      );

  factory Image.fromJson(String str) => Image.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        image: json['image'],
      );

  Map<String, dynamic> toMap() => {
        'image': image,
      };
}
