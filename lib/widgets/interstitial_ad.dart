import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdWidget extends StatefulWidget {
  final String adUnitId;
  final VoidCallback? onAdShown;

  const InterstitialAdWidget({
    super.key,
    required this.adUnitId,
    this.onAdShown,
  });

  // Expose showAd method via State
  @override
  InterstitialAdWidgetState createState() => InterstitialAdWidgetState();

  void showAd() {
    final state = createState();
    if (state.mounted) state.showAd();
  }
}

class InterstitialAdWidgetState extends State<InterstitialAdWidget> {
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
          });
          _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd(); // Preload next ad
              if (widget.onAdShown != null) widget.onAdShown!();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Interstitial failed to show: $error');
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed to load: $error');
        },
      ),
    );
  }

  void showAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      debugPrint('Interstitial ad not loaded yet');
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // No visible UI
  }
}