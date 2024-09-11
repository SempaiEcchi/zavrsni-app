import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/infra/services/user/http_user_service.dart';
import 'package:firmus/models/entity/cv_video.dart';
import 'package:firmus/models/entity/student_entity.dart';
import 'package:firmus/models/entity/user_entity.dart';
import 'package:firmus/models/job_profiles.dart';
import 'package:firmus/models/student_experience.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../models/entity/conpany_account_entity.dart';
import '../../../models/entity/location_entity.dart';

final userServiceProvider = Provider<UserService>((ref) => HttpUserService(
      httpService: ref.watch(httpServiceProvider),
    ));

abstract class UserService {
  final HttpService httpService;

  Future<CompanyAccountEntity> getCompany(GetCompanyRequest request);

  @Deprecated("Use getUser instead")
  Future<StudentAccountEntity> getProfile(GetUserRequest request);

  Future<UserEntity> getUser(GetUserRequest request);

  Future<StudentAccountEntity> updateProfile(UpdateProfileRequest request);

  Future<StudentAccountEntity> createProfile(CreateProfileRequest request);

  Future<StudentAccountEntity> markTutorialCompleted(
      UpdateProfileRequest request);

  Future<StudentAccountEntity> updateJobFrequency(
      UpdateJobFrequencyRequest updateJobFrequencyRequest);

  Future<LocationEntity> updateLocation(
      UpdateLocationRequest updateLocationRequest);

  Future<bool> isRegistered(String email);

  Future<String> updateBio(UpdateBioRequest updateBioRequest);

  Future<StudentCVVid> uploadVideo(UploadVideoRequest request);

  Future<List<StudentCVVid>> deleteVideoRequest(DeleteVideoRequest request);

  Future<List<StudentExperienceEntity>> updateCV(
      UpdateCVRequest updateCVRequest);

  Future<StudentAccountEntity> createAnonStudent();

  Future<void> registerToken(RegisterTokenRequest request);

  const UserService({
    required this.httpService,
  });

  Future<CompanyAccountEntity> createFakeCompany();

  Future<CompanyAccountEntity> createCompany(CreateCompanyRequest request);

  Future<Map<String, List<String>>> getUniversityList();

  Future<StudentCVVid> updateVideo(UpdateVideoRequest updateVideoRequest);
}

class CreateAnonUserRequest extends BaseHttpRequest {
  const CreateAnonUserRequest()
      : super(endpoint: "/user/student", type: RequestType.post);

  @override
  Map<String, dynamic> toMap() {
    return {
      "anon": true,
    };
  }
}

class RegisterTokenRequest extends BaseHttpRequest {
  final String token;
  final bool delete;

  const RegisterTokenRequest({
    required this.token,
    required this.delete,
  }) : super(
            endpoint: "/user/notifications",
            type: delete ? RequestType.delete : RequestType.patch);

  @override
  Map<String, dynamic> toMap() {
    return {
      "token": token,
    };
  }
}

class GetCompanyRequest extends BaseHttpRequest {
  final String id;

  const GetCompanyRequest({
    required this.id,
  }) : super(endpoint: "/user/company/$id", type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class UpdateCVRequest extends BaseHttpRequest {
  final CreateCV cv;

  const UpdateCVRequest({
    required this.cv,
  }) : super(endpoint: "/user/student/cv", type: RequestType.post);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...cv.toMap(),
    };
  }
}

class MakeVideoActive extends BaseHttpRequest {
  final String id;

  const MakeVideoActive({
    required this.id,
  }) : super(endpoint: "/user/student/video", type: RequestType.patch);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }
}

class DeleteVideoRequest extends BaseHttpRequest {
  final String id;

  const DeleteVideoRequest({
    required this.id,
  }) : super(endpoint: "/user/student/video/delete", type: RequestType.post);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }
}

class UploadVideoRequest extends BaseHttpRequest {
  final File video;
  final File thumbnail;
  final List<int> selectedJobProfiles;

  UploadVideoRequest({
    required this.video,
    required this.thumbnail,
    required this.selectedJobProfiles,
  }) : super(
            endpoint: "/user/student/video",
            type: RequestType.post,
            contentType: Headers.multipartFormDataContentType);

  @override
  FutureOr<Map<String, dynamic>> toMap() async {
    return {
      "job_profiles": selectedJobProfiles,
      "video": MultipartFileRecreatable.fromFileSync(video.path),
      "thumbnail": MultipartFileRecreatable.fromFileSync(thumbnail.path)
    };
  }
}

class UpdateVideoRequest extends BaseHttpRequest {
  final String id;
  final List<int> selectedJobProfiles;

  UpdateVideoRequest({
    required this.id,
    required this.selectedJobProfiles,
  }) : super(endpoint: "/user/student/video/$id", type: RequestType.patch);

  @override
  Map<String, dynamic> toMap() {
    return {
      "job_profiles": selectedJobProfiles,
    };
  }
}

class GetUserRequest extends BaseHttpRequest {
  final String userId;

  const GetUserRequest({
    required this.userId,
  }) : super(endpoint: "/user/$userId", type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class MarkTutorialCompletedRequest extends BaseHttpRequest {
  final String userId;

  const MarkTutorialCompletedRequest({
    required this.userId,
  }) : super(endpoint: "/user/student/$userId", type: RequestType.patch);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class UniversityInfo {
  final String uniName;
  final String uniYear;

  const UniversityInfo({
    required this.uniName,
    required this.uniYear,
  });

  Map<String, dynamic> toMap() {
    return {
      'uni_name': uniName,
      'uni_year': uniYear,
    };
  }

  factory UniversityInfo.fromMap(Map<String, dynamic> map) {
    return UniversityInfo(
      uniName: map['uni_name'] as String,
      uniYear: map['uni_year'] as String,
    );
  }
}

class CreateProfileRequest extends BaseHttpRequest {
  final String first_name;
  final String last_name;
  final String city;
  final String email;
  final UniversityInfo? universityInfo;
  final File image;
  final List<SelectedJobProfile> selectedJobProfiles;
  final CreateCV cv;
  final DateTime dateOfBirth;

  const CreateProfileRequest({
    required this.first_name,
    required this.last_name,
    required this.cv,
    required this.city,
    required this.email,
    required this.image,
    required this.dateOfBirth,
    this.universityInfo,
    required this.selectedJobProfiles,
  }) : super(
            endpoint: "/user/student",
            type: RequestType.post,
            contentType: Headers.multipartFormDataContentType);

  @override
  Map<String, dynamic> toMap() {
    return {
      "university_info": universityInfo?.toMap(),
      "first_name": first_name,
      "last_name": last_name,
      "date_of_birth": dateOfBirth.toIso8601String(),
      "city": city,
      "email": email,
      "profile_picture": MultipartFileRecreatable.fromFileSync(image.path),
      "cv": cv.toMap(),
      "job_profiles": selectedJobProfiles.map((e) => e.toMap()).toList(),
    };
  }
}

class UpdateProfileRequest extends BaseHttpRequest {
  final String userId;
  final String? first_name;
  final String? last_name;
  final String? gender;
  final File? image;

  final bool? tutorial_completed;
  final String? phone_number;
  final String? email_contact;
  final DateTime? date_of_birth;

  const UpdateProfileRequest({
    required this.userId,
    this.first_name,
    this.last_name,
    this.image,
    this.gender,
    this.tutorial_completed,
    this.phone_number,
    this.email_contact,
    this.date_of_birth,
  }) : super(
          endpoint: "/user/student/$userId",
          type: RequestType.patch,
          contentType: Headers.multipartFormDataContentType,);

  @override
  Map<String, dynamic> toMap() {
    final map = {
      if (phone_number != null) "phone_number": phone_number,
      if (email_contact != null) "email_contact": email_contact,
      if (tutorial_completed != null) "tutorial_completed": tutorial_completed,
      if (first_name != null) "first_name": first_name,
      if (last_name != null) "last_name": last_name,
      if (gender != null) "gender": gender,
      if (image != null)
        "image": MultipartFileRecreatable.fromFileSync(image!.path),
      if (date_of_birth != null)
        "date_of_birth": date_of_birth!.toIso8601String(),
    };
    debugPrint(map.toString());
    return map;
  }

  factory UpdateProfileRequest.fromMap(
      Map<String, dynamic> map, String userId) {
    return UpdateProfileRequest(
        userId: userId,
        image: map["image"] is File ? map["image"] as File : null,
        date_of_birth: map["date_of_birth"],
        phone_number: map["phone_number"] as String?,
        email_contact: map["email_contact"] as String?,
        first_name: map["first_name"] as String?,
        last_name: map["last_name"] as String?,
        gender: map["gender"] as String?);
  }
}

class UpdateBioRequest extends BaseHttpRequest {
  final String bio;

  UpdateBioRequest({
    required this.bio,
  }) : super(endpoint: "/user/student/bio", type: RequestType.post);

  @override
  Map<String, dynamic> toMap() {
    return {
      "bio": bio,
    };
  }
}

class UpdateLocationRequest extends BaseHttpRequest {
  final LatLng location;
  final String locationName;

  UpdateLocationRequest({
    required this.location,
    required this.locationName,
  }) : super(endpoint: "/user/location", type: RequestType.post);

  @override
  Map<String, dynamic> toMap() {
    return {
      "location_name": locationName,
      "lat": location.latitude,
      "lng": location.longitude,
    };
  }
}

// class LocalUserService extends UserService {
//   LocalUserService({required super.httpService});
//
//   @override
//   Future<void> register(String email) async {}
//
//   @override
//   Future<void> updateProfile() async {}
//
//   @override
//   Future<void> createProfile(CreateProfileRequest request) async {
//     final db = Localstore.instance;
//     final id = db.collection('users').doc().id;
//     db.collection('users').doc(id).set(request.toMap());
//   }
//
//   @override
//   Future<StudentObservable> getProfile(GetUserRequest request) {
//     // TODO: implement getProfile
//     throw UnimplementedError();
//   }
// }
