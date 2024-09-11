import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/infra/services/user/user_service.dart';
import 'package:firmus/models/entity/conpany_account_entity.dart';
import 'package:firmus/models/entity/cv_video.dart';
import 'package:firmus/models/entity/location_entity.dart';
import 'package:firmus/models/entity/student_entity.dart';
import 'package:firmus/models/entity/user_entity.dart';
import 'package:firmus/models/student_experience.dart';

class HttpUserService extends UserService {
  HttpUserService({required super.httpService});

  @override
  Future<StudentAccountEntity> updateProfile(
      UpdateProfileRequest request) async {
    final Map<String, dynamic> value =
        await httpService.request(request, converter: defaultConverter);
    return StudentAccountEntity.fromMap(value["data"]);
  }

  @override
  Future<StudentAccountEntity> createProfile(
      CreateProfileRequest request) async {
    try {
      final Map<String, dynamic> value =
          await httpService.request(request, converter: defaultConverter);
      logger.info(value);
      return StudentAccountEntity.fromMap(value["data"]);
    } catch (e) {
      logger.info(
        e,
      );

      rethrow;
    }
  }

  @override
  Future<StudentAccountEntity> getProfile(GetUserRequest request) {
    return httpService.request(request, converter: (response) {
      return StudentAccountEntity.fromMap(response["data"]);
    });
  }

  @override
  Future<StudentAccountEntity> markTutorialCompleted(
      UpdateProfileRequest request) {
    return httpService.request(request, converter: (response) {
      return StudentAccountEntity.fromMap(response["data"]);
    });
  }

  @override
  Future<StudentAccountEntity> updateJobFrequency(
      UpdateJobFrequencyRequest updateJobFrequencyRequest) async {
    final sw = Stopwatch()..start();
    final resp = await httpService.request(updateJobFrequencyRequest,
        converter: (response) {
      return StudentAccountEntity.fromMap(response["data"]);
    });
    logger.info("updateJobFrequency took ${sw.elapsedMilliseconds}ms");

    return resp;
  }

  @override
  Future<bool> isRegistered(String email) async {
    try {
      return httpService.request(IsRegisteredRequest(email: email),
          converter: (response) {
        return response["data"]["isRegistered"];
      });
    } catch (e) {
      logger.info(e);
      return false;
    }
  }

  @override
  Future<LocationEntity> updateLocation(
      UpdateLocationRequest updateLocationRequest) {
    return httpService.request(updateLocationRequest, converter: (response) {
      return LocationEntity.fromMap(response["data"]);
    });
  }

  @override
  Future<StudentCVVid> uploadVideo(UploadVideoRequest request) {
    return httpService.request(request, converter: (response) {
      return StudentCVVid.fromMap(response["data"]);
    });
  }

  @override
  Future<List<StudentCVVid>> updateVideosActive(MakeVideoActive request) {
    return httpService.request(request, converter: (resp) {
      return (resp["data"] as List)
          .map((e) {
            try {
              return StudentCVVid.fromMap(e);
            } catch (e) {
              return null;
            }
          })
          .whereNotNull()
          .toList();
    });
  }

  @override
  Future<List<StudentCVVid>> deleteVideoRequest(DeleteVideoRequest request) {
    return httpService.request(request, converter: (resp) {
      return (resp["data"] as List)
          .map((e) {
            try {
              return StudentCVVid.fromMap(e);
            } catch (e) {
              return null;
            }
          })
          .whereNotNull()
          .toList();
    });
  }

  @override
  Future<String> updateBio(UpdateBioRequest updateBioRequest) {
    return httpService.request(updateBioRequest, converter: (resp) {
      return resp["data"]["bio"];
    });
  }

  @override
  Future<List<StudentExperienceEntity>> updateCV(
      UpdateCVRequest updateCVRequest) {
    return httpService.request(updateCVRequest, converter: (resp) {
      return (resp["data"] as List)
          .map((e) => StudentExperienceEntity.fromMap(e))
          .toList();
    });
  }

  @override
  Future<CompanyAccountEntity> getCompany(GetCompanyRequest request) {
    return httpService.request(request, converter: (resp) {
      return CompanyAccountEntity.fromMap(resp["data"]);
    });
  }

  RegisterTokenRequest? previous;

  @override
  Future<void> registerToken(RegisterTokenRequest request) async {
    if (previous == request) {
      return;
    }
    await httpService.request(request, converter: (resp) {});
    previous = request;
  }

  @override
  Future<UserEntity> getUser(GetUserRequest request) {
    return httpService.request(request, converter: (resp) {
      return UserEntity.fromMap(resp["data"]);
    });
  }

  @override
  Future<StudentAccountEntity> createAnonStudent() {
    return httpService.request(const CreateAnonUserRequest(),
        converter: (resp) {
      return StudentAccountEntity.fromMap(resp["data"]);
    });
  }

  @override
  Future<CompanyAccountEntity> createFakeCompany() {
    return httpService.request(const CreateFakeCompanyRequest(),
        converter: (resp) {
      return CompanyAccountEntity.fromMap(resp["data"]);
    });
  }

  @override
  Future<CompanyAccountEntity> createCompany(CreateCompanyRequest request) {
    return httpService.request(request, converter: (resp) {
      return CompanyAccountEntity.fromMap(resp["data"]);
    });
  }

  @override
  Future<Map<String, List<String>>> getUniversityList() async {
    final value = await httpService.request(const GetUniversityListRequest(),
        converter: (resp) {
      return (resp["data"] as Map<String, dynamic>).map((key, value) {
        return MapEntry(key, (value as List).cast<String>());
      });
    });
    return value;
  }

  @override
  Future<StudentCVVid> updateVideo(UpdateVideoRequest updateVideoRequest) {
    return httpService.request(updateVideoRequest, converter: (resp) {
      return StudentCVVid.fromMap(resp["data"]);
    });
  }
}

class GetUniversityListRequest extends BaseHttpRequest {
  const GetUniversityListRequest()
      : super(endpoint: "/location/university/", type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class CreateCompanyRequest extends BaseHttpRequest {
  final String email;
  final String name;

  final File logo;
  final String industryId;
  final String description;
  final String location;
  final String representative;
  final String oib;

  CreateCompanyRequest({
    required this.email,
    required this.oib,
    required this.name,
    required this.logo,
    required this.industryId,
    required this.description,
    required this.location,
    required this.representative,
  }) : super(
            endpoint: "/user/company",
            type: RequestType.post,
            contentType: Headers.multipartFormDataContentType);

  @override
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "oib": oib,
      "logo": MultipartFileRecreatable.fromFileSync(logo.path),
      "industryId": industryId,
      "description": description,
      "location": location,
      "representative": representative,
    };
  }
}

class CreateFakeCompanyRequest extends BaseHttpRequest {
  const CreateFakeCompanyRequest()
      : super(endpoint: "/user/company", type: RequestType.post);

  @override
  Map<String, dynamic> toMap() {
    return {
      "fake": true,
    };
  }
}

class IsRegisteredRequest extends BaseHttpRequest {
  final String email;

  const IsRegisteredRequest({
    required this.email,
  }) : super(endpoint: "/user/is-registered", type: RequestType.post);

  @override
  Map<String, dynamic> toMap() {
    return {
      "email": email,
    };
  }
}
