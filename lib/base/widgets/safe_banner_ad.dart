import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// [AdWidget] can only be inserted once per [BannerAd]. GetX rebuilds/remounts
/// (Obx / GetWidget cache) otherwise create a second AdWidget and crash.
class SafeBannerAd extends StatefulWidget {
  const SafeBannerAd({super.key, required this.ad});

  final BannerAd ad;

  static final Set<int> _attachedAdIds = <int>{};

  @override
  State<SafeBannerAd> createState() => _SafeBannerAdState();
}

class _SafeBannerAdState extends State<SafeBannerAd> {
  AdWidget? _adWidget;
  int? _attachedId;

  @override
  void initState() {
    super.initState();
    _attach(widget.ad);
  }

  @override
  void didUpdateWidget(SafeBannerAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.ad, widget.ad)) {
      _detach();
      _attach(widget.ad);
    }
  }

  void _attach(BannerAd ad) {
    final id = identityHashCode(ad);
    if (SafeBannerAd._attachedAdIds.contains(id)) {
      _adWidget = null;
      _attachedId = null;
      return;
    }
    SafeBannerAd._attachedAdIds.add(id);
    _attachedId = id;
    _adWidget = AdWidget(ad: ad);
  }

  void _detach() {
    if (_attachedId != null) {
      SafeBannerAd._attachedAdIds.remove(_attachedId);
      _attachedId = null;
    }
    _adWidget = null;
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.ad.size.width.toDouble(),
      height: widget.ad.size.height.toDouble(),
      child: _adWidget,
    );
  }
}
