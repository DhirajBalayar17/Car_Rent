import 'package:my_new/app/constants/api_endpoints.dart';

class Profile {
  final String id;
  final String name;
  final String email;
  final String? mobileNo;
  final String? image;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    this.mobileNo,
    this.image,
  });

  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? mobileNo,
    String? image,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNo: mobileNo ?? this.mobileNo,
      image: image ?? this.image,
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      mobileNo: json['mobile_no'],
      image: json['image'] == null
          ? 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
          : '${ApiEndpoints.baseUrl}/${json['image']}',
    );
  }
}
