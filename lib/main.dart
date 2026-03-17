import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'core/config/env_config.dart';
import 'package:cliceat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cliceat_app/features/client/cart/presentation/bloc/cart_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/di/injection.dart';
import 'core/data/local/database.dart';
import 'core/services/notification_service.dart';
import 'core/services/deep_link_service.dart';

void main() {
  runZonedGuarded(_bootstrap, (error, stack) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
  });
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Set Mapbox Token — crash early with a clear message if the token is missing
  final mapboxToken = EnvConfig.mapboxAccessToken;
  assert(
    mapboxToken.isNotEmpty,
    'MAPBOX_ACCESS_TOKEN is missing in .env — map features will not work.',
  );
  MapboxOptions.setAccessToken(mapboxToken);

  await EasyLocalization.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Crashlytics
  if (!kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Dependency Injection
  configureDependencies();

  // Initialize push notifications
  getIt<NotificationService>().configureRouting(rootNavigatorKey);
  await getIt<NotificationService>().initialize();

  // Initialize deep links — must run after the router is set up so the
  // navigator key is wired before any incoming link is handled.
  getIt<DeepLinkService>().initialize(rootNavigatorKey);

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
          create: (_) => CartCubit(getIt<AppDatabase>()),
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
      ),
    );
  }
}
