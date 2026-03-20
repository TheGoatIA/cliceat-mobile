import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'core/config/app_constants.dart';
import 'core/config/flavor_config.dart';
import 'di/injection.dart';
import 'routes/app_router.dart';
import 'core/services/deep_link_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/connectivity_banner.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/client/cart/presentation/bloc/cart_cubit.dart';
import 'firebase_options.dart';

/// Bootstrap commun à tous les flavors.
/// Appelé depuis [main_dev.dart], [main_staging.dart] et [main_prod.dart]
/// après que [FlavorConfig.initialize] a été appelé.
void mainCommon() {
  runZonedGuarded(_bootstrap, (error, stack) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
  });
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Limiter le cache image (appareils bas de gamme)
  PaintingBinding.instance.imageCache
    ..maximumSize = AppConstants.imageCacheMaxCount
    ..maximumSizeBytes = AppConstants.imageCacheMaxSizeBytes;

  // Mapbox token (injecté via --dart-define=MAPBOX_ACCESS_TOKEN=...)
  final mapboxToken = FlavorConfig.mapboxToken;
  assert(
    mapboxToken.isNotEmpty,
    '[${FlavorConfig.name}] MAPBOX_ACCESS_TOKEN manquant — la carte ne fonctionnera pas.',
  );
  if (mapboxToken.isNotEmpty) {
    MapboxOptions.setAccessToken(mapboxToken);
  }

  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kDebugMode) {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(true);
    FlutterError.onError =
        FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance
          .recordError(error, stack, fatal: true);
      return true;
    };
  }

  configureDependencies();

  getIt<NotificationService>().configureRouting(rootNavigatorKey);
  await getIt<NotificationService>().initialize();

  getIt<DeepLinkService>().initialize(rootNavigatorKey);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: const Locale('fr', 'FR'),
      child: const ConnectivityBanner(child: ClicEatApp()),
    ),
  );
}

class ClicEatApp extends StatelessWidget {
  const ClicEatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<AuthBloc>()..add(const AuthEvent.appStarted()),
        ),
        BlocProvider(
          create: (_) => getIt<CartCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'ClicEat',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
        // Bannière de flavor en overlay (dev/staging uniquement)
        builder: FlavorConfig.isProd
            ? null
            : (context, child) => Banner(
                  message: FlavorConfig.name,
                  location: BannerLocation.topEnd,
                  color: FlavorConfig.isDev ? Colors.red : Colors.orange,
                  child: child!,
                ),
      ),
    );
  }
}
