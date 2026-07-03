import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kasagardem/settings/settings_view_model.dart';

import '../utils/app_config.dart';

class AdMobService {
  AdMobService._privateConstructor();

  static final AdMobService instance = AdMobService._privateConstructor();

  bool _isInitialized = false;
  Future<void>? _initializationFuture;

  /// Must be called once at app startup before loading any ads.
  Future<void> ensureInitialized() {
    _initializationFuture ??= _initialize();
    return _initializationFuture!;
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      final status = await MobileAds.instance.initialize();
      debugPrint('MobileAds initialized: $status');

      // Give the Android platform view time to finish setup before first ad load.
      if (Platform.isAndroid) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }

      _isInitialized = true;
    } catch (e, stack) {
      debugPrint('MobileAds initialization failed: $e\n$stack');
      rethrow;
    }
  }

  /// Determine if we should show ads based on subscription status
  bool get shouldShowAds {
    // need change
    if (Get.isRegistered<SettingsViewModel>()) {
      final settingsVm = Get.find<SettingsViewModel>();
      final sub = settingsVm.currentSubscriptionStatusModel.value;
      if (sub != null && sub.isActive == true) {
        // If subscription is active, and it is NOT "free" or "trial" plan
        final planName = sub.name?.toLowerCase() ?? '';
        if (planName != 'free' && planName != 'trial') {
          return false; // Hide ads for paid premium subscriptions
        }
      }
    }
    return true;
  }

  /// Toggle banner ads visibility separately
  bool get shouldShowBanners {
    if (!shouldShowAds) return false;
    return true; // Set to false to disable banner ads globally
  }

  /// Toggle rewarded ads visibility separately
  bool get shouldShowRewarded {
    if (!shouldShowAds) return false;
    return true; // Set to false to disable rewarded ads globally
  }

  /// Get the banner ad unit ID based on platform
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      final configuredId = AppConfig.shared.bannerId?.trim();
      if (configuredId != null && configuredId.isNotEmpty) {
        return configuredId;
      }
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      final configuredId = AppConfig.shared.bannerId?.trim();
      if (configuredId != null && configuredId.isNotEmpty) {
        return configuredId;
      }
      return "ca-app-pub-3940256099942544/2934735716";
    }
    return '';
  }

  /// Get the rewarded ad unit ID based on platform
  String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      final configuredId = AppConfig.shared.rewardId?.trim();
      if (configuredId != null && configuredId.isNotEmpty) {
        return configuredId;
      }
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      final configuredId = AppConfig.shared.rewardId?.trim();
      if (configuredId != null && configuredId.isNotEmpty) {
        return configuredId;
      }
      return "ca-app-pub-3940256099942544/1712485313";
    }
    return '';
  }

  /// Disposes any existing banner and loads a fresh one.
  Future<BannerAd?> loadBannerAd({
    BannerAd? existingAd,
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) async {
    existingAd?.dispose();

    if (!shouldShowBanners) {
      return null;
    }

    await ensureInitialized();

    debugPrint('Loading banner ad: $bannerAdUnitId');
    final ad = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
    await ad.load();
    return ad;
  }

  /// Helper to load and show a RewardedAd
  Future<void> showRewardedAd({
    required VoidCallback onUserEarnedReward,
    required VoidCallback onAdDismissed,
    required VoidCallback onAdFailedToShow,
  }) async {
    if (!shouldShowRewarded) {
      onUserEarnedReward();
      return;
    }

    await ensureInitialized();

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('RewardedAd loaded: $ad');
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) => debugPrint('RewardedAd showed: $ad'),
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              debugPrint('RewardedAd dismissed: $ad');
              ad.dispose();
              onAdDismissed();
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              debugPrint('RewardedAd failed to show: $error');
              ad.dispose();
              onAdFailedToShow();
            },
          );

          ad.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              debugPrint('User earned reward: $reward');
              onUserEarnedReward();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          onAdFailedToShow();
        },
      ),
    );
  }
}
