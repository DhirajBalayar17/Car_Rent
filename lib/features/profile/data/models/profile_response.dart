import 'package:my_new/features/profile/domain/entities/profile.dart';

class ProfileResponse {
  final bool success;
  final String msg;
  final Profile profile;

  const ProfileResponse({
    required this.success,
    required this.msg,
    required this.profile,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'],
      msg: json['msg'],
      profile: Profile.fromJson(json['data']),
    );
  }
}
