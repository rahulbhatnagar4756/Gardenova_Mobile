import 'package:get/get.dart';
import 'package:kasagardem/authentication/chooseAccountType/choose_account_type_screen.dart';
import 'package:kasagardem/authentication/forgotPassword/forgot_password.dart';
import 'package:kasagardem/authentication/forgotPassword/forgot_password_view_model.dart';
import 'package:kasagardem/authentication/forgotPassword/reset_password.dart';
import 'package:kasagardem/authentication/forgotPassword/verify_otp.dart';
import 'package:kasagardem/authentication/login/login_screen.dart';
import 'package:kasagardem/authentication/login/login_view_model.dart';
import 'package:kasagardem/authentication/register/register_screen.dart';
import 'package:kasagardem/authentication/register/register_view_model.dart';
import 'package:kasagardem/base/widgets/coming_soon.dart';
import 'package:kasagardem/dashboard/dashboard_controller.dart';
import 'package:kasagardem/dashboard/dashboard_screen.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plant_detail/plant_detail_screen.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plant_detail/plant_detail_view_model.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plants_catalog/plants_catalog_screen.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plants_catalog/plants_catalog_view_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_screen.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_view_model.dart';
import 'package:kasagardem/introduction/introduction_screen.dart';
import 'package:kasagardem/introduction/introduction_screen_view_model.dart';
import 'package:kasagardem/introduction/question/components/report_success_screen.dart';
import 'package:kasagardem/introduction/question/question_screen.dart';
import 'package:kasagardem/introduction/question/question_view_model.dart';
import 'package:kasagardem/plants/allPlants/allPlantsDetails/all_plants_details_controller.dart';
import 'package:kasagardem/plants/allPlants/allPlantsList/all_plants_list_screen.dart';
import 'package:kasagardem/professional/myLead/lead_details_screen.dart';
import 'package:kasagardem/professional/myLead/my_lead_controller.dart';
import 'package:kasagardem/professional/myLead/my_lead_screen.dart';
import 'package:kasagardem/professional/orderSummary/order_summary_screen.dart';
import 'package:kasagardem/professional/professionalDashBoard/professional_dashboard_controller.dart';
import 'package:kasagardem/professional/professionalDashBoard/professional_dashboard_screen.dart';
import 'package:kasagardem/recommended_professionals/components/request_quote_success.dart';
import 'package:kasagardem/recommended_professionals/recommended_professionals.dart';
import 'package:kasagardem/recommended_professionals/recommended_professionals_view_model.dart';
import 'package:kasagardem/settings/change_password.dart';
import 'package:kasagardem/settings/privacy_policy.dart';
import 'package:kasagardem/settings/profile/profile_screen.dart';
import 'package:kasagardem/settings/settings_screen.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/settings/terms_and_conditions.dart';
import 'package:kasagardem/splash_screen.dart';

import '../plants/allPlants/allPlantsDetails/all_plants_details_screen.dart';
import '../plants/allPlants/allPlantsList/all_plants_controller.dart';
import '../plants/myPlants/myPlantDetails/my_plant_details_controller.dart';
import '../plants/myPlants/myPlantDetails/my_plant_details_screen.dart';
import '../plants/myPlants/myPlantsList/my_plants_controller.dart';
import '../plants/myPlants/myPlantsList/my_plants_screen.dart';
import '../professional/professionalDashBoard/components/create_professional_lead_request_screen.dart';
import '../professional/professionalDashBoard/components/professional_dashbord_success_quote.dart';
import '../professional/upgradePlans/upgrade_plan_controller.dart';
import '../professional/upgradePlans/upgrade_plan_screen.dart';
import '../recommended_professionals/components/create_request_screen.dart';

class Routes {
  static const splash = '/';
  static const introduction = '/introduction';
  static const dashboard = '/dashboard';
  static const login = '/login';
  static const signUp = '/sign_up';
  static const forgotPassword = '/forgot_password';
  static const verifyOtp = '/verify_otp';
  static const resetPassword = '/reset_password';
  static const question = '/question';
  static const reportSuccess = '/report_success';
  static const settings = '/settings';
  static const profile = '/profile';
  static const changePassword = '/change_password';
  static const termsAndConditions = '/term_and_conditions';
  static const recommendedProfessionals = '/recommended_professionals';
  static const privacyPolicy = '/privacy_policy';
  static const requestQuoteSuccess = '/request_quote_success';
  static const professionalDashboardSuccessQuote =
      '/professional_dashboard_success_quote';
  static const referAFriend = '/refer_friend';
  static const plantDetail = '/plant_detail';
  static const plantsCatalog = '/plants_catalog';
  static const plantDiagnosis = '/plant_diagnosis';
  static const allPlantsScreen = '/all_plants';
  static const allPlantsDetails = '/all_plants_details';
  static const myPlantsScreen = '/my_plants';
  static const myPlantsDetails = '/my_plant_details';
  static const chooseAccountType = '/choose_account_type';
  static const upgradePlan = '/upgrade_plan';
  static const orderSummary = '/order_summary';
  static const professionalDashboard = '/professional_dashboard';
  static const myLeadScreen = '/my_lead_screen';
  static const chatScreen = '/chat_screen';
  static const leadDetailsScreen = '/lead_details_screen';
  static const createRequestScreen = '/create_request_screen';
  static const createProfessionalLeadRequestScreen = '/create_professional_request_screen';

  static getPages() {
    return [
      GetPage(name: Routes.splash, page: () => const SplashScreen()),
      GetPage(
        name: Routes.introduction,
        page: () => IntroductionScreen(),
        binding: BindingsBuilder.put(() => IntroductionScreenViewModel()),
      ),
      GetPage(
        name: Routes.dashboard,
        page: () => DashboardScreen(),
        binding: BindingsBuilder.put(() => DashboardController()),
      ),
      GetPage(
        name: Routes.login,
        page: () => LoginScreen(),
        binding: BindingsBuilder.put(() => LoginViewModel()),
      ),
      GetPage(
        name: Routes.signUp,
        page: () => RegisterScreen(),
        binding: BindingsBuilder.put(() => RegisterViewModel()),
      ),
      GetPage(
        name: Routes.forgotPassword,
        page: () => ForgotPassword(),
        binding: BindingsBuilder.put(() => ForgotPasswordViewModel()),
      ),
      GetPage(name: Routes.verifyOtp, page: () => VerifyOtp()),
      GetPage(name: Routes.resetPassword, page: () => ResetPassword()),
      GetPage(
        name: Routes.question,
        page: () => QuestionScreen(),
        binding: BindingsBuilder.put(() => QuestionViewModel()),
      ),
      GetPage(name: Routes.reportSuccess, page: () => ReportSuccessScreen()),
      GetPage(
        name: Routes.settings,
        page: () => SettingsScreen(),
        binding: BindingsBuilder.put(() => SettingsViewModel()),
      ),
      GetPage(name: Routes.profile, page: () => ProfileScreen()),
      GetPage(
        name: Routes.changePassword,
        page: () => ChangePassword(),
        binding: BindingsBuilder.put(() => SettingsViewModel()),
      ),
      GetPage(
        name: Routes.recommendedProfessionals,
        page: () => RecommendedProfessionals(),
        binding: BindingsBuilder.put(() => RecommendedProfessionalsViewModel()),
      ),

      GetPage(
        name: Routes.requestQuoteSuccess,
        page: () => RequestQuoteSuccess(),
      ),
      GetPage(
        name: Routes.professionalDashboardSuccessQuote,
        page: () => ProfessionalDashboardSuccessQuote(),
      ),
      GetPage(
        name: Routes.privacyPolicy,
        page: () =>
            PrivacyPolicyScreen(filePath: 'assets/html/privacy_policy_pt.html'),
      ),
      GetPage(
        name: Routes.termsAndConditions,
        page: () => TermsAndConditions(
          filePath: 'assets/html/terms_and_conditions_pt.html',
        ),
      ),
      GetPage(name: Routes.referAFriend, page: () => ComingSoon()),

      GetPage(
        name: Routes.plantDetail,
        page: () => PlantDetailScreen(),
        binding: BindingsBuilder.put(() => PlantDetailViewModel()),
      ),
      GetPage(
        name: Routes.plantsCatalog,
        page: () => PlantsCatalogScreen(),
        binding: BindingsBuilder.put(() => PlantsCatalogViewModel()),
      ),
      GetPage(
        name: Routes.plantDiagnosis,
        page: () => PlantDiagnosisScreen(),
        binding: BindingsBuilder.put(() => PlantDiagnosisViewModel()),
      ),

      /// new
      GetPage(
        name: Routes.allPlantsScreen,
        page: () => AllPlantsListScreen(),
        binding: BindingsBuilder.put(() => AllPlantsController()),
      ),

      GetPage(
        name: Routes.allPlantsDetails,
        page: () => AllPlantsDetailsScreen(),
        binding: BindingsBuilder.put(() => AllPlantsDetailsController()),
      ),

      GetPage(
        name: Routes.myPlantsScreen,
        page: () => MyPlantsScreen(),
        binding: BindingsBuilder.put(() => MyPlantsController()),
      ),

      GetPage(
        name: Routes.myPlantsDetails,
        page: () => MyPlantDetailsScreen(),
        binding: BindingsBuilder.put(() => MyPlantDetailsController()),
      ),

      GetPage(
        name: Routes.chooseAccountType,
        page: () => ChooseAccountTypeScreen(),
      ),

      GetPage(
        name: Routes.upgradePlan,
        page: () => UpgradePlanScreen(),
        binding: BindingsBuilder.put(() => UpgradePlanController()),
      ),

      GetPage(
        name: Routes.orderSummary,
        page: () => OrderSummaryScreen(),
        binding: BindingsBuilder.put(() => UpgradePlanController()),
      ),

      GetPage(
        name: Routes.professionalDashboard,
        page: () => ProfessionalDashboardScreen(),
        binding: BindingsBuilder.put(() => ProfessionalDashboardController()),
      ),

      GetPage(
        name: Routes.myLeadScreen,
        page: () => MyLeadScreen(),
        binding: BindingsBuilder.put(() => MyLeadController()),
      ),
      GetPage(

        name: Routes.createRequestScreen,
        page: () => CreateRequestScreen(),

      ),
      GetPage(
        name: Routes.createProfessionalLeadRequestScreen,
        page: () => CreateProfessionalLeadRequestScreen(),

      ),

      GetPage(name: Routes.leadDetailsScreen, page: () => LeadDetailsScreen()),
    ];
  }
}
