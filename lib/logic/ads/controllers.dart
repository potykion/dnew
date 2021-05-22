import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Провайдер типа девайса - эмулик или реальный девайс
FutureProvider<bool> _isPhysicalDeviceProvider = FutureProvider(
  (_) async => (await DeviceInfoPlugin().androidInfo).isPhysicalDevice,
);

/// Провайдер инициализации рекламы
/// Вынесен в отдельный провайдер, потому что долго грузится
FutureProvider<InitializationStatus?> _adsInitializedProvider = FutureProvider(
  (ref) async {
    if (kIsWeb) return null;
    return MobileAds.instance.initialize();
  },
);

/// Провайдер BannerAd
/// Если девайс реальный, то использует боевой айди
var adProvider = Provider.family(
  (ref, __) => ref.watch(_adsInitializedProvider).maybeWhen(
        data: (status) => status != null
            ? ref.watch(_isPhysicalDeviceProvider).maybeWhen(
                  data: (isPhysicalDevice) => BannerAd(
                    adUnitId: isPhysicalDevice
                        ? "ca-app-pub-6011780463667583/4537743051"
                        : BannerAd.testAdUnitId,
                    size: AdSize.smartBanner,
                    request: AdRequest(),
                    listener: BannerAdListener(),
                  )..load(),
                  orElse: () => null,
                )
            : null,
        orElse: () => null,
      ),
);
