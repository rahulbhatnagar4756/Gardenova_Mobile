import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

class SubscriptionNavigation {
  SubscriptionNavigation._();

  static bool get isProfessional =>
      SharedPrefsService.instance.getString(AppKeys.role) == AppKeys.professional;

  static String get upgradeRoute =>
      isProfessional ? Routes.upgradePlan : Routes.userSubscription;
}
