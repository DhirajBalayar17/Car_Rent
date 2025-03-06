import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_new/features/profile/data/models/update_profile_request.dart';
import 'package:my_new/features/profile/domain/usecases/fetch_profile.dart';
import 'package:my_new/features/profile/domain/usecases/update_profile.dart';
import 'package:my_new/features/profile/domain/usecases/update_profile_picture.dart';

import '../../domain/entities/profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FetchProfile fetchProfile;
  final UpdateProfilePicture updateProfilePicture;
  final UpdateProfile updateProfile;
  ProfileCubit(this.fetchProfile, this.updateProfilePicture, this.updateProfile)
      : super(ProfileLoading());

  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> getProfile() async {
    final res = await fetchProfile();

    res.fold(
      (l) => emit(ProfileError(l.message)),
      (r) {
        nameController.text = r.name;
        emailController.text = r.email;
        if (r.mobileNo != null) phoneController.text = r.mobileNo!;

        emit(ProfileLoaded(r));
      },
    );
  }

  Future<void> updateProfilePic(File image) async {
    final res = await updateProfilePicture(image);
    res.fold(
      (l) => emit(ProfileError(l.message)),
      (r) => getProfile(),
    );
  }

  Future<void> updateProfileInfo(BuildContext context) async {
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;

    if (!formKey.currentState!.validate()) return;

    final res = await updateProfile(UpdateProfileRequest(
      userId: currentState.profile.id,
      name: nameController.text,
      email: emailController.text,
      mobileNo: phoneController.text,
    ));
    res.fold(
      (l) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.message))),
      (r) {
        getProfile();
        Navigator.of(context).pop();
      },
    );
  }
}
