# Kasagardem

**A Plant and Garden Management App**

**Developer:** Smriti Rawat
**Date:** 19-08-2026

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

1. `lib/authentication/auth_repository.dart`
2. `lib/authentication/login/login_view_model.dart`
3. `lib/authentication/register/register_screen.dart`
4. `lib/authentication/register/register_view_model.dart`
5. `lib/base/widgets/base_text_field.dart`
6. `lib/introduction/question/question_screen.dart`
7. `lib/introduction/question/question_view_model.dart`
8. `lib/landscape_design/landscape_design_repository.dart`
9. `lib/main.dart`
10. `lib/reminders/component/reminder_card.dart`
11. `lib/reminders/component/upcoming_task.dart`
12. `lib/reminders/plant_reminder_list_screen.dart`
13. `lib/settings/settings_repository.dart`
14. `lib/settings/settings_view_model.dart`
15. `lib/splash_screen.dart`
16. `lib/utils/constants/api_keys.dart`
17. `lib/utils/constants/app_color.dart`
18. `lib/utils/constants/app_strings.dart`
19. `lib/utils/network_services/api_repository.dart`
20. `lib/utils/validation_healper.dart`
