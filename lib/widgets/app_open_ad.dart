import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdWidget extends StatefulWidget {
  final String adUnitId;
  final VoidCallback? onAdShown;

  const AppOpenAdWidget({
    super.key,
    required this.adUnitId,
    this.onAdShown,
  });

  @override
  AppOpenAdWidgetState createState() => AppOpenAdWidgetState();

  void showAd() {
    final state = createState();
    if (state.mounted) state.showAd();
  }
}

class AppOpenAdWidgetState extends State<AppOpenAdWidget> {
  AppOpenAd? _appOpenAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAppOpenAd();
  }

  void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _appOpenAd = ad;
            _isAdLoaded = true;
          });
          _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadAppOpenAd(); // Preload next ad
              if (widget.onAdShown != null) widget.onAdShown!();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('AppOpenAd failed to show: $error');
              ad.dispose();
              _loadAppOpenAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
          setState(() => _isAdLoaded = false);
        },
      ),
    );
  }

  void showAd() {
    if (_isAdLoaded && _appOpenAd != null) {
      _appOpenAd!.show();
    } else {
      debugPrint('AppOpenAd not loaded yet');
      _loadAppOpenAd(); // Retry loading if not ready
    }
  }

  @override
  void dispose() {
    _appOpenAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // No visible UI
  }
}