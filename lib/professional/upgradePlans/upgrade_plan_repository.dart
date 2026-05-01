import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../utils/network_services/api_repository.dart';
import 'model/plan_model.dart';

class UpgradePlanRepository {
  // final String getPlanUrl = 'api/v1/subscription';
  final String getPlanUrl = 'api/v1/subscription/subscription-plans';
  RxInt remainingDays = 0.obs;
  RxList<PlanModel> planList = <PlanModel>[].obs;

  getPlanList() async {
    var planResponse = await ApiRepository.instance.get(getPlanUrl);
    return planResponse;
  }
}
