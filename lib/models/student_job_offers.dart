import 'package:firmus/models/job_offers.dart';

sealed class StudentJobOffer {
  final JobOpportunity opportunity;

  StudentJobOffer(this.opportunity);
}

class AppliedJobOffer extends StudentJobOffer {
  final bool isRejected;

  AppliedJobOffer(
    JobOpportunity opportunity,
    this.isRejected,
  ) : super(opportunity);

  factory AppliedJobOffer.fromMap(Map<String, dynamic> map) {
    return AppliedJobOffer(
      JobOpportunity.fromMap(map),
      map['is_rejected'].toString() == 'true',
    );
  }
}

class SavedJobOffer extends StudentJobOffer {
  SavedJobOffer(JobOpportunity opportunity) : super(opportunity);

  factory SavedJobOffer.fromMap(Map<String, dynamic> map) {
    return SavedJobOffer(
      JobOpportunity.fromMap(map),
    );
  }
}

class MatchedJobOffer extends StudentJobOffer {
  final String matchId;
  final bool isRejected;

  MatchedJobOffer(JobOpportunity opportunity, this.matchId, this.isRejected)
      : super(opportunity);

  factory MatchedJobOffer.fromMap(Map<String, dynamic> map) {
    return MatchedJobOffer(
      JobOpportunity.fromMap(map),
      map['match_id'].toString(),
      map['is_rejected'].toString() == 'true',
    );
  }
}

class ActiveJobOffer extends StudentJobOffer {
  final DateTime? completionDate;
  final DateTime startedDate;

  factory ActiveJobOffer.fromMap(Map<String, dynamic> map) {
    return ActiveJobOffer(
      JobOpportunity.fromMap(map),
      startedDate: DateTime.parse(map['started_date'].toString()),
      completionDate: map['completion_date'] != null
          ? DateTime.tryParse(map['completion_date'].toString())
          : null,
    );
  }

  ActiveJobOffer(JobOpportunity opportunity,
      {this.completionDate, required this.startedDate})
      : super(opportunity);
}

class CompletedJobOffer extends StudentJobOffer {
  CompletedJobOffer(JobOpportunity opportunity) : super(opportunity);

  factory CompletedJobOffer.fromMap(Map<String, dynamic> map) {
    return CompletedJobOffer(
      JobOpportunity.fromMap(map),
    );
  }
}
