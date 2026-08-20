import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/base/widgets/full_screen_image_preview.dart';
import 'package:kasagardem/chatbot/chatbot_controller.dart';
import 'package:kasagardem/chatbot/models/chat_message.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class ChatbotScreen extends GetWidget<ChatbotController> {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const _ChatBackground(),
          SafeArea(
            child: Column(
              children: [
                _ChatHeader(
                  title: l10n.aiAssistant,
                  status: l10n.online,
                  onNewChat: controller.clearChat,
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingHistory.value &&
                        controller.messages.isEmpty &&
                        !controller.isUpgradeRequired) {
                      return const _HistoryLoadingView();
                    }
                    if (controller.isUpgradeRequired) {
                      return _UpgradeRequiredView(
                        message: controller.upgradeRequiredMessage.value!,
                      );
                    }
                    if (controller.messages.isEmpty) {
                      return _EmptyChatView(
                        greeting: controller.greetingTitle,
                        askMeAnything: l10n.askMeAnything,
                        suggestions: [],
                        onSuggestionTap: controller.applySuggestion,
                      );
                    }
                    return _ChatMessagesView(
                      messages: controller.messages.toList(),
                      isTyping: controller.isTyping.value,
                      isLoadingMore: controller.isLoadingMore.value,
                      scrollController: controller.scrollController,
                    );
                  }),
                ),
                Obx(() {
                  if (controller.isUpgradeRequired) {
                    return const SizedBox.shrink();
                  }
                  return _ChatComposer(
                    textController: controller.messageController,
                    selectedImage: controller.selectedImage.value,
                    canSend: controller.canSend,
                    hintText: l10n.askMeAnything,
                    onChanged: controller.onTextChanged,
                    onAddImage: controller.showImageSourceSheet,
                    onRemoveImage: controller.removeSelectedImage,
                    onSend: controller.sendMessage,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionItem {
  const _SuggestionItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class _ChatBackground extends StatelessWidget {
  const _ChatBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.toToLiteGreenColor.withValues(alpha: 0.7),
                AppColors.lightGreen.withValues(alpha: 0.35),
                AppColors.whiteColor,
                AppColors.backgroundLightGrey,
              ],
              stops: const [0, 0.22, 0.55, 1],
            ),
          ),
        ),
        Positioned(
          top: -70.h,
          right: -50.w,
          child: _GlowBlob(
            size: 220.w,
            color: AppColors.greenColor.withValues(alpha: 0.12),
          ),
        ),
        Positioned(
          top: 180.h,
          left: -80.w,
          child: _GlowBlob(
            size: 180.w,
            color: AppColors.liteGreenColor.withValues(alpha: 0.16),
          ),
        ),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.title,
    required this.status,
    required this.onNewChat,
  });

  final String title;
  final String status;
  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 10.h),
      child: Row(
        children: [
          _RoundIconButton(
            onTap: () => Get.back(),
            child: Image.asset(AppAssets.backBtnIc, width: 16.w, height: 16.w),
          ),
          SizedBox(width: 10.w),
          const _HeaderAvatar(),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  text: title,
                  fontSize: fontSize16,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppKeys.poppins,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Container(
                      width: 7.w,
                      height: 7.w,
                      decoration: const BoxDecoration(
                        color: AppColors.greenColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    BaseText(
                      text: status,
                      fontSize: fontSize11,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppKeys.inter,
                      textColor: AppColors.greenColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
      
        ],
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.w,
      height: 42.w,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.greenColor.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CommonClickWidget(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withValues(alpha: 0.86),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.whiteColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _EmptyChatView extends StatelessWidget {
  const   _EmptyChatView({
    required this.greeting,
    required this.askMeAnything,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  final String greeting;
  final String askMeAnything;
  final List<_SuggestionItem> suggestions;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.focusScope?.unfocus(),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacerSize24),
              child: Column(
                children: [
                  const Spacer(),
                  const _HeroOrb(),
                  SizedBox(height: 22.h),
                  BaseText(
                    text: greeting,
                    fontSize: fontSize24,
                    textColor: AppColors.charcoalGrey,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppKeys.poppins,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  BaseText(
                    text: askMeAnything,
                    fontSize: fontSize16  ,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppKeys.inter,
                    textColor: AppColors.liteGreyColor,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  ...suggestions.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: _SuggestionCard(
                        item: item,
                        onTap: () => onSuggestionTap(item.label),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroOrb extends StatefulWidget {
  const _HeroOrb();

  @override
  State<_HeroOrb> createState() => _HeroOrbState();
}

class _HeroOrbState extends State<_HeroOrb> with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _pulseController;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.86, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulse = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward().whenComplete(() {
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulse, _fade, _scale]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: _pulse.value + 0.18,
              child: Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.greenColor.withValues(alpha: 0.08 * _pulse.value * _fade.value),
                ),
              ),
            ),
            child!,
          ],
        );
      },
      child: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            width: 130.w,
            height: 130.w,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.greenColor.withValues(alpha: 0.28),
                  blurRadius: 28,
                  spreadRadius: 1,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain, width: 120.w, height: 120.w),
          ),
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.item, required this.onTap});

  final _SuggestionItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: AppColors.greenColor.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: const BoxDecoration(
                color: AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: AppColors.greenColor, size: 18.w),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: BaseText(
                text: item.label,
                fontSize: fontSize13,
                fontWeight: FontWeight.w500,
                fontFamily: AppKeys.inter,
              ),
            ),
            Icon(Icons.arrow_outward_rounded, size: 16.w, color: AppColors.greyIconColor),
          ],
        ),
      ),
    );
  }
}

class _ChatMessagesView extends StatelessWidget {
  const _ChatMessagesView({
    required this.messages,
    required this.isTyping,
    required this.isLoadingMore,
    required this.scrollController,
  });

  final List<ChatMessage> messages;
  final bool isTyping;
  final bool isLoadingMore;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final itemCount = messages.length + (isTyping ? 1 : 0);

    return Stack(
      children: [
        ListView.separated(
          reverse: true,
          controller: scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
          itemCount: itemCount,
          separatorBuilder: (_, _) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            if (isTyping && index == 0) {
              return const _TypingDots();
            }
            final messageIndex =
                messages.length - 1 - (isTyping ? index - 1 : index);
            return _MessageBubble(message: messages[messageIndex]);
          },
        ),
        if (isLoadingMore)
          const Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: _LoadMoreIndicator(),
          ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final time = _formatMessageTimestamp(context, message.createdAt);

    Widget bubble = Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Get.width * 0.78),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(message.hasImage ? 6.w : 12.w),
                decoration: BoxDecoration(
                  gradient: isUser ? AppColors.linearGradientForBtn : null,
                  color: isUser ? null : AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomLeft: Radius.circular(isUser ? 20.r : 6.r),
                    bottomRight: Radius.circular(isUser ? 6.r : 20.r),
                  ),
                  border: isUser ? null : Border.all(color: AppColors.blackColor.withValues(alpha: 0.05)),
                  boxShadow: [
                    BoxShadow(
                      color: (isUser ? AppColors.greenColor : AppColors.blackColor)
                          .withValues(alpha: isUser ? 0.22 : 0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.hasImage)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: _MessageImage(message: message),
                      ),
                    if (message.hasImage && message.hasText) SizedBox(height: 8.h),
                    if (message.hasText)
                      SizedBox(
                        width: message.hasImage ? _MessageImage.previewWidth : null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: message.hasImage ? 6.w : 2.w,
                            vertical: message.hasImage ? 4.h : 0,
                          ),
                          child: BaseText(
                            text: message.text,
                            fontSize: fontSize14,
                            fontFamily: AppKeys.inter,
                            fontWeight: FontWeight.w400,
                            textColor: isUser ? AppColors.whiteColor : AppColors.blackColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  if (isUser) const Spacer(),
                  BaseText(
                    text: time,
                    fontSize: fontSize10,
                    fontFamily: AppKeys.inter,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.greyIconColor,
                  ),
                  if (!isUser && message.hasText) ...[
                    const Spacer(),
                    _SpeakAnswerButton(messageId: message.id, text: message.text),
                    _CopyAnswerButton(text: message.text),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (message.animateIn && !isUser) {
      return _FadeSlideIn(key: ValueKey('reply_${message.id}'), child: bubble);
    }
    return bubble;
  }
}

String _formatMessageTimestamp(BuildContext context, DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final messageDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
  final locale = Localizations.localeOf(context).toString();
  final time = DateFormat.jm(locale).format(dateTime);

  if (messageDay == today) return time;
  if (messageDay == today.subtract(const Duration(days: 1))) {
    return '${AppLocalizations.of(context)!.yesterday}, $time';
  }

  final dateFormat = dateTime.year == now.year
      ? DateFormat.MMMd(locale)
      : DateFormat.yMMMd(locale);
  return '${dateFormat.format(dateTime)}, $time';
}

class _SpeakAnswerButton extends StatelessWidget {
  const _SpeakAnswerButton({
    required this.messageId,
    required this.text,
  });

  final String messageId;
  final String text;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatbotController>();
    return Obx(() {
      final isPlaying = controller.speakingMessageId.value == messageId;
      final progress = controller.speakingProgress.value;
      return GestureDetector(
        onTap: () => controller.toggleSpeech(messageId: messageId, text: text),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.only(left: 8.w, top: 2.h, bottom: 2.h),
          child: SizedBox(
            width: 20.w,
            height: 20.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isPlaying)
                  CircularProgressIndicator(
                    value: progress.clamp(0.02, 1.0),
                    strokeWidth: 1.6,
                    color: AppColors.greenColor,
                    backgroundColor: AppColors.greyIconColor.withValues(alpha: 0.2),
                  ),
                Icon(
                  isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded,
                  size: isPlaying ? 12.w : 16.w,
                  color: AppColors.greyIconColor,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _CopyAnswerButton extends StatefulWidget {
  const _CopyAnswerButton({required this.text});

  final String text;

  @override
  State<_CopyAnswerButton> createState() => _CopyAnswerButtonState();
}

class _CopyAnswerButtonState extends State<_CopyAnswerButton> {
  final _tooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: _tooltipKey,
      message: AppLocalizations.of(context)!.copied,
      triggerMode: TooltipTriggerMode.manual,
      preferBelow: false,
      waitDuration: Duration.zero,
      showDuration: const Duration(milliseconds: 1200),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(8.r),
      ),
      textStyle: TextStyle(
        fontFamily: AppKeys.inter,
        fontSize: fontSize10,
        fontWeight: FontWeight.w500,
        color: AppColors.offWhite,
      ),
      child: GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: widget.text));
          _tooltipKey.currentState?.ensureTooltipVisible();
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.only(left: 8.w, top: 2.h, bottom: 2.h),
          child: Icon(
            Icons.copy_rounded,
            size: 14.w,
            color: AppColors.greyIconColor,
          ),
        ),
      ),
    );
  }
}

class _UpgradeRequiredView extends StatelessWidget {
  const _UpgradeRequiredView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacerSize24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.w,
              height: 88.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightGreen,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greenColor.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.workspace_premium_rounded,
                size: 42.w,
                color: AppColors.greenColor,
              ),
            ),
            SizedBox(height: 20.h),
            BaseText(
              text: message,
              fontSize: fontSize14,
              fontFamily: AppKeys.inter,
              fontWeight: FontWeight.w400,
              textColor: AppColors.charcoalGrey,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryLoadingView extends StatelessWidget {
  const _HistoryLoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28.w,
            height: 28.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: AppColors.greenColor,
            ),
          ),
          SizedBox(height: 12.h),
          BaseText(
            text: AppLocalizations.of(context)!.loadingConversation,
            fontSize: fontSize12,
            fontFamily: AppKeys.inter,
            fontWeight: FontWeight.w400,
            textColor: AppColors.liteGreyColor,
          ),
        ],
      ),
    );
  }
}

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14.w,
              height: 14.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.greenColor,
              ),
            ),
            SizedBox(width: 8.w),
            BaseText(
              text: AppLocalizations.of(context)!.loadingEarlierMessages,
              fontSize: fontSize11,
              fontFamily: AppKeys.inter,
              fontWeight: FontWeight.w400,
              textColor: AppColors.liteGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingDots extends StatelessWidget {
  const _TypingDots();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 52.w,
        height: 18.h,
        child: SpinKitThreeBounce(
          color: AppColors.greenColor,
          size: 12.w,
        ),
      ),
    );
  }
}

class _FadeSlideIn extends StatelessWidget {
  const _FadeSlideIn({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }
}

class _MessageImage extends StatelessWidget {
  const _MessageImage({required this.message});

  final ChatMessage message;
  static double get previewWidth => Get.width * 0.55;

  @override
  Widget build(BuildContext context) {
    final width = previewWidth;
    final height = 168.h;
    final previewUrl = message.hasLocalImage ? message.imagePath! : message.imageUrl!;
    final heroTag = 'chat_image_${message.id}';

    Widget image;
    if (message.hasLocalImage) {
      image = Image.file(
        File(message.imagePath!),
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: message.imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, _) => SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: SpinKitThreeBounce(color: AppColors.greenColor, size: 12),
          ),
        ),
        errorWidget: (_, _, _) => SizedBox(
          width: width,
          height: height,
          child: Icon(Icons.broken_image_outlined, color: AppColors.greyIconColor, size: 28.w),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FullScreenImageView.open(imageUrl: previewUrl, heroTag: heroTag),
      child: Hero(
        tag: heroTag,
        child: image,
      ),
    );
  }
}

class _ChatComposer extends StatelessWidget {
  const _ChatComposer({
    required this.textController,
    required this.selectedImage,
    required this.canSend,
    required this.hintText,
    required this.onChanged,
    required this.onAddImage,
    required this.onRemoveImage,
    required this.onSend,
  });

  final TextEditingController textController;
  final File? selectedImage;
  final bool canSend;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onAddImage;
  final VoidCallback onRemoveImage;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 12.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(color: AppColors.whiteColor),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greenColor.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedImage != null) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 8.h),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.file(
                            selectedImage!,
                            width: 72.w,
                            height: 72.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -6.w,
                          right: -6.w,
                          child: GestureDetector(
                            onTap: onRemoveImage,
                            child: Container(
                              width: 22.w,
                              height: 22.w,
                              decoration: BoxDecoration(
                                gradient: AppColors.linearGradientForBtn,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.whiteColor, width: 1.5),
                              ),
                              child: Icon(Icons.close, size: 12.w, color: AppColors.whiteColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CommonClickWidget(
                      onTap: onAddImage,
                      child: Container(
                        width: 42.w,
                        height: 42.w,
                        decoration: const BoxDecoration(
                          color: AppColors.lightGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          color: AppColors.greenColor,
                          size: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        onChanged: onChanged,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) {
                          if (canSend) onSend();
                        },
                        style: TextStyle(
                          fontFamily: AppKeys.inter,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blackColor,
                        ),
                        cursorColor: AppColors.greenColor,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: hintText,
                          hintStyle: TextStyle(
                            fontFamily: AppKeys.inter,
                            fontSize: fontSize14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyIconColor,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 11.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: canSend ? onSend : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: 42.w,
                        height: 42.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: canSend ? AppColors.linearGradientForBtn : null,
                          color: canSend ? null : AppColors.borderLiteGreyColor,
                          boxShadow: canSend
                              ? [
                                  BoxShadow(
                                    color: AppColors.greenColor.withValues(alpha: 0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          Icons.send_rounded,
                          color: canSend ? AppColors.whiteColor : AppColors.greyIconColor,
                          size: 18.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
