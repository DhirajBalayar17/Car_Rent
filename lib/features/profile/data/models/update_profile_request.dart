class UpdateProfileRequest {
  final String userId;
  final String name;
  final String mobileNo;
  final String email;

  UpdateProfileRequest({
    required this.userId,
    required this.name,
    required this.mobileNo,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile_no': mobileNo,
      'email': email,
    };
  }
}
