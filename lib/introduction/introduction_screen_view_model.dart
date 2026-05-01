import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:kasagardem/introduction/introduction_model.dart';
import 'package:kasagardem/introduction/introduction_repository.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

class IntroductionScreenViewModel extends GetxController {
  RxInt currentIndex = 0.obs;
  int introductionLastScreenIndex = 2;
  RxBool isUserLoggedIn = false.obs;
  List<IntroductionModel> introductionList = [];
  SharedPrefsService? sharedPrefsService;
  CarouselSliderController buttonCarouselController =
      CarouselSliderController();
  late IntroductionRepository introductionRepository;

  @override
  Future<void> onInit() async {
    sharedPrefsService = SharedPrefsService();
    introductionRepository = IntroductionRepository();
    introductionList = introductionRepository.fetchIntroductionList(
      AppLocalizations.of(Get.context!)!,
    );
    await sharedPrefsService!.init();
    isUserLoggedIn.value =
        sharedPrefsService!.getBool(AppKeys.isLoggedIn) ?? false;
    super.onInit();
  }
}
