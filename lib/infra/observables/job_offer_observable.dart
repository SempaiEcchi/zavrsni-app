import 'package:equatable/equatable.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/view/pages/student_home/widges/view_type_selector.dart';

class JobOffersO extends Equatable {
  final JobsResponse response;
   final bool isImmersed;
  final HomeViewType viewType;
  const JobOffersO({
    required this.response,
    required this.viewType,
     required this.isImmersed,
  });

    get activeJobId => response.offers.firstOrNull?.id;

  JobOffersO copyWith({
    JobsResponse? response,
    HomeViewType? viewType,
     bool? isImmersed,
  }) {
    return JobOffersO(
      viewType: viewType ?? this.viewType,
      isImmersed: isImmersed ?? this.isImmersed,
      response: response ?? this.response,
     );
  }

  @override
  List<Object?> get props => [
        isImmersed,
        viewType,
        response,
       ];
}

// final AutoDisposeStreamProvider<SUCCESS> lastSuccessJobOffer =
//     makeStreamProvider<JobOffersO, SUCCESS>(
//   jobOfferObservableProvider,
//   filter: (JobOffersO s) {
//     return s is SUCCESS;
//   },
// );
//
// AutoDisposeStreamProvider<R> makeStreamProvider<T, R>(StateProvider provider,
//     {required bool Function(T value) filter}) {
//   return StreamProvider.autoDispose((ref) async* {
//     final observable = ref.watch(provider);
//     if (filter(observable)) {
//       yield observable as R;
//     }
//   });
// }
//
// final jobOfferObservableProvider = StateProvider<JobOffersO>(
//   (ref) => const JobOffersO.loading(),
// );
