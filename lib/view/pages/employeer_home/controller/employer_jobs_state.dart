import 'package:equatable/equatable.dart';
import 'package:firmus/infra/services/job/entity/employer_job_offers.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';

class EmployerJobsState extends Equatable {
  final EmployerJobOffersResponse employerJobOffersResponse;

  const EmployerJobsState({
    required this.employerJobOffersResponse,
  });

  @override
  List<Object?> get props => [employerJobOffersResponse];

  EmployerJobsState copyWith({
    EmployerJobOffersResponse? employerJobOffersResponse,
  }) {
    return EmployerJobsState(
      employerJobOffersResponse:
          employerJobOffersResponse ?? this.employerJobOffersResponse,
    );
  }
}

class EmployerJobDetailState extends Equatable {
  final EmployerJobOffer jobOpportunity;
  final JobOfferDetailsResponse jobOfferDetailsResponse;

  const EmployerJobDetailState({
    required this.jobOpportunity,
    required this.jobOfferDetailsResponse,
  });

  @override
  List<Object?> get props => [jobOpportunity, jobOfferDetailsResponse];
}
