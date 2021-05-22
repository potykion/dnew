import 'package:dnew/logic/ads/controllers.dart';
import 'package:dnew/logic/ads/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdCard extends HookWidget {
  final AdMarker adMarker;

  const AdCard({Key? key, required this.adMarker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BannerAd? ad = useProvider(adProvider(adMarker));
    return ad != null
        ? Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
              height: 60,
              child: AdWidget(ad: ad),
            ),
        )
        : Container();
  }
}
