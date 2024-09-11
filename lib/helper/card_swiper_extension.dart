import 'package:firmus/infra/services/job/job_service.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

extension ToFirmus on CardSwiperDirection {
  FirmusSwipeType get firmusActionType {
    FirmusSwipeType action = FirmusSwipeType.like;
    switch (this) {
      case CardSwiperDirection.left:
        action = FirmusSwipeType.dislike;
        break;
      case CardSwiperDirection.right:
        action = FirmusSwipeType.like;
        break;
      case CardSwiperDirection.bottom:
        action = FirmusSwipeType.save;
        break;
      default:
    }
    return action;
  }
}
