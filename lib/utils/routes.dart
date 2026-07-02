import 'package:get/get.dart';
import 'package:kasagardem/authentication/chooseAccountType/choose_account_type_screen.dart';
import 'package:kasagardem/authentication/forgotPassword/forgot_password.dart';
import 'package:kasagardem/authentication/forgotPassword/forgot_password_view_model.dart';
import 'package:kasagardem/authentication/forgotPassword/reset_password.dart';
import 'package:kasagardem/authentication/forgotPassword/verify_otp.dart';
import 'package:kasagardem/authentication/login/login_screen.dart';
import 'package:kasagardem/authentication/login/login_verify_otp_screen.dart';
import 'package:kasagardem/authentication/login/login_view_model.dart';
import 'package:kasagardem/authentication/register/register_screen.dart';
import 'package:kasagardem/authentication/register/register_verify_otp_screen.dart';
import 'package:kasagardem/authentication/register/register_view_model.dart';
import 'package:kasagardem/base/widgets/coming_soon.dart';
import 'package:kasagardem/dashboard/dashboard_controller.dart';
import 'package:kasagardem/dashboard/dashboard_screen.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plant_detail/plant_detail_screen.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plant_detail/plant_detail_view_model.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plants_catalog/plants_catalog_screen.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plants_catalog/plants_catalog_view_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/camera_capture_screen.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_screen.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_view_model.dart';
import 'package:kasagardem/introduction/question/components/report_success_screen.dart';
import 'package:kasagardem/introduction/question/question_screen.dart';
import 'package:kasagardem/introduction/question/question_view_model.dart';
import 'package:kasagardem/landscape_design/landscape_design_screen.dart';
import 'package:kasagardem/landscape_design/landscape_design_view_model.dart';
import 'package:kasagardem/plants/allPlants/add_plants_list/add_plant_list_screen.dart';
import 'package:kasagardem/plants/allPlants/allPlantsDetails/all_plants_details_controller.dart';
import 'package:kasagardem/professional/myLead/lead_details_screen.dart';
import 'package:kasagardem/professional/myLead/my_lead_controller.dart';
import 'package:kasagardem/professional/myLead/my_lead_screen.dart';
import 'package:kasagardem/professional/orderSummary/order_summary_screen.dart';
import 'package:kasagardem/professional/professionalDashBoard/professional_dashboard_controller.dart';
import 'package:kasagardem/professional/professionalDashBoard/professional_dashboard_screen.dart';
import 'package:kasagardem/recommended_professionals/components/request_quote_success.dart';
import 'package:kasagardem/recommended_professionals/recommended_professionals.dart';
import 'package:kasagardem/recommended_professionals/recommended_professionals_view_model.dart';
import 'package:kasagardem/reminders/plant_reminder_controller.dart';
import 'package:kasagardem/reminders/plant_reminder_list_screen.dart';
import 'package:kasagardem/settings/about_app.dart';
import 'package:kasagardem/settings/change_password.dart';
import 'package:kasagardem/settings/privacy_policy.dart';
import 'package:kasagardem/settings/profile/edit_profile_screen.dart';
import 'package:kasagardem/settings/profile/profile_screen.dart';
import 'package:kasagardem/settings/profile/verified_email_otp_view/verify_email_otp_screen.dart';
import 'package:kasagardem/settings/settings_screen.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/settings/terms_and_conditions.dart';
import 'package:kasagardem/splash_screen.dart';
import 'package:kasagardem/utils/utils.dart';

import '../introduction/introduction_screen.dart';
import '../introduction/introduction_screen_view_model.dart';
import '../plants/allPlants/add_plants_list/add_plants_controller.dart';
import '../plants/allPlants/allPlantsDetails/all_plants_details_screen.dart';
import '../plants/myPlants/myPlantDetails/my_plant_details_controller.dart';
import '../plants/myPlants/myPlantDetails/my_plant_details_screen.dart';
import '../plants/myPlants/myPlantsList/my_plants_controller.dart';
import '../plants/myPlants/myPlantsList/my_plants_screen.dart';
import '../professional/professionalDashBoard/components/create_professional_lead_request_screen.dart';
import '../professional/professionalDashBoard/components/professional_dashbord_success_quote.dart';
import '../professional/payment/razorpay_payment_controller.dart';
import '../professional/payment/razorpay_payment_screen.dart';
import '../professional/upgradePlans/upgrade_plan_controller.dart';
import '../professional/upgradePlans/upgrade_plan_screen.dart';
import '../subscription/user_order_summary_screen.dart';
import '../subscription/user_subscription_controller.dart';
import '../subscription/user_subscription_screen.dart';
import '../recommended_professionals/components/create_request_screen.dart';
import '../settings/profile/verified_email_otp_view/verified_email_otp_view_model.dart';

class Routes {
  static const splash = '/';
  static const introduction = '/introduction';
  static const dashboard = '/dashboard';
  static const login = '/login';
  static const loginVerifyOtp = '/login_verify_otp';
  static const registerVerifyOtp = '/register_verify_otp';
  static const signUp = '/sign_up';
  static const forgotPassword = '/forgot_password';
  static const verifyOtp = '/verify_otp';
  static const verifyEmailOtp = '/verify_email_otp';
  static const resetPassword = '/reset_password';
  static const question = '/question';
  static const reportSuccess = '/report_success';
  static const settings = '/settings';
  static const profile = '/profile';
  static const editProfile = '/edit_profile';
  static const changePassword = '/change_password';
  static const termsAndConditions = '/term_and_conditions';
  static const recommendedProfessionals = '/recommended_professionals';
  static const privacyPolicy = '/privacy_policy';
  static const aboutApp = '/about_app';
  static const requestQuoteSuccess = '/request_quote_success';
  static const professionalDashboardSuccessQuote = '/professional_dashboard_success_quote';
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
  static const userSubscription = '/user_subscription';
  static const userOrderSummary = '/user_order_summary';
  static const razorpayPayment = '/razorpay_payment';
  static const professionalDashboard = '/professional_dashboard';
  static const myLeadScreen = '/my_lead_screen';
  static const chatScreen = '/chat_screen';
  static const leadDetailsScreen = '/lead_details_screen';
  static const createRequestScreen = '/create_request_screen';
  static const createProfessionalLeadRequestScreen = '/create_professional_request_screen';
  static const landscapeDesign = '/landscape_design';
  static const cameraCapture = '/camera_capture';
  static const plantRemindersListing = '/plant_reminders_listing';

  static List<GetPage> getPages() {
    return [
      GetPage(
        name: Routes.splash,
        page: () => const SplashScreen(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.introduction,
        page: () => IntroductionScreen(),
        binding: BindingsBuilder.put(() => IntroductionScreenViewModel()),
        // page: () => LoginScreen(),
        // binding: BindingsBuilder.put(() => LoginViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.login,
        page: () => LoginScreen(),
        binding: BindingsBuilder.put(() => LoginViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.loginVerifyOtp,
        page: () => const LoginVerifyOtpScreen(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.dashboard,
        page: () => DashboardScreen(),
        binding: BindingsBuilder(() {
          Get.put(DashboardController());
          Get.put(SettingsViewModel());
        }),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.signUp,
        page: () => RegisterScreen(),
        binding: BindingsBuilder.put(() => RegisterViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.registerVerifyOtp,
        page: () => const RegisterVerifyOtpScreen(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.forgotPassword,
        page: () => ForgotPassword(),
        binding: BindingsBuilder.put(() => ForgotPasswordViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.verifyOtp,
        page: () => VerifyOtp(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.resetPassword,
        page: () => ResetPassword(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.question,
        page: () => QuestionScreen(),
        binding: BindingsBuilder.put(() => QuestionViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.reportSuccess,
        page: () => ReportSuccessScreen(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.settings,
        page: () => SettingsScreen(),
        binding: BindingsBuilder.put(() => SettingsViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.profile,
        page: () => const ProfileScreen(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.editProfile,
        page: () => const EditProfileScreen(),
        binding: BindingsBuilder.put(() => SettingsViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.verifyEmailOtp,
        page: () => const VerifyEmailOtpScreen(),
        binding: BindingsBuilder.put(() => VerifiedEmailOtpViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.changePassword,
        page: () => ChangePassword(),
        binding: BindingsBuilder.put(() => SettingsViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.recommendedProfessionals,
        page: () => RecommendedProfessionals(),
        binding: BindingsBuilder.put(() => RecommendedProfessionalsViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.requestQuoteSuccess,
        page: () => RequestQuoteSuccess(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.professionalDashboardSuccessQuote,
        page: () => ProfessionalDashboardSuccessQuote(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.privacyPolicy,
        page: () => PrivacyPolicyScreen(filePath: 'assets/html/privacy_policy_en.html'),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.aboutApp,
        page: () => AboutAppScreen(filePath: 'assets/html/about_en.html'),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.termsAndConditions,
        page: () => TermsAndConditions(filePath: 'assets/html/terms_and_conditions_en.html'),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.referAFriend,
        page: () => ComingSoon(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.plantDetail,
        page: () => PlantDetailScreen(),
        binding: BindingsBuilder.put(() => PlantDetailViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.plantsCatalog,
        page: () => PlantsCatalogScreen(),
        binding: BindingsBuilder.put(() => PlantsCatalogViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.plantDiagnosis,
        page: () => PlantDiagnosisScreen(),
        binding: BindingsBuilder.put(() => PlantDiagnosisViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      /// new
      GetPage(
        name: Routes.allPlantsScreen,
        page: () => AllPlantsListScreen(),
        binding: BindingsBuilder.put(() => AllPlantsController()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.allPlantsDetails,
        page: () => AllPlantsDetailsScreen(),
        binding: BindingsBuilder.put(() => AllPlantsDetailsController()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.myPlantsScreen,
        page: () => MyPlantsScreen(),
        binding: BindingsBuilder.put(() => MyPlantsController()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.myPlantsDetails,
        page: () => MyPlantDetailsScreen(),
        binding: BindingsBuilder.put(() => MyPlantDetailsController()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.chooseAccountType,
        page: () => ChooseAccountTypeScreen(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.upgradePlan,
        page: () => UpgradePlanScreen(),
        binding: BindingsBuilder.put(() => UpgradePlanController()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.orderSummary,
        page: () => OrderSummaryScreen(),
        binding: BindingsBuilder.put(() => UpgradePlanController()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.userSubscription,
        page: () => const UserSubscriptionScreen(),
        binding: BindingsBuilder.put(() => UserSubscriptionController()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.userOrderSummary,
        page: () => const UserOrderSummaryScreen(),
        binding: BindingsBuilder.put(() => UserSubscriptionController()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.razorpayPayment,
        page: () => const RazorpayPaymentScreen(),
        binding: BindingsBuilder.put(() => RazorpayPaymentController()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.professionalDashboard,
        page: () => ProfessionalDashboardScreen(),
        binding: BindingsBuilder.put(() => ProfessionalDashboardController()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.myLeadScreen,
        page: () => MyLeadScreen(),
        binding: BindingsBuilder.put(() => MyLeadController()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.createRequestScreen,
        page: () => CreateRequestScreen(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.createProfessionalLeadRequestScreen,
        page: () => CreateProfessionalLeadRequestScreen(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),

      GetPage(
        name: Routes.leadDetailsScreen,
        page: () => LeadDetailsScreen(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.landscapeDesign,
        page: () => const LandscapeDesignScreen(),
        binding: BindingsBuilder.put(() => LandscapeDesignViewModel()),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.cameraCapture,
        page: () => const CameraCaptureScreen(),
        transition: Utils.transition,
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
      GetPage(
        name: Routes.plantRemindersListing,
        page: () => PlantReminderListScreen(),
        transition: Utils.transition,
        binding: BindingsBuilder.put(() => PlantReminderController()),
        transitionDuration: const Duration(milliseconds: Utils.transitionDuration),
      ),
    ];
  }
}
