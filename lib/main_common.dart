import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'core/config/app_constants.dart';
import 'core/config/flavor_config.dart';
import 'core/di/injection.dart';
import 'routes/app_router.dart';
import 'core/services/deep_link_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/presentation/bloc/theme_cubit.dart';
import 'core/widgets/connectivity_banner.dart';
import 'core/services/sync_manager_service.dart';
import 'core/services/precache_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cliceat_app/core/config/presentation/bloc/config_bloc.dart';
import 'package:cliceat_app/features/client/profile/presentation/bloc/profile_cubit.dart';
import 'package:cliceat_app/features/client/cart/presentation/bloc/cart_cubit.dart';
import 'firebase_options.dart';
import 'core/config/env_config.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  debugPrint('🚀 Starting bootstrap...');
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppConstants.appVersion = packageInfo.version;
  } catch (e) {
    debugPrint('⚠️ Failed to load PackageInfo: $e');
  }
  debugPrint(
    '✅ Flutter Binding Initialized (App Version: ${AppConstants.appVersion})',
  );

  // Limiter le cache image (appareils bas de gamme)
  PaintingBinding.instance.imageCache
    ..maximumSize = AppConstants.imageCacheMaxCount
    ..maximumSizeBytes = AppConstants.imageCacheMaxSizeBytes;

  // Mapbox token (injecté via --dart-define=MAPBOX_ACCESS_TOKEN=...)
  final mapboxToken = FlavorConfig.mapboxToken;
  debugPrint('📍 Mapbox Token length: ${mapboxToken.length}');

  if (mapboxToken.isNotEmpty) {
    MapboxOptions.setAccessToken(mapboxToken);
  }

  debugPrint('🌍 Initializing EasyLocalization...');
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('fr', null);
  await initializeDateFormatting('en', null);
  await initializeDateFormatting('fr_FR', null);
  await initializeDateFormatting('en_US', null);
  debugPrint('✅ EasyLocalization and Date Formatting Initialized');

  debugPrint('🔥 Initializing Firebase...');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('✅ Firebase Initialized');

  if (!kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  debugPrint('💉 Configuring Dependencies...');
  await configureDependencies();
  debugPrint('✅ Dependencies Configured');

  getIt<NotificationService>().configureRouting(rootNavigatorKey);
  debugPrint('🔔 Initializing NotificationService...');
  await getIt<NotificationService>().initialize();
  debugPrint('✅ NotificationService Initialized');

  getIt<DeepLinkService>().initialize(rootNavigatorKey);

  // Initialisation des services offline et cache
  debugPrint('🔄 Initializing SyncManagerService...');
  getIt<SyncManagerService>().initialize();
  debugPrint('🖼️ Starting Precaching...');
  getIt<PrecacheService>().startPrecaching();

  debugPrint('⚙️ Fetching Platform Config...');
  await getIt<ConfigBloc>().stream
      .firstWhere(
        (state) => state.maybeWhen(
          loaded: (_) => true,
          error: (_) => true,
          orElse: () => false,
        ),
      )
      .timeout(
        const Duration(seconds: 5),
        onTimeout: () => const ConfigState.error('timeout'),
      );
  // Note: We don't block everything if config fails, but it's better to have it.

  debugPrint('🏁 Bootstrap finished. Running App...');

  // ─── Certificate Pinning (Sécurité) ───────────────────────────────────────
  // Validation du certificat SHA-256 aux lancements (Anti MITM)
  if (FlavorConfig.isProd && EnvConfig.sslFingerprint.isNotEmpty) {
    try {
      final secureResult = await HttpCertificatePinning.check(
        serverURL: FlavorConfig.apiBaseUrl.split(
          '/api',
        )[0], // Extract domain e.g., https://api.cliceat.cm
        headerHttp: {},
        sha: SHA.SHA256,
        allowedSHAFingerprints: [EnvConfig.sslFingerprint],
        timeout: 20,
      );
      if (kDebugMode) print('Cert Pinning OK: $secureResult');
    } catch (e, stack) {
      if (!kDebugMode) {
        FirebaseCrashlytics.instance.recordError(
          e,
          stack,
          fatal: true,
          reason: 'Certificate Pinning Failed',
        );
        // BLOQUER l'app — ne pas continuer avec un certificat invalide
        runApp(
          MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.security, size: 64, color: Colors.red),
                      const SizedBox(height: 24),
                      const Text(
                        'Connexion sécurisée impossible',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Une anomalie de sécurité a été détectée. Fermez l\'application et reconnectez-vous à un réseau de confiance.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        return; // Ne pas appeler runApp(ClicEatApp()) après
      }
      debugPrint('🚨 ALERTE SÉCURITÉ : MITM DÉTECTÉ OU CERTIFICAT INVALIDE 🚨');
    }
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: const Locale('fr', 'FR'),
      child: const ClicEatApp(),
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
          create: (_) => getIt<AuthBloc>()..add(const AuthEvent.appStarted()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<ConfigBloc>()..add(const ConfigEvent.fetchConfig()),
        ),
        BlocProvider(create: (_) => getIt<CartCubit>()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()..loadProfile()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeWhen(
                authenticated: (token, userId, currentMode) {
                  context.read<ProfileCubit>().loadProfile();
                },
                unauthenticated: () {
                  context.read<ProfileCubit>().clear();
                  context.read<CartCubit>().clearCart();
                },
                orElse: () {},
              );
            },
            child: MaterialApp.router(
              title: 'ClicEat',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode,
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                Widget widget = child!;
                // Bannière de flavor en overlay (dev/staging uniquement)
                if (!FlavorConfig.isProd) {
                  widget = Banner(
                    message: FlavorConfig.name,
                    location: BannerLocation.topEnd,
                    color: FlavorConfig.isDev ? Colors.red : Colors.orange,
                    child: widget,
                  );
                }
                // Bannière de connectivité (offline)
                return ConnectivityBanner(child: widget);
              },
            ),
          );
        },
      ),
    );
  }
}
