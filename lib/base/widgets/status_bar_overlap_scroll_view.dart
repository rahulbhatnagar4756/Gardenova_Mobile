import 'package:flutter/material.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class StatusBarOverlapScrollView extends StatefulWidget {
  final Widget child;
  final double cardTopOffset;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const StatusBarOverlapScrollView({
    super.key,
    required this.child,
    this.cardTopOffset = spacerSize300,
    this.physics,
    this.padding,
  });

  @override
  State<StatusBarOverlapScrollView> createState() =>
      _StatusBarOverlapScrollViewState();
}

class _StatusBarOverlapScrollViewState
    extends State<StatusBarOverlapScrollView> {
  final _scrollController = ScrollController();
  bool _overlapsStatusBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final statusBarHeight = MediaQuery.paddingOf(context).top;
    final overlaps =
        _scrollController.offset >= widget.cardTopOffset - statusBarHeight;
    if (overlaps != _overlapsStatusBar && mounted) {
      setState(() => _overlapsStatusBar = overlaps);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.paddingOf(context).top;

    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          physics: widget.physics,
          padding: widget.padding,
          child: widget.child,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: statusBarHeight,
          child: IgnorePointer(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: _overlapsStatusBar ? 1 : 0,
              child: const ColoredBox(color: AppColors.appColor),
            ),
          ),
        ),
      ],
    );
  }
}
