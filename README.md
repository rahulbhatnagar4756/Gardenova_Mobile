# Kasagardem

**A Plant and Garden Management App**

**Developer:** Smriti Rawat
**Date:** 19-08-2026

## Features Added

* **Chatbot**

  * Introduced Chatbot for quick gardening-related questions and assistance.

* **Plant Analysis History**

  * Added Plant Analysis History with detailed diagnosis reports.

* **Plant Comparison**

  * Added Plant Comparison to compare current and previous plant scans.

* **Fitness Score Card**

  * Introduced the Fitness Score card to help assess garden health and potential.

* **Performance and Bug Fixes**

  * Improved app performance and fixed bugs.

* **UI/UX Enhancements**

  * Enhanced the UI/UX for a smoother and more user-friendly experience.

## Bugs Resolved

* **Redirect to Home After Signup**

  * After successful registration and OTP verification, the user is automatically logged in.
  * The access token and refresh token are saved successfully.
  * The user is redirected to the onboarding questions screen instead of the login screen.

* **Onboarding Questions Progress Bar**

  * Fixed the progress bar so that progress is based on the number of answered questions rather than the current question index.
  * For example, the first unanswered question no longer displays 16% progress.
  * Progress reaches 100% once all onboarding questions have been answered.

* **Refresh Token Functionality**

  * When an API returns a `401 Unauthorized` response due to an expired access token, the app automatically calls the refresh-token API using the stored `refreshToken`.
  * On successful refresh, the new access and refresh tokens are saved.
  * The original failed API request is then retried using the new access token.
  * If the refresh-token API also returns `401`, the user is automatically logged out.

* **Preferences Progress**

  * Fixed onboarding and preference progress so that it reflects the number of answered questions instead of the current question index.

* **Error Messages**

  * Fixed API and validation error handling so that appropriate error messages are displayed correctly to the user.

* **Success and Failure Messages**

  * Fixed popup and snackbar visibility issues.
  * Success and failure messages are now displayed correctly to the user.

* **Password Validation**

  * Fixed password validation messages on the registration and related forms.

* **Plant Care Reminders UI**

  * Fixed UI issues in the plant care reminders list and related reminder components.
  * Reminder information and upcoming tasks are now displayed correctly.

* **Mobile Number Validation**

  * Added validation to ensure that the mobile number contains exactly 10 digits.
  * The 10-digit limit is still enforced.
  * The `maxLength` counter, such as `1/10`, is hidden from the mobile number field.

## Files Changed

1. `assets/images/chatbotIcon.png`
2. `assets/images/chatboticon.svg`
3. `lib/authentication/auth_repository.dart`
4. `lib/authentication/login/login_view_model.dart`
5. `lib/authentication/register/register_screen.dart`
6. `lib/authentication/register/register_view_model.dart`
7. `lib/base/widgets/base_text_field.dart`
8. `lib/base/widgets/chatbot_fab.dart`
9. `lib/chatbot/chatbot_controller.dart`
10. `lib/chatbot/chatbot_repository.dart`
11. `lib/chatbot/chatbot_screen.dart`
12. `lib/chatbot/models/chat_message.dart`
13. `lib/chatbot/models/garden_chat_request_model.dart`
14. `lib/chatbot/models/garden_chat_response_model.dart`
15. `lib/dashboard/components/full_drawer.dart`
16. `lib/dashboard/components/main_dashboard_content.dart`
17. `lib/dashboard/dashboard_controller.dart`
18. `lib/dashboard/dashboard_repository.dart`
19. `lib/dashboard/dashboard_screen.dart`
20. `lib/dashboard/model/garden_insights_model.dart`
21. `lib/introduction/question/question_screen.dart`
22. `lib/introduction/question/question_view_model.dart`
23. `lib/landscape_design/landscape_design_repository.dart`
24. `lib/main.dart`
25. `lib/plants/plant_analysis/components/plant_scan_card.dart`
26. `lib/plants/plant_analysis/components/plant_scan_compare_sheet.dart`
27. `lib/plants/plant_analysis/model/plant_scan_compare_model.dart`
28. `lib/plants/plant_analysis/model/plant_scan_detail_model.dart`
29. `lib/plants/plant_analysis/model/plant_scan_model.dart`
30. `lib/plants/plant_analysis/plant_analysis_compare_controller.dart`
31. `lib/plants/plant_analysis/plant_analysis_compare_screen.dart`
32. `lib/plants/plant_analysis/plant_analysis_controller.dart`
33. `lib/plants/plant_analysis/plant_analysis_detail_controller.dart`
34. `lib/plants/plant_analysis/plant_analysis_detail_screen.dart`
35. `lib/plants/plant_analysis/plant_analysis_repository.dart`
36. `lib/plants/plant_analysis/plant_analysis_screen.dart`
37. `lib/plants/plant_analysis/views/plant_analysis_detail_error_view.dart`
38. `lib/plants/plant_analysis/views/plant_analysis_detail_loading_view.dart`
39. `lib/plants/plant_analysis/views/plant_analysis_detail_success_view.dart`
40. `lib/reminders/component/reminder_card.dart`
41. `lib/reminders/component/upcoming_task.dart`
42. `lib/reminders/plant_reminder_list_screen.dart`
43. `lib/settings/settings_repository.dart`
44. `lib/settings/settings_view_model.dart`
45. `lib/splash_screen.dart`
46. `lib/utils/constants/api_keys.dart`
47. `lib/utils/constants/app_assets.dart`
48. `lib/utils/constants/app_color.dart`
49. `lib/utils/constants/app_strings.dart`
50. `lib/utils/network_services/api_repository.dart`
51. `lib/utils/routes.dart`
52. `lib/utils/validation_healper.dart`
