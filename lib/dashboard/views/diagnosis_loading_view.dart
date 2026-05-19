import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

// ---------------------------------------------------------------------------
// Progressive analysis stages shown while the API call is in flight.
// ---------------------------------------------------------------------------
class _AnalysisStage {
  final String message;
  final IconData icon;
  final Color accentColor;

  const _AnalysisStage({
    required this.message,
    required this.icon,
    required this.accentColor,
  });
}

const List<_AnalysisStage> _stages = [
  _AnalysisStage(
    message: 'Uploading image...',
    icon: Icons.cloud_upload_rounded,
    accentColor: Color(0xFF52B788),
  ),
  _AnalysisStage(
    message: 'Analyzing plant...',
    icon: Icons.biotech_rounded,
    accentColor: Color(0xFF2D6A4F),
  ),
  _AnalysisStage(
    message: 'Identifying plant species...',
    icon: Icons.search_rounded,
    accentColor: Color(0xFF01AF55),
  ),
  _AnalysisStage(
    message: 'Generating care recommendations...',
    icon: Icons.spa_rounded,
    accentColor: Color(0xFF95D5B2),
  ),
  _AnalysisStage(
    message: 'Preparing results...',
    icon: Icons.auto_awesome_rounded,
    accentColor: Color(0xFF52B788),
  ),
];

// ---------------------------------------------------------------------------
// DiagnosisLoadingView
// ---------------------------------------------------------------------------
class DiagnosisLoadingView extends StatefulWidget {
  final File? imageFile;

  /// Set to [true] by the parent when the API call has finished.
  /// The view will then fast-forward the remaining stages and call [onComplete].
  final bool isApiComplete;

  /// Called once all stages reach 100 % and the transition is ready.
  final VoidCallback? onComplete;

  const DiagnosisLoadingView({
    super.key,
    this.imageFile,
    this.isApiComplete = false,
    this.onComplete,
  });

  @override
  State<DiagnosisLoadingView> createState() => _DiagnosisLoadingViewState();
}

class _DiagnosisLoadingViewState extends State<DiagnosisLoadingView>
    with TickerProviderStateMixin {
  // Stage cycling
  int _currentStageIndex = 0;

  /// True once we have started the fast-forward sequence (API returned early).
  bool _isFastForwarding = false;

  // Controllers
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _stageTransitionController;
  late AnimationController _particleController;
  late AnimationController _scanlineController;

  // Animations
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _scanlineAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startStageCycling();
    // Handle the edge-case where isApiComplete is already true on first build.
    if (widget.isApiComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _beginFastForward());
    }
  }

  @override
  void didUpdateWidget(DiagnosisLoadingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // React the first time the parent flips isApiComplete to true.
    if (!oldWidget.isApiComplete &&
        widget.isApiComplete &&
        !_isFastForwarding) {
      _beginFastForward();
    }
  }

  void _setupAnimations() {
    // Overall progress bar (fills as stages advance)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    );

    // Pulse for the icon ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Fade for stage label transitions
    _stageTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _stageTransitionController,
      curve: Curves.easeIn,
    );

    // Particle float
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _particleAnimation = CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    );

    // Scan-line over the image
    _scanlineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _scanlineAnimation = CurvedAnimation(
      parent: _scanlineController,
      curve: Curves.easeInOut,
    );

    _stageTransitionController.value = 1.0; // start fully visible
    _updateProgress();
  }

  void _updateProgress() {
    final targetProgress = (_currentStageIndex + 1) / _stages.length;
    _progressAnimation =
        Tween<double>(
          begin: _progressAnimation.value,
          end: targetProgress,
        ).animate(
          CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
        );
    _progressController
      ..reset()
      ..forward();
  }

  void _startStageCycling() {
    _advanceStageAfter(const Duration(seconds: 2));
  }

  void _advanceStageAfter(Duration delay) {
    Future.delayed(delay, () {
      if (!mounted || _isFastForwarding) return;
      if (_currentStageIndex < _stages.length - 1) {
        _stageTransitionController.reverse().then((_) {
          if (!mounted || _isFastForwarding) return;
          setState(() => _currentStageIndex++);
          _updateProgress();
          _stageTransitionController.forward();
          _advanceStageAfter(const Duration(seconds: 2));
        });
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Fast-forward: rapidly cycle through remaining stages then call onComplete.
  // ---------------------------------------------------------------------------
  void _beginFastForward() {
    if (!mounted || _isFastForwarding) return;
    setState(() => _isFastForwarding = true);
    _fastForwardNext();
  }

  void _fastForwardNext() {
    if (!mounted) return;

    if (_currentStageIndex < _stages.length - 1) {
      // Advance one stage every 300 ms until we reach the last one.
      _stageTransitionController.reverse().then((_) {
        if (!mounted) return;
        setState(() => _currentStageIndex++);
        _updateProgress();
        _stageTransitionController.forward().then((_) {
          Future.delayed(const Duration(milliseconds: 300), _fastForwardNext);
        });
      });
    } else {
      // We are already on the last stage.
      // _updateProgress() was called when we advanced here and it already
      // animates the bar to 1.0. Do NOT reset/re-run — just wait for that
      // animation to finish, then hand off to the caller.
      void _callComplete() {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted) widget.onComplete?.call();
        });
      }

      if (_progressController.isAnimating) {
        _progressController.forward().whenComplete(_callComplete);
      } else {
        _callComplete();
      }
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _stageTransitionController.dispose();
    _particleController.dispose();
    _scanlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stage = _stages[_currentStageIndex];
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.54;

    return Container(
      color: AppColors.appColor,
      child: Stack(
        children: [
          Column(
            children: [
              // ── IMAGE WITH SCAN OVERLAY ──────────────────────────────────────
              _ImageScanSection(
                imageFile: widget.imageFile,
                imageHeight: imageHeight,
                scanlineAnimation: _scanlineAnimation,
                accentColor: stage.accentColor,
              ),

              // ── STAGE INFO CARD ──────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    children: [
                      // Stage dots
                      _StageDots(
                        total: _stages.length,
                        current: _currentStageIndex,
                        accentColor: stage.accentColor,
                      ),
                      SizedBox(height: 20.h),

                      // Animated icon + label
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _StageIconBadge(
                          icon: stage.icon,
                          accentColor: stage.accentColor,
                          pulseAnimation: _pulseAnimation,
                          particleAnimation: _particleAnimation,
                        ),
                      ),
                      SizedBox(height: 18.h),

                      // Stage message
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _StageLabel(
                          message: stage.message,
                          accentColor: stage.accentColor,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Progress bar
                      _ProgressBar(
                        progressAnimation: _progressAnimation,
                        accentColor: stage.accentColor,
                      ),
                      SizedBox(height: 8.h),
                      _ProgressText(
                        stageIndex: _currentStageIndex,
                        total: _stages.length,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── BACK BUTTON ──────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: spacerSize10,
                top: spacerSize16,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.black38,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Image + scan line section
// ---------------------------------------------------------------------------
class _ImageScanSection extends StatelessWidget {
  final File? imageFile;
  final double imageHeight;
  final Animation<double> scanlineAnimation;
  final Color accentColor;

  const _ImageScanSection({
    required this.imageFile,
    required this.imageHeight,
    required this.scanlineAnimation,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Plant image
          if (imageFile != null && imageFile!.path.isNotEmpty)
            Image.file(
              imageFile!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _PlaceholderImage(),
            )
          else
            _PlaceholderImage(),

          // Gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: imageHeight * 0.4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.appColor.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),

          // Scan line
          AnimatedBuilder(
            animation: scanlineAnimation,
            builder: (_, __) {
              final top = scanlineAnimation.value * imageHeight;
              return Positioned(
                top: top.clamp(0, imageHeight - 3),
                left: 0,
                right: 0,
                child: Container(
                  height: 2.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        accentColor.withValues(alpha: 0.9),
                        accentColor,
                        accentColor.withValues(alpha: 0.9),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Corner brackets (viewfinder feel)
          ..._buildCornerBrackets(accentColor),

          // "Analyzing" badge top-right
          Positioned(
            top: 30.h,
            right: 14.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BlinkingDot(color: Colors.white),
                  SizedBox(width: 5.w),
                  Text(
                    'Analyzing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCornerBrackets(Color color) {
    const size = 22.0;
    const thickness = 2.5;
    return [
      // Top-left
      Positioned(
        top: 14,
        left: 14,
        child: _CornerBracket(
          color: color,
          size: size,
          thickness: thickness,
          top: true,
          left: true,
        ),
      ),
      // Top-right
      Positioned(
        top: 14,
        right: 14,
        child: _CornerBracket(
          color: color,
          size: size,
          thickness: thickness,
          top: true,
          left: false,
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: 14,
        left: 14,
        child: _CornerBracket(
          color: color,
          size: size,
          thickness: thickness,
          top: false,
          left: true,
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: 14,
        right: 14,
        child: _CornerBracket(
          color: color,
          size: size,
          thickness: thickness,
          top: false,
          left: false,
        ),
      ),
    ];
  }
}

// ---------------------------------------------------------------------------
// Corner bracket widget
// ---------------------------------------------------------------------------
class _CornerBracket extends StatelessWidget {
  final Color color;
  final double size;
  final double thickness;
  final bool top;
  final bool left;

  const _CornerBracket({
    required this.color,
    required this.size,
    required this.thickness,
    required this.top,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CornerBracketPainter(
        color: color,
        thickness: thickness,
        top: top,
        left: left,
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool top;
  final bool left;

  _CornerBracketPainter({
    required this.color,
    required this.thickness,
    required this.top,
    required this.left,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double halfLen = size.width * 0.6;

    // Horizontal arm
    final double hx1 = left ? 0 : size.width;
    final double hx2 = left ? halfLen : size.width - halfLen;
    final double hy = top ? 0 : size.height;
    canvas.drawLine(Offset(hx1, hy), Offset(hx2, hy), paint);

    // Vertical arm
    final double vx = left ? 0 : size.width;
    final double vy1 = top ? 0 : size.height;
    final double vy2 = top ? halfLen : size.height - halfLen;
    canvas.drawLine(Offset(vx, vy1), Offset(vx, vy2), paint);
  }

  @override
  bool shouldRepaint(_CornerBracketPainter oldDelegate) =>
      oldDelegate.color != color;
}

// ---------------------------------------------------------------------------
// Stage dots
// ---------------------------------------------------------------------------
class _StageDots extends StatelessWidget {
  final int total;
  final int current;
  final Color accentColor;

  const _StageDots({
    required this.total,
    required this.current,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final bool isActive = i == current;
        final bool isPast = i < current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isPast
                ? accentColor.withValues(alpha: 0.5)
                : isActive
                ? accentColor
                : AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Animated icon with pulsing ring + floating particles
// ---------------------------------------------------------------------------
class _StageIconBadge extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final Animation<double> pulseAnimation;
  final Animation<double> particleAnimation;

  const _StageIconBadge({
    required this.icon,
    required this.accentColor,
    required this.pulseAnimation,
    required this.particleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110.w,
      height: 110.w,
      child: AnimatedBuilder(
        animation: Listenable.merge([pulseAnimation, particleAnimation]),
        builder: (_, __) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulsing ring
              Transform.scale(
                scale: pulseAnimation.value,
                child: Container(
                  width: 110.w,
                  height: 110.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.25),
                      width: 2,
                    ),
                    color: accentColor.withValues(alpha: 0.08),
                  ),
                ),
              ),

              // Middle ring
              Container(
                width: 84.w,
                height: 84.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.45),
                    width: 1.5,
                  ),
                  color: accentColor.withValues(alpha: 0.12),
                ),
              ),

              // Inner filled circle
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [accentColor, accentColor.withValues(alpha: 0.75)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 28.w),
              ),

              // Floating particles
              ..._buildParticles(accentColor),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildParticles(Color color) {
    final t = particleAnimation.value;
    final particles = <Widget>[];
    final offsets = [
      Offset(-48, -20),
      Offset(50, -28),
      Offset(-52, 22),
      Offset(48, 26),
      Offset(0, -55),
      Offset(0, 55),
    ];

    for (int i = 0; i < offsets.length; i++) {
      final phase = (t + i / offsets.length) % 1.0;
      final opacity = (math.sin(phase * math.pi)).clamp(0.0, 1.0);
      final scale = 0.5 + phase * 0.5;
      particles.add(
        Transform.translate(
          offset: offsets[i] * scale,
          child: Opacity(
            opacity: opacity * 0.6,
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ),
        ),
      );
    }
    return particles;
  }
}

// ---------------------------------------------------------------------------
// Stage message label
// ---------------------------------------------------------------------------
class _StageLabel extends StatelessWidget {
  final String message;
  final Color accentColor;

  const _StageLabel({required this.message, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Please wait while we process your plant image',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.mediumGrey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Progress bar
// ---------------------------------------------------------------------------
class _ProgressBar extends StatelessWidget {
  final Animation<double> progressAnimation;
  final Color accentColor;

  const _ProgressBar({
    required this.progressAnimation,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progressAnimation,
      builder: (_, __) {
        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progressAnimation.value,
                minHeight: 7.h,
                backgroundColor: AppColors.backgroundGrey,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Progress text
// ---------------------------------------------------------------------------
class _ProgressText extends StatelessWidget {
  final int stageIndex;
  final int total;

  const _ProgressText({required this.stageIndex, required this.total});

  @override
  Widget build(BuildContext context) {
    final percent = (((stageIndex + 1) / total) * 100).round();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Step ${stageIndex + 1} of $total',
          style: TextStyle(fontSize: 11.sp, color: AppColors.mediumGrey),
        ),
        Text(
          '$percent%',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.greenColor,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Blinking dot (used in "Analyzing" badge)
// ---------------------------------------------------------------------------
class _BlinkingDot extends StatefulWidget {
  final Color color;
  const _BlinkingDot({required this.color});

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Placeholder when no image is available
// ---------------------------------------------------------------------------
class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundGrey,
      child: Center(
        child: Icon(
          Icons.eco_rounded,
          size: 64,
          color: AppColors.greenColor.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
