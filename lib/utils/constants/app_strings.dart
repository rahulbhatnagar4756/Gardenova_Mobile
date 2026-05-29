class AppStrings {
  /*Exceptions*/
  static const String fetchDataException = 'FetchDataException';
  static const String badRequestException = 'BadRequestException';
  static const String unauthorisedException = 'UnauthorisedException';
  static const String notFoundException = 'NotFoundException';
  static const String serverException =
      'Error occurred while Communication with Server with StatusCode';
  static const String invalidHttpMethod = 'Invalid HTTP method';
  static const String cancel = "Cancel";
  static const String confirm = "Confirm";
  static const String changeLanguage = "Change Language";
  static const String areYouSureYouWantLanguage =
      "Are You Sure You Want Language";
  static const String areYouSureWantToLogout = "Are you sure want to logout?";

  // static const String exception = "Exception";
  static const String exception = "Request failed";
  static const String networkError = "Network Error";
  static const String somethingWentWrong = "Something Went Wrong";
  static const String retry = "Retry";
  static const String google = "Google";
  static const String apple = "Apple";
  static const String login = "Login";
  static const String register = "register";

  static const String home = "Home";
  static const String professionals = "Professionals";
  static const String store = "Store";
  static const String courses = "Courses";
  static const String siteKasagardem = "Site kasagardem";
  static const String myProfile = "My Profile";
  static const String myPlants = "My Plants";
  static const String searchYourPlant = "Search Your Plant";
  static const String plantAndCounting = "plants and counting";
  static const String health = "Health";
  static const String inText = "In";
  static const String days = "days";
  static const String water = "Water";
  static const String fertilizing = "Fertilizing";
  static const String pruning = "Pruning";
  static const String viewAll = "View All";
  static const String addYourFirstPlant = "Add your first plant";
  static const String addYourFirstPlantDescription =
      "Search for common name, scientific name or variety of your plant";
  static const String searchPlants = "Search Plants";
  static const String watering = "Watering";
  static const String scheduledFor = "Scheduled For";
  static const String personalizedCare = "Personalized Care";
  static const String plantStats = "Plant Stats";
  static const String every = "Every";
  static const String everyWeek = "Week";
  static const String upcomingEvents = "Upcoming Events";
  static const String plantHistory = "Plant History";
  static const String schedule = "schedule";
  static const String alerts = "Alerts";
  static const String general = "General";
  static const String options = "Options";
  static const String preferred = "Preferred";
  static const String time = "Time";
  static const String date = "Date";
  static const String criticalCare = "Critical Care";

  static const String locationDisabled = "Location Disabled";

  static const String enableLocationServices =
      "Please enable location services to continue.";

  static const String openSettings = "Open Settings";

  static const String permissionRequired = "Permission Required";

  static const String locationPermissionPermanentlyDenied =
      "Location permission is permanently denied. Enable it from settings.";

  static const String locationServicesDisabled =
      "Location services are disabled.";

  static const String locationPermissionDenied = "Location permission denied";

  static const String permissionPermanentlyDenied =
      "Permission permanently denied";

  static const String unableToFetchLocation = "Unable to fetch location";

  static const String aiLandscapeDesign = "AI Landscape Design";
  static const String designModernLushAndInspiringOutdoorSpacesWithAi =
      "Design modern, lush, and inspiring outdoor spaces with AI.";
  static const String possibleCauses = "Possible Causes";
  static const String plantLooksHealthy = "Plant Looks Healthy";
  static const String plantNeedsAttention = "Plant Needs Attention";
  static const String noDiseaseDetected = "No Disease Detected";
  static const String mainIssue = "Main Issue";
  static const String plant = "Plant";
  static const String aiConfidence = "AI Confidence";
  static const String healthScore = "Health Score";
  static const String plantLooksHealthyWithEmoji = "Plant Looks Healthy 🌿";
  static const String plantDescription = "Plant Description";
  static const String similarPlantImages = "Similar Plant Images";
  static const String wateringSchedule = "Watering Schedule";
  static const String fertilizingSchedule = "Fertilizing Schedule";
  static const String pruningSchedule = "Pruning Schedule";
  static const String pestControlSchedule = "Pest Control Schedule";
  static const String diseaseControlSchedule = "Disease Control Schedule";
  static const String issue = "Issue";
  static const String plantTaxonomy = "Plant Taxonomy";
  static const String kingdom = "Kingdom";
  static const String family = "Family";
  static const String genus = "Genus";
  static const String order = "Order";
  static const String toxicityWarning = "Toxicity Warning";
  static const String treatmentGuide = "Treatment Guide";
  static const String tryAgain = "Try Again";
  static const String unknownPlant = "Unknown Plant";
  static const String noPlantDetected = "No Plant Detected";
  static const String pleaseUpload =
      "Please upload a clearer plant image for better diagnosis.";

  static const String careGuide = "Care Guide";
  static const String lightCondition = "Light Condition";
  static const String soilType = "Soil Type";

  static const String comingSoon = "Coming Soon";
  static const String addPlantFunctionalityWillBeAvailableSoon =
      "Add Plant functionality will be available soon!";
  static const String noDetailsFoundForThisPlant =
      "No details found for this plant.";
  static const String careOverview = "Care Overview";
  static const String fertilizer = "Fertilizer";
  static const String sunlight = "Sunlight";
  static const String soil = "Soil";
  static const String noDesignDataFound = "No design data found";

  static const String pleaseLoginToSeeAiDiagnosis =
      "Please log in to scan your plant, identify it, and check its health using AI.";

  static const String pleaseLoginToMakeAiLandscapeDesign =
      "Please log in to use AI-powered modern design and landscape design features.";
  static const String changeDiagnosis = 'Preferences';
  // static const String changeDiagnosis = 'Change Diagnosis';
  static const String selectionRequired = 'Selection Required';
  static const String pleaseSelectAnAnswerToContinue =
      'Please select an answer to continue';
  static const String plants = "Plants";
  static const String scan = "Scan";
  static const String reports = "Reports";
  static const String profile = "Profile";
  static const String yourPhoneNo = "Your Phone no.";

  static const String legal = "Legal";
  static const String accountAction = "Account Setting";

  static const String verifyEmailAddress = "Verify Email Address";
  static const String verifyEmailSubTxt =
      "We have sent a verification code to EMAIL_ADDRESS";
  static const setPwd = 'Set Password';
  static const changePwdMsg = "Update your security password";
  static const setPwdMsg = "Set your security password";
  static const setPwdBtnMsg = "Set Password";
  static const tapAddPlantsToAddNewPlant =
      "Tap “Add Plants” to add your first plant";
}

class ErrorStrings {
  static const invalidName = 'Please enter a valid Name.';
  static const invalidEmail = 'Please enter a valid Email.';
  static const invalidPhoneNo = 'Please enter a valid Phone Number.';
  static const phoneNoMustBeAtleast7Digits =
      'Phone number must contain 7 to 14 digits.';

  static const pwdFieldNotEmpty = 'Password field cannot be Empty.';
  static const invalidPassword = 'Please enter a valid Password.';

  static const pwdMustBeAtLeadEightCharecter =
      'Password must be at least 8 Characters.';
  static const pwdMustContainAtLeastOneCapitalLetter =
      'Password must contain at least one Capital Letter.';
  static const pwdMustContainAtLeastOneSmallLetter =
      'Password must contain at least one Small Letter.';
  static const pwdMustContainAtLeastOneNumber =
      'Password must contain at least one Number.';
  static const pwdMustContainAtLeastOneSpecialCharacter =
      'Password must contain at least one Special Character.';
  static const confirmPasswordsNotMatch = 'Confirm Password do not Match.';
}
