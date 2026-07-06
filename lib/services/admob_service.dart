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
    if (Get.isRegistered<SettingsViewModel>()) {
      final settingsVm = Get.find<SettingsViewModel>();
      final sub = settingsVm.currentSubscriptionStatusModel.value;
      if (sub != null && sub.isActive == true) {
        final planName = sub.name?.toLowerCase().trim() ?? '';
        if (planName.isNotEmpty && planName != 'free' && planName != 'trial') {
          debugPrint('Ads hidden for active plan: $planName');
          return false;
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

  //Test
  static const String _androidTestBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _iosTestBannerId = 'ca-app-pub-3940256099942544/2934735716';
  static const String _androidTestRewardId = 'ca-app-pub-3940256099942544/5224354917';
  static const String _iosTestRewardId = 'ca-app-pub-3940256099942544/1712485313';

  /*  static const String _androidTestBannerId = 'ca-app-pub-9167105189322595/3663276357';
  static const String _iosTestBannerId = 'ca-app-pub-3940256099942544/2934735716';
  static const String _androidTestRewardId = 'ca-app-pub-9167105189322595/2316616659';
  static const String _iosTestRewardId = 'ca-app-pub-3940256099942544/1712485313';*/

  /// Get the banner ad unit ID based on platform
  String get bannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid ? _androidTestBannerId : _iosTestBannerId;
    }

    final configuredId = AppConfig.shared.bannerId?.trim();
    if (configuredId != null && configuredId.isNotEmpty) {
      return configuredId;
    }
    return Platform.isAndroid ? _androidTestBannerId : _iosTestBannerId;
  }

  /// Get the rewarded ad unit ID based on platform
  String get rewardedAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid ? _androidTestRewardId : _iosTestRewardId;
    }

    final configuredId = AppConfig.shared.rewardId?.trim();
    if (configuredId != null && configuredId.isNotEmpty) {
      return configuredId;
    }
    return Platform.isAndroid ? _androidTestRewardId : _iosTestRewardId;
  }

  /// Disposes any existing banner and loads a fresh one.
  Future<BannerAd?> loadBannerAd({
    BannerAd? existingAd,
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) async {
    existingAd?.dispose();

    if (!shouldShowBanners) {
      debugPrint('Banner ad skipped: shouldShowBanners=false');
      return null;
    }

    await ensureInitialized();

    debugPrint('Loading banner ad: $bannerAdUnitId');
    var loaded = false;
    final ad = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          loaded = true;
          debugPrint('BannerAd loaded: ${ad.adUnitId}');
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed (${error.code}): ${error.message} | domain=${error.domain}');
          onAdFailedToLoad(ad, error);
        },
      ),
    );

    try {
      await ad.load();
    } catch (e, stack) {
      debugPrint('BannerAd load threw: $e\n$stack');
      ad.dispose();
      return null;
    }

    return loaded ? ad : null;
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
