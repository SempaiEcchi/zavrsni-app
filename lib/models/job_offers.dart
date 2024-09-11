import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:firmus/models/job_profiles.dart';
import 'package:firmus/models/job_skill.dart';
import 'package:firmus/view/pages/student_home/widges/job_tag_chip.dart';
import 'package:flutter/material.dart';

const DPOSLOVI_PHONE_NUMBER = "3850957766909";

enum JobType {
  FULL_TIME("FULL_TIME"),
  PART_TIME("PART_TIME"),
  INTERNSHIP("INTERNSHIP");

  final String name;

  const JobType(this.name);
}

extension JobTypeX on JobType {
  String get formattedName {
    switch (this) {
      case JobType.FULL_TIME:
        return "Puno radno vrijeme";
      case JobType.PART_TIME:
        return "Nepuno radno vrijeme";
      case JobType.INTERNSHIP:
        return "Praksa";
      default:
        return "";
    }
  }
}

class SimpleCompany extends Equatable {
  final String id;
  final String name;
  final double rating;
  final int openPositions;
  final String logoUrl;
  final String phoneNumber;
  final bool isGreen;

  const SimpleCompany({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.rating,
    required this.openPositions,
    required this.logoUrl,
    required this.isGreen,
  });

  factory SimpleCompany.fromMap(Map<String, dynamic> map) {
    return SimpleCompany(
      id: map['id'].toString(),
      phoneNumber: map['phone_number'] ?? DPOSLOVI_PHONE_NUMBER,
      name: map['name'] as String,
      rating: double.tryParse(map['rating'].toString()) ?? 0,
      openPositions: int.tryParse(map["open_positions"].toString()) ?? 1,
      logoUrl: map['logoUrl'] as String,
      isGreen: map['isGreen'].toString() == "true",
    );
  }

  factory SimpleCompany.dposlovi() {
    return SimpleCompany(
      id: "1",
      name: "DPoslovi",
      phoneNumber: DPOSLOVI_PHONE_NUMBER,
      rating: 4.5,
      openPositions: 1,
      logoUrl: "https://placekitten.com/200/300",
      isGreen: true,
    );
  }


  @override
  List<Object?> get props => [
        id,
        name,
        rating,
        openPositions,
        logoUrl,
        isGreen,
      ];

  static mocked() {
    return const SimpleCompany(
      id: "1",
      name: "Firmus",
      rating: 4.5,
      openPositions: 1,
      logoUrl: "https://placekitten.com/200/300",
      isGreen: true,
      phoneNumber: DPOSLOVI_PHONE_NUMBER,
    );
  }

  static fromCompany(SimpleCompany company) {
    return SimpleCompany(
      phoneNumber: company.phoneNumber,
      id: company.id,
      name: company.name,
      rating: company.rating,
      openPositions: company.openPositions,
      logoUrl: company.logoUrl,
      isGreen: company.isGreen,
    );
  }
}

class JobOpportunity extends Equatable {
  final String id;
  final String jobTitle;
  final DateTime createdAt;
  final JobProfile jobProfile;

  // final String jobImageUrl;
  final String url;
  final String? thumbnailUrl;
  final String jobDescription;
  final String shortDescription;
  final SimpleCompany company;
  final String location;
  final bool approved;
  final DateTime applyDeadline;
  final DateTime? workStartDate;
  final DateTime? workEndDate;
  final int availablePositions;
  final PaymentOption payment;
  final List<JobSkill> skills;
  final String shareLink;
  final bool isVideo;
  final JobType jobType;
  final bool acceptOnlyStudents;

  const JobOpportunity({
    required this.id,
    required this.jobProfile,
    required this.thumbnailUrl,
    required this.approved,
    required this.jobType,
    required this.isVideo,
    required this.createdAt,
    required this.payment,
    required this.acceptOnlyStudents,
    required this.skills,
    required this.shortDescription,
    required this.availablePositions,
    required this.workStartDate,
    required this.jobTitle,
    required this.url,
    required this.jobDescription,
    required this.company,
    required this.location,
    required this.applyDeadline,
    required this.shareLink,
    required this.workEndDate,
  });

  String get videoHeroTag => "${id}video$url";

  List<JobTag> get tags => [];

  String get rateText {
    return payment.rateText;
  }

  @override
  List<Object?> get props => [
        id,
        jobProfile,
        thumbnailUrl,
        approved,
        jobType,
        workEndDate,
        isVideo,
        acceptOnlyStudents,
        shareLink,
        skills,
        jobTitle,
        url,
        jobDescription,
        shortDescription,
        company,
        location,
        applyDeadline,
        createdAt,
        workStartDate,
        availablePositions,
        payment,
      ];

  factory JobOpportunity.fromMap(Map<String, dynamic> map,
      [SimpleCompany? company]) {

    return JobOpportunity(
      jobProfile: JobProfile.fromMap(map["jobProfile"]),
      thumbnailUrl: map['thumbnailUrl'] as String?,
      approved: map['approved'].toString() == "true",
      isVideo: map['isVideo'].toString() == "true",
      url: map['url'] as String,
      createdAt: DateTime.parse(map["created_at"]),
      jobType: JobType.values.byName(map["jobType"].toString()),
      acceptOnlyStudents: map['acceptOnlyStudents'].toString() == "true",
      skills: map["skills"] == null
          ? []
          : (map['skills'] as List).map((e) => JobSkill.fromMap(e)).toList(),
      shareLink: map['shareLink'] ?? "https://dposlovi.com",
      payment: PaymentOption.fromMap(map['payment']),
      id: map['id'].toString(),
      jobTitle: map['jobTitle'] as String,
      jobDescription: map['jobDescription'] as String,
      shortDescription: map['shortDescription'] ?? "",
      company: company ?? (map["company"]==null?SimpleCompany.dposlovi():SimpleCompany.fromMap(map["company"])),
      location: map["location_name"]??"Pula",
      applyDeadline: DateTime.parse(map["applyDeadline"]),
      workStartDate: DateTime.tryParse(map['workStartDate'].toString()),
      workEndDate: DateTime.tryParse(map['workEndDate'].toString()),
      availablePositions: int.tryParse(map["employeesNeeded"].toString()) ?? 1,
    );
  }




  int get daysLeft {
    final now = DateTime.now();
    final diff = applyDeadline.difference(now);
    return max(diff.inDays, 0);
  }

  String get formattedApllicationDeadline {
    return "${applyDeadline.day}.${applyDeadline.month}.${applyDeadline.year}.";
  }

  Color? get applicationDeadlineColor {
    //null if deadline is at least 5 days awar
    //orange if deadline is at least 2 days away
    //red if deadline is less than 2 days away

    final now = DateTime.now();
    final diff = daysLeft;

    if (diff >= 5) {
      return null;
    } else if (diff >= 2) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}


String constructUniqueVideoUri(String videoUrl, String id) {
  final uri = Uri.parse(videoUrl);
  return uri.replace(queryParameters: {
    ...uri.queryParameters,
    "id": id}).toString();
}



enum PaymentOptionType {
  HOURLY,
  FIXED,
  MONTHLY,
}

class PaymentOption extends Equatable {
  final PaymentOptionType type;
  final double amount;
  final String currency;

  const PaymentOption(
      {required this.type, required this.amount, this.currency = 'EUR'});

  factory PaymentOption.fromMap(Map<String, dynamic> map) {
    return PaymentOption(
      type: _mapStringToPaymentOptionType(map['type']),
      amount: double.parse(map['amount'].toString()),
      currency: map['currency'] ?? 'EUR',
    );
  }

  @override
  List<Object?> get props => [type, amount, currency];

  String get rateText {
    if (type == PaymentOptionType.HOURLY) {
      return "${amount.toStringAsFixed(2)}€/sat";
    }
    return "${amount.toInt()}€/mj";
  }

  static PaymentOptionType _mapStringToPaymentOptionType(String type) {
    switch (type) {
      case 'HOURLY':
        return PaymentOptionType.HOURLY;
      case 'FIXED':
        return PaymentOptionType.FIXED;
      case 'MONTHLY':
        return PaymentOptionType.MONTHLY;
      default:
        throw Exception('Invalid PaymentOptionType: $type');
    }
  }
}
