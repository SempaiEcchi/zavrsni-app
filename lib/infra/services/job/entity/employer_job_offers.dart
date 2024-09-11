import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:firmus/models/job_offers.dart';

class EmployerJobOffersResponse {
  final List<ActiveEmployerJobOffer> activeJobs;
  final List<ElapsedEmployerJobOffer> elapsedJobs;
  const EmployerJobOffersResponse({
    required this.activeJobs,
    required this.elapsedJobs,
  });

  factory EmployerJobOffersResponse.fromMap(Map<String, dynamic> map) {
    return EmployerJobOffersResponse(
      elapsedJobs: List<ElapsedEmployerJobOffer>.from(map['elapsed_jobs']
              .map((x) => ElapsedEmployerJobOffer.fromMap(x)))
          .sortedBy((e) => e.opportunity.createdAt)
          .reversed
          .toList(),
      activeJobs: List<ActiveEmployerJobOffer>.from(
              map['active_jobs'].map((x) => ActiveEmployerJobOffer.fromMap(x)))
          .sortedBy((e) => e.opportunity.createdAt)
          .reversed
          .toList(),
    );
  }

  EmployerJobOffersResponse copyWith({
    List<ActiveEmployerJobOffer>? activeJobs,
    List<ElapsedEmployerJobOffer>? elapsedJobs,
  }) {
    return EmployerJobOffersResponse(
      activeJobs: activeJobs ?? this.activeJobs,
      elapsedJobs: elapsedJobs ?? this.elapsedJobs,
    );
  }
}

abstract class EmployerJobOffer extends Equatable {
  final JobOpportunity opportunity;

  const EmployerJobOffer({
    required this.opportunity,
  });

  @override
  List<Object?> get props => [opportunity];
}

class ActiveEmployerJobOffer extends EmployerJobOffer {
  factory ActiveEmployerJobOffer.fromMap(Map<String, dynamic> map) {
    return ActiveEmployerJobOffer(
      opportunity: JobOpportunity.fromMap(map),
    );
  }

  const ActiveEmployerJobOffer({
    required super.opportunity,
  });
}

class ElapsedEmployerJobOffer extends EmployerJobOffer {
  factory ElapsedEmployerJobOffer.fromMap(Map<String, dynamic> map) {
    return ElapsedEmployerJobOffer(
      opportunity: JobOpportunity.fromMap(map),
    );
  }

  const ElapsedEmployerJobOffer({
    required super.opportunity,
  });
}
