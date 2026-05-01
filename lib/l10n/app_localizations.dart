import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @careTitle.
  ///
  /// In en, this message translates to:
  /// **'Care For Your Plants Intelligently'**
  String get careTitle;

  /// No description provided for @careDescription.
  ///
  /// In en, this message translates to:
  /// **'Give your plants smart care with perfect hydration, nutrition, and growth using this app.'**
  String get careDescription;

  /// No description provided for @identifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Identify Plants Instantly'**
  String get identifyTitle;

  /// No description provided for @identifyDescription.
  ///
  /// In en, this message translates to:
  /// **'Quickly recognize any plant and learn detailed information about it in just seconds.'**
  String get identifyDescription;

  /// No description provided for @connectTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect With Other Gardeners'**
  String get connectTitle;

  /// No description provided for @connectDescription.
  ///
  /// In en, this message translates to:
  /// **'Join a vibrant community of plant lovers to share tips, stories, advice, and grow together.'**
  String get connectDescription;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAccountSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Create An Account To Explore Our App'**
  String get createAccountSubTitle;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourPhoneNo.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone no'**
  String get enterYourPhoneNo;

  /// No description provided for @pleaseEnterValidPhoneNo.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid phone no.'**
  String get pleaseEnterValidPhoneNo;

  /// No description provided for @pleaseEnterValidEmailId.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid emailId'**
  String get pleaseEnterValidEmailId;

  /// No description provided for @iHaveAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'I have agree to'**
  String get iHaveAgreeTo;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'privacy policy'**
  String get privacyPolicy;

  /// No description provided for @orRegisterWith.
  ///
  /// In en, this message translates to:
  /// **'Or Register With'**
  String get orRegisterWith;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @logInNow.
  ///
  /// In en, this message translates to:
  /// **'LogIn Now'**
  String get logInNow;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'LogIn'**
  String get login;

  /// No description provided for @loginAccount.
  ///
  /// In en, this message translates to:
  /// **'Login Account'**
  String get loginAccount;

  /// No description provided for @loginAccountSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Login An Account To Explore Our App'**
  String get loginAccountSubTitle;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or Login With'**
  String get orLoginWith;

  /// No description provided for @forgotPasswordNew.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordNew;

  /// No description provided for @forgotPasswordSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your Email Below To Reset\nYour Password.'**
  String get forgotPasswordSubTitle;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send Otp'**
  String get sendOtp;

  /// No description provided for @enterYourOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Otp'**
  String get enterYourOtp;

  /// No description provided for @checkYourEmailOrPhoneForTheOTPAndEnterItBelow.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email Or Phone For The\nOTP And Enter It Below'**
  String get checkYourEmailOrPhoneForTheOTPAndEnterItBelow;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify Otp'**
  String get verifyOtp;

  /// No description provided for @didNotReceiveAnyCode.
  ///
  /// In en, this message translates to:
  /// **'Didn’t Receive Any Code?'**
  String get didNotReceiveAnyCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createPassword;

  /// No description provided for @setAStrongPasswordToSecureYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Set A Strong Password To Secure Your Account.'**
  String get setAStrongPasswordToSecureYourAccount;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back To Login'**
  String get backToLogin;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password Changed'**
  String get passwordChanged;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your Password Has Been Changed Successfully.'**
  String get passwordChangedSuccessfully;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @createYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Create your password'**
  String get createYourPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;
  String get currentPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @noUserFound.
  ///
  /// In en, this message translates to:
  /// **'No user found !!'**
  String get noUserFound;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed'**
  String get googleSignInFailed;

  /// No description provided for @validate.
  ///
  /// In en, this message translates to:
  /// **'Validate!'**
  String get validate;

  /// No description provided for @wrongPasswordEntered.
  ///
  /// In en, this message translates to:
  /// **'Wrong password entered'**
  String get wrongPasswordEntered;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full Name'**
  String get enterYourFullName;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Enter your answer'**
  String get enterYourAnswer;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @yourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your Answer'**
  String get yourAnswer;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @invalidDataEntered.
  ///
  /// In en, this message translates to:
  /// **'Invalid Data Entered'**
  String get invalidDataEntered;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @smartAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Smart Analysis'**
  String get smartAnalysis;

  /// No description provided for @smartAnalysisDesc.
  ///
  /// In en, this message translates to:
  /// **'Our AI Analyzes Your Needs to Provide\nTailored Solutions'**
  String get smartAnalysisDesc;

  /// No description provided for @productRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Product Recommendations'**
  String get productRecommendations;

  /// No description provided for @productRecommendationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover the Best Products for Your\nSpecific Space'**
  String get productRecommendationsDesc;

  /// No description provided for @professionalConnections.
  ///
  /// In en, this message translates to:
  /// **'Professional Connections'**
  String get professionalConnections;

  /// No description provided for @professionalConnectionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect With Vetted Professionals\nin Your Area'**
  String get professionalConnectionsDesc;

  /// No description provided for @startIntelligentDiagnosisDesc.
  ///
  /// In en, this message translates to:
  /// **'Answer a Few Questions About Your Space and Preferences to Receive Personalized Recommendations For Your Garden Transformation.'**
  String get startIntelligentDiagnosisDesc;

  /// No description provided for @startIntelligentDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Start Intelligent Diagnosis'**
  String get startIntelligentDiagnosis;

  /// No description provided for @startDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'START DIAGNOSIS'**
  String get startDiagnosis;

  /// No description provided for @questionOne.
  ///
  /// In en, this message translates to:
  /// **'Which Space Do You Want to Transform?'**
  String get questionOne;

  /// No description provided for @questionTwo.
  ///
  /// In en, this message translates to:
  /// **'What Is the Approximate\nArea?'**
  String get questionTwo;

  /// No description provided for @questionThree.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Biggest\nChallenge?'**
  String get questionThree;

  /// No description provided for @questionFour.
  ///
  /// In en, this message translates to:
  /// **'Which Technology Benefit\nFor Your Garden Interests\nYou Most?'**
  String get questionFour;

  /// No description provided for @questionFive.
  ///
  /// In en, this message translates to:
  /// **'Where Is Your Project\nLocated?'**
  String get questionFive;

  /// No description provided for @homeGarden.
  ///
  /// In en, this message translates to:
  /// **'Home Garden'**
  String get homeGarden;

  /// No description provided for @apartmentBalcony.
  ///
  /// In en, this message translates to:
  /// **'Apartment\nBalcony'**
  String get apartmentBalcony;

  /// No description provided for @corporateOutdoorArea.
  ///
  /// In en, this message translates to:
  /// **'Corporate\n Outdoor Area'**
  String get corporateOutdoorArea;

  /// No description provided for @intimate.
  ///
  /// In en, this message translates to:
  /// **'Intimate'**
  String get intimate;

  /// No description provided for @ample.
  ///
  /// In en, this message translates to:
  /// **'Ample'**
  String get ample;

  /// No description provided for @extensive.
  ///
  /// In en, this message translates to:
  /// **'Extensive'**
  String get extensive;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @aesthetics.
  ///
  /// In en, this message translates to:
  /// **'Aesthetics'**
  String get aesthetics;

  /// No description provided for @knowledge.
  ///
  /// In en, this message translates to:
  /// **'Knowledge'**
  String get knowledge;

  /// No description provided for @waterSavings.
  ///
  /// In en, this message translates to:
  /// **'Water Savings'**
  String get waterSavings;

  /// No description provided for @remoteControl.
  ///
  /// In en, this message translates to:
  /// **'Remote Control'**
  String get remoteControl;

  /// No description provided for @smartLighting.
  ///
  /// In en, this message translates to:
  /// **'Smart Lighting'**
  String get smartLighting;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get selectState;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @yourIntelligentDiagnosisReportIsReady.
  ///
  /// In en, this message translates to:
  /// **'Your Intelligent Diagnosis\nReport Is Ready!'**
  String get yourIntelligentDiagnosisReportIsReady;

  /// No description provided for @viewReport.
  ///
  /// In en, this message translates to:
  /// **'View Report'**
  String get viewReport;

  /// No description provided for @pleaseSelectCity.
  ///
  /// In en, this message translates to:
  /// **'Please Select City'**
  String get pleaseSelectCity;

  /// No description provided for @pleaseSelectState.
  ///
  /// In en, this message translates to:
  /// **'Please Select State'**
  String get pleaseSelectState;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @loginOrRegisterToContinue.
  ///
  /// In en, this message translates to:
  /// **'Login or Register to continue'**
  String get loginOrRegisterToContinue;

  /// No description provided for @passwordCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty!'**
  String get passwordCannotBeEmpty;

  /// No description provided for @pleaseEnterValidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid name'**
  String get pleaseEnterValidName;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changeToPortugese.
  ///
  /// In en, this message translates to:
  /// **'Change To Portugese'**
  String get changeToPortugese;

  /// No description provided for @termsAndCondition.
  ///
  /// In en, this message translates to:
  /// **'Terms And Condition'**
  String get termsAndCondition;

  /// No description provided for @referAFriend.
  ///
  /// In en, this message translates to:
  /// **'Refer A Friend'**
  String get referAFriend;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @yourEmailId.
  ///
  /// In en, this message translates to:
  /// **'Your Email Id'**
  String get yourEmailId;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @codeSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Code sent successfully'**
  String get codeSentSuccessfully;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @smartWateringSystem.
  ///
  /// In en, this message translates to:
  /// **'Smart Watering System'**
  String get smartWateringSystem;

  /// No description provided for @lightControl.
  ///
  /// In en, this message translates to:
  /// **'Light Control'**
  String get lightControl;

  /// No description provided for @temperatureMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Temperature Monitoring'**
  String get temperatureMonitoring;

  /// No description provided for @soilAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Soil Analysis'**
  String get soilAnalysis;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @automationSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Automation Suggestions'**
  String get automationSuggestions;

  /// No description provided for @plantRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Plant Recommendations'**
  String get plantRecommendations;

  /// No description provided for @viewRecommendedProfessionals.
  ///
  /// In en, this message translates to:
  /// **'View Recommended Professionals'**
  String get viewRecommendedProfessionals;

  /// No description provided for @recommendedProfessionals.
  ///
  /// In en, this message translates to:
  /// **'Recommended Professionals'**
  String get recommendedProfessionals;

  /// No description provided for @requestAQuote.
  ///
  /// In en, this message translates to:
  /// **'Request A Quote'**
  String get requestAQuote;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @requestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Request Sent Successfully!'**
  String get requestSentSuccessfully;

  /// No description provided for @requestSentSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your Quote Request Has Been Sent To Our Professionals. They Will Review Your Requirements And Reach Out To You With Their Proposals.'**
  String get requestSentSuccessMessage;

  /// No description provided for @professionalNotified.
  ///
  /// In en, this message translates to:
  /// **'Professionals Notified'**
  String get professionalNotified;

  /// No description provided for @passwordNotStrong.
  ///
  /// In en, this message translates to:
  /// **'The password isnt strong enough'**
  String get passwordNotStrong;

  /// No description provided for @emailAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'That email is already used for an account'**
  String get emailAlreadyUsed;

  /// No description provided for @yourAccountHasBeenCreated.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully.'**
  String get yourAccountHasBeenCreated;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get completed;

  /// No description provided for @changeToEnglish.
  ///
  /// In en, this message translates to:
  /// **'Change To English'**
  String get changeToEnglish;

  /// No description provided for @passwordFieldCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password field cannot be empty'**
  String get passwordFieldCannotBeEmpty;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @areYouSureYouWantToChangeTheLanguage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to change the language?'**
  String get areYouSureYouWantToChangeTheLanguage;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// No description provided for @goToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go To Dashboard'**
  String get goToDashboard;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @pleaseLoginToSubmitQuote.
  ///
  /// In en, this message translates to:
  /// **'Please log in to submit your quote request'**
  String get pleaseLoginToSubmitQuote;

  /// No description provided for @pleaseLoginToSeeRecommendedProfessionals.
  ///
  /// In en, this message translates to:
  /// **'Please log in to see recommended professionals'**
  String get pleaseLoginToSeeRecommendedProfessionals;

  /// No description provided for @incorrectCodePleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code. Please try again.'**
  String get incorrectCodePleaseTryAgain;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @pleaseSelectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Please select an answer!'**
  String get pleaseSelectAnswer;

  /// No description provided for @organic.
  ///
  /// In en, this message translates to:
  /// **'Organic'**
  String get organic;

  /// No description provided for @sabd.
  ///
  /// In en, this message translates to:
  /// **'Sabd'**
  String get sabd;

  /// No description provided for @silt.
  ///
  /// In en, this message translates to:
  /// **'Silt'**
  String get silt;

  /// No description provided for @clay.
  ///
  /// In en, this message translates to:
  /// **'Clay'**
  String get clay;

  /// No description provided for @noPlantRecommendationsFound.
  ///
  /// In en, this message translates to:
  /// **'No plant recommendations found.'**
  String get noPlantRecommendationsFound;

  /// No description provided for @pleaseSelectAtLeastOneProfessional.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one professional.'**
  String get pleaseSelectAtLeastOneProfessional;

  /// No description provided for @exitAppContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the application?'**
  String get exitAppContent;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @inText.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get inText;

  /// No description provided for @noProfessionalsAvailable.
  ///
  /// In en, this message translates to:
  /// **'There are currently no professionals available for this area.'**
  String get noProfessionalsAvailable;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection!!'**
  String get noInternetConnection;

  /// No description provided for @pleaseAcceptTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms of Use & Privacy Policy to continue.'**
  String get pleaseAcceptTermsAndConditions;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon !!!'**
  String get comingSoon;

  /// No description provided for @searchPlantsByNameAndDescription.
  ///
  /// In en, this message translates to:
  /// **'Search Plants by name, description..'**
  String get searchPlantsByNameAndDescription;

  /// No description provided for @noPlantsFound.
  ///
  /// In en, this message translates to:
  /// **'No Plants Found !!!'**
  String get noPlantsFound;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'SeeAll'**
  String get seeAll;

  /// No description provided for @scientificName.
  ///
  /// In en, this message translates to:
  /// **'Scientific Name'**
  String get scientificName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @treatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatment;

  /// No description provided for @careNotes.
  ///
  /// In en, this message translates to:
  /// **'Care Notes'**
  String get careNotes;

  /// No description provided for @spaceTypes.
  ///
  /// In en, this message translates to:
  /// **'Space Types'**
  String get spaceTypes;

  /// No description provided for @areaSize.
  ///
  /// In en, this message translates to:
  /// **'Area Size'**
  String get areaSize;

  /// No description provided for @watering.
  ///
  /// In en, this message translates to:
  /// **'Watering'**
  String get watering;

  /// No description provided for @lightCondition.
  ///
  /// In en, this message translates to:
  /// **'Light Condition'**
  String get lightCondition;

  /// No description provided for @soilType.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get soilType;

  /// No description provided for @issue.
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get issue;

  /// No description provided for @issueType.
  ///
  /// In en, this message translates to:
  /// **'Issue Type'**
  String get issueType;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// No description provided for @symptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptoms;

  /// No description provided for @causes.
  ///
  /// In en, this message translates to:
  /// **'Causes'**
  String get causes;

  /// No description provided for @suggestedTreatment.
  ///
  /// In en, this message translates to:
  /// **'Suggested Treatment'**
  String get suggestedTreatment;

  /// No description provided for @immediate.
  ///
  /// In en, this message translates to:
  /// **'Immediate'**
  String get immediate;

  /// No description provided for @longTerm.
  ///
  /// In en, this message translates to:
  /// **'Long Term'**
  String get longTerm;

  /// No description provided for @prevention.
  ///
  /// In en, this message translates to:
  /// **'Prevention'**
  String get prevention;

  /// No description provided for @healthStatus.
  ///
  /// In en, this message translates to:
  /// **'Health Status'**
  String get healthStatus;

  /// No description provided for @similarPlants.
  ///
  /// In en, this message translates to:
  /// **'Similar Plants'**
  String get similarPlants;

  /// No description provided for @uses.
  ///
  /// In en, this message translates to:
  /// **'Uses'**
  String get uses;

  /// No description provided for @toxicity.
  ///
  /// In en, this message translates to:
  /// **'Toxicity'**
  String get toxicity;

  /// No description provided for @kasagardemPlantDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Kasagardem Plant Diagnosis'**
  String get kasagardemPlantDiagnosis;

  /// No description provided for @automationFeature.
  ///
  /// In en, this message translates to:
  /// **'Automation Feature'**
  String get automationFeature;

  /// No description provided for @howItHelps.
  ///
  /// In en, this message translates to:
  /// **'How It Helps'**
  String get howItHelps;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits;

  /// No description provided for @howToSetup.
  ///
  /// In en, this message translates to:
  /// **'How To Setup'**
  String get howToSetup;

  /// No description provided for @plantDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Plant Diagnosis'**
  String get plantDiagnosis;

  /// No description provided for @tapToDiagnoseYourPlant.
  ///
  /// In en, this message translates to:
  /// **'Tap to diagnose your plant'**
  String get tapToDiagnoseYourPlant;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get locationPermissionRequired;

  /// No description provided for @locationPermissionsAreDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied. Please go to your app settings to enable them for Kasagardem.'**
  String get locationPermissionsAreDenied;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @noPlantDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Plant data available'**
  String get noPlantDataAvailable;

  String get home;

  String get professionals;

  String get store;

  String get courses;

  String get siteKasagardem;

  String get myProfile;

  String get myPlants;

  String get searchYourPlant;

  String get plant;
  String get andCounting;

  String get health;

  String get addYourFirstPlant;

  String get addYourFirstPlantDescription;

  String get searchPlants;

  String get trendingPlants;

  String get days;

  String get day;

  String get ago;

  String get week;

  String get water;

  String get watered;

  String get fertilizing;

  String get pruning;

  String get viewAll;

  String get every;

  String get personalizedCare;

  String get plantStats;

  String get upcomingEvents;

  String get plantHistory;

  String get schedule;

  String get alerts;

  String get general;

  String get options;

  String get preferred;

  String get time;

  String get date;

  String get criticalCare;

  String get scheduledFor;

  String get reminders;

  String get frequency;

  String get consistent;

  String get addPlant;

  String get editPlant;

  String get howWouldYouLikeToContinue;

  String get user;

  String get client;

  String get userDescription;

  String get professional;

  String get professionalDescription;

  String get annually;

  String get monthly;

  String get continueWith;

  String get professionalStatus;

  String get goldPlan;

  String get active;

  String get renewPlan;

  String get subscriptionRemaining;

  String get exp;

  String get left;

  String get yourPlanEnds;

  String get yourPlanEndsDesc;

  String get selectYourPlan;

  String get toSpeak;

  String get gold;

  String get diamante;

  String get covers;

  String get additionalNationalCoverage;

  String get additionalNationalCoverageDesc1;

  String get additionalNationalCoverageDesc2;

  String get planType;

  String get oneTime;

  String get reccuring;

  String get mu;

  String get an;

  String get validFor1Year;

  String get orderSummary;

  String get total;

  String get fullPayment;

  String get myLeads;

  String get myLeadsDesc;

  String get search;

  String get viewDetails;

  String get wholesaleSuppliers;

  String get find;

  String get yourProfileIsCurrently;

  String get inactive;

  String get customerPlanDesc;

  String get customerPlanDesc2;

  String get seePlans;

  String get notNow;

  String get youAreOnA30DayFreeTrial;

  String get upgradeNow;

  String get youAreOnA30DayTrialEnded;

  String get serviceRequested;

  String get citiesCoverage;

  String get appearInSearchResults;

  String get unlimitedLeads;

  String get premiumProfileBadge;

  String get priorityCustomerSupport;

  String get noLeadsFound;

  String get name;

  String get email;

  String get address;

  String get location;

  String get role;

  String get leadStatus;

  String get companyDetails;

  String get plantGrowers;

  String get flowers;

  String get fertilizers;

  String get equipment;

  String get newLead;

  String get closedLead;

  String get contactedLead;

  String get totalLeads;

  String get updateLeadStatus;

  String get region;

  String get specialty;

  String get successfullyAdded;

  String get selectAtLeastOneReminder;

  String get selectWateringFrequency;

  String get selectWateringTime;

  String get selectFertilizerFrequency;

  String get selectFertilizerTime;

  String get selectPruningFrequency;

  String get selectGeneralFrequency;

  String get enableWatering;

  String get enableCriticalCare;

  String get enableFertilizing;

  String get enablePruning;

  String get selectFrequency;

  String get selectTime;

  String get gotoMyPlants;

  String get addMissingInfo;

  String get careProfileCompletion;

  String get deleteAccount;

  String get areYouSureYouWantToDeleteYourAccount;

  String get tap;

  String get toAddYourFirstPlant;

  String get newPasswordCannotBeSameAsCurrentPassword;

  String get selectService;
  String get shortDescription;
  String get enterShortDescription;
  String get sizeOfTheArea;
  String get enterSizeOfTheArea;
  String get submitRequest;

  //category

  String get landscapingGardening;
  String get flowerShops;
  String get swimmingPools;
  String get outdoorFlooring;
  String get irrigation;
  String get outdoorLighting;
  String get lawnTurf;
  String get bbqOutdoorKitchen;
  String get decksPergolas;
  String get nurseriesSeedlings;
  String get pestControl;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;

}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
