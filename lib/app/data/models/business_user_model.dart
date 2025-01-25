class BusinessUserModel {
  final int id;
  final String businessName;
  final String businessPhone;
  final String backPhoto;
  final String description;
  final String? address;
  final String? tiktok;
  final String? instagram;
  final String? youtube;
  final String? website;
  final String? status;
  final String created;
  final List<String>? images;

  final int title;
  final int user;
  final int? productCount;

  BusinessUserModel({
    required this.id,
    required this.backPhoto,
    required this.description,
    required this.businessName,
    required this.businessPhone,
    required this.created,
    required this.title,
    required this.user,
    this.address,
    this.productCount,
    this.status,
    this.images,
    this.tiktok,
    this.instagram,
    this.youtube,
    this.website,
  });

  factory BusinessUserModel.fromJson(Map<String, dynamic> json) {
    return BusinessUserModel(
      id: json['id'] as int? ?? 0,
      productCount: json['productCount'] as int? ?? 0,
      backPhoto: json['back_photo'] as String? ?? '',
      description: json['description'] as String? ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? 'pending',
      tiktok: json['tiktok'] ?? '',
      instagram: json['instagram  '] as String?,
      youtube: json['youtube'] as String?,
      website: json['website'] as String?,
      created: json['created'] as String? ?? '',
      businessName: json['businessName'] as String? ?? '',
      businessPhone: json['businessPhone'] as String? ?? json['phone'],
      title: json['title'] as int? ?? 0,
      user: json['user'] as int? ?? 0,
      images: (json['images'] as List<dynamic>?)?.map((image) => image['image'] as String).toList() ?? [], // Empty list if null
    );
  }
}
