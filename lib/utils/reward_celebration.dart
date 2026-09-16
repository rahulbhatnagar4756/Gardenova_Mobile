import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:reward_popup/reward_popup.dart';

/// Shared celebrations for task completion and reward claims.
class RewardCelebration {
  RewardCelebration._();

  static const _confettiColors = [
    AppColors.greenColor,
    AppColors.liteYellowColor,
    AppColors.orangeColor,
    AppColors.liteGreenColor,
    AppColors.darkGold,
  ];

  static BuildContext? get _context => Get.overlayContext ?? Get.context;

  /// Light confetti burst — use on individual task completion.
  static void burstConfetti({bool big = false}) {
    final context = _context;
    if (context == null) return;

    Confetti.launch(
      context,
      options: ConfettiOptions(
        particleCount: big ? 140 : 55,
        spread: big ? 75 : 50,
        y: 0.65,
        colors: _confettiColors,
      ),
    );
  }

  /// Full reward popup + confetti — use when claiming XP / redeeming a reward.
  static Future<void> showPopup({
    required String title,
    String? subtitle,
    IconData icon = Icons.emoji_events_rounded,
  }) async {
    final context = _context;
    if (context == null) return;

    Future.delayed(const Duration(milliseconds: 450), () {
      burstConfetti(big: true);
    });

    await showRewardPopup<void>(
      context,
      backgroundColor: AppColors.darkGreenColor,
      enableDismissByTappingOutside: true,
      child: Positioned.fill(
        child: Builder(
          builder: (popupContext) {
            return Material(
              color: AppColors.darkGreenColor,
              child: InkWell(
                onTap: () => Navigator.of(popupContext).pop(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 72, color: AppColors.liteYellowColor),
                      const SizedBox(height: 18),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: AppKeys.poppins,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      if (subtitle != null && subtitle.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppKeys.poppins,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.whiteColor.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
