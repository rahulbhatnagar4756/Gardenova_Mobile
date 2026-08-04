import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../utils/network_services/api_repository.dart';
import 'model/plan_model.dart';

class UpgradePlanRepository {
  // Commented — plans now come from Google Play Billing / App Store.
  // final String getPlanUrl = 'api/v1/subscription';
  // final String getPlanUrl = 'api/v1/plans/getplans';
  RxInt remainingDays = 0.obs;
  RxList<PlanModel> planList = <PlanModel>[].obs;

  // Commented — use SubscriptionService.buildPlansFromStore() instead.
  // getPlanList() async {
  //   var planResponse = await ApiRepository.instance.get(getPlanUrl);
  //   return planResponse;
  // }

  /// POST api/v1/plans/subscriptions/verify
  /// Body: purchaseToken, productId/product_id, planId/plan_id, orderId
  verifyPurchase(Map<String, dynamic> body) async {
    var verifyResponse = await ApiRepository.instance.post(
      'api/v1/plans/subscriptions/verify',
      body: body,
      showDefaultLoader: false,
      showRunTimeError: false,
    );
    return verifyResponse;
  }
}