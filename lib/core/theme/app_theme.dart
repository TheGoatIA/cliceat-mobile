import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Brand ───────────────────────────────────────────────────────────────
  static const Color primaryRed = Color(0xFFC41E1A);
  static const Color redDeep = Color(0xFF8F1410);
  static const Color redSoft = Color(0xFFFDEBE9);
  static const Color honey = Color(0xFFF5A623);
  static const Color honeyLight = Color(0xFFFFD88A);
  static const Color honeySoft = Color(0xFFFFF4E0);

  // ─── Surfaces ────────────────────────────────────────────────────────────
  static const Color bg = Color(0xFFFAF6F0);
  static const Color bgWarm = Color(0xFFF4EDE1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFFBF7F1);
  static const Color bgDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // ─── Text ────────────────────────────────────────────────────────────────
  static const Color ink = Color(0xFF1A1411);
  static const Color inkSoft = Color(0xFF4A3F38);
  static const Color muted = Color(0xFF8A7D72);
  static const Color mutedLight = Color(0xFFB8ACA1);
  static const Color line = Color(0xFFEAE0D2);
  static const Color lineSoft = Color(0xFFF2EADC);
  static const Color textDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // ─── Semantic ────────────────────────────────────────────────────────────
  static const Color green = Color(0xFF2F8A4E);
  static const Color greenSoft = Color(0xFFE3F2E8);
  static const Color orange = Color(0xFFE08A1E);
  static const Color blue = Color(0xFF2C5FD6);

  // ─── Legacy aliases (keeps existing code compiling) ──────────────────────
  static const Color accentYellow = honey;
  static const Color bgLight = bg;
  static const Color surfaceLight = surface;
  static const Color textLight = ink;
  static const Color textSecondaryLight = muted;
  static const Color errorColor = Color(0xFFDC2626);
  static const Color successColor = green;

  // ─── Status colours ──────────────────────────────────────────────────────
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusConfirmed = Color(0xFF3B82F6);
  static const Color statusPreparing = Color(0xFF8B5CF6);
  static const Color statusReady = Color(0xFF14B8A6);
  static const Color statusPickedUp = Color(0xFF6366F1);
  static const Color statusDelivered = green;
  static const Color statusCancelled = errorColor;
  static const Color statusAnomaly = Color(0xFFEA580C);
  static const Color statusEnRoute = Color(0xFF0284C7);
  static const Color statusDefault = Color(0xFF6B7280);
  static const Color statusOnline = green;
  static const Color statusOffline = Color(0xFF9CA3AF);

  // ─── Shadows ─────────────────────────────────────────────────────────────
  static List<BoxShadow> get shadowSm => const [
    BoxShadow(color: Color(0x0A1A1411), blurRadius: 6, offset: Offset(0, 2)),
  ];
  static List<BoxShadow> get shadowMd => const [
    BoxShadow(color: Color(0x0F1A1411), blurRadius: 12, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x0D1A1411), blurRadius: 32, offset: Offset(0, 12)),
  ];
  static List<BoxShadow> get shadowLg => const [
    BoxShadow(color: Color(0x141A1411), blurRadius: 24, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x141A1411), blurRadius: 48, offset: Offset(0, 24)),
  ];

  // ─── Typography helpers ───────────────────────────────────────────────────
  static TextStyle display(
    double size, {
    Color? color,
    FontWeight weight = FontWeight.w700,
  }) => GoogleFonts.bricolageGrotesque(
    fontSize: size,
    fontWeight: weight,
    letterSpacing: -0.4,
    color: color,
  );

  static TextStyle body(
    double size, {
    Color? color,
    FontWeight weight = FontWeight.w400,
  }) => GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color);

  // ─── Theme Extensions ───────────────────────────────────────────────────
  static AppColorsExtension colors(BuildContext context) =>
      Theme.of(context).extension<AppColorsExtension>()!;

  // ─── Light Theme ─────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      extensions: [
        AppColorsExtension(
          bg: bg,
          bgWarm: bgWarm,
          surface: surface,
          surfaceAlt: surfaceAlt,
          ink: ink,
          inkSoft: inkSoft,
          muted: muted,
          mutedLight: mutedLight,
          line: line,
          lineSoft: lineSoft,
        ),
      ],
      colorScheme: const ColorScheme.light(
        primary: primaryRed,
        secondary: honey,
        surface: surface,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: ink,
        onSurface: ink,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: bg,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.bricolageGrotesque(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: ink,
          letterSpacing: -0.8,
        ),
        displayMedium: GoogleFonts.bricolageGrotesque(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: ink,
          letterSpacing: -0.6,
        ),
        displaySmall: GoogleFonts.bricolageGrotesque(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: ink,
          letterSpacing: -0.4,
        ),
        headlineMedium: GoogleFonts.bricolageGrotesque(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: ink,
          letterSpacing: -0.3,
        ),
        titleLarge: GoogleFonts.bricolageGrotesque(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: ink,
          letterSpacing: -0.2,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ink,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ink,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: muted,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryRed,
          side: const BorderSide(color: primaryRed, width: 1.5),
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ink, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: muted),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: muted),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shadowColor: const Color(0x0A1A1411),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: lineSoft),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryRed,
        unselectedItemColor: muted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerColor: lineSoft,
      dividerTheme: const DividerThemeData(color: lineSoft, thickness: 1),
    );
  }

  // ─── Dark Theme ──────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      extensions: [
        AppColorsExtension(
          bg: bgDark,
          bgWarm: const Color(0xFF1A1A1A),
          surface: surfaceDark,
          surfaceAlt: const Color(0xFF242424),
          ink: textDark,
          inkSoft: const Color(0xFFE5E7EB),
          muted: textSecondaryDark,
          mutedLight: const Color(0xFF4B5563),
          line: const Color(0xFF2D2D2D),
          lineSoft: const Color(0xFF262626),
        ),
      ],
      colorScheme: const ColorScheme.dark(
        primary: primaryRed,
        secondary: honey,
        surface: surfaceDark,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: bgDark,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.bricolageGrotesque(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: -0.8,
        ),
        displayMedium: GoogleFonts.bricolageGrotesque(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: -0.6,
        ),
        displaySmall: GoogleFonts.bricolageGrotesque(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: -0.4,
        ),
        headlineMedium: GoogleFonts.bricolageGrotesque(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: -0.3,
        ),
        titleLarge: GoogleFonts.bricolageGrotesque(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: -0.2,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondaryDark,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryRed,
          side: const BorderSide(color: primaryRed, width: 1.5),
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: textSecondaryDark),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: textSecondaryDark),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF2D2D2D)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primaryRed,
        unselectedItemColor: textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color bg;
  final Color bgWarm;
  final Color surface;
  final Color surfaceAlt;
  final Color ink;
  final Color inkSoft;
  final Color muted;
  final Color mutedLight;
  final Color line;
  final Color lineSoft;

  AppColorsExtension({
    required this.bg,
    required this.bgWarm,
    required this.surface,
    required this.surfaceAlt,
    required this.ink,
    required this.inkSoft,
    required this.muted,
    required this.mutedLight,
    required this.line,
    required this.lineSoft,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? bg,
    Color? bgWarm,
    Color? surface,
    Color? surfaceAlt,
    Color? ink,
    Color? inkSoft,
    Color? muted,
    Color? mutedLight,
    Color? line,
    Color? lineSoft,
  }) {
    return AppColorsExtension(
      bg: bg ?? this.bg,
      bgWarm: bgWarm ?? this.bgWarm,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      ink: ink ?? this.ink,
      inkSoft: inkSoft ?? this.inkSoft,
      muted: muted ?? this.muted,
      mutedLight: mutedLight ?? this.mutedLight,
      line: line ?? this.line,
      lineSoft: lineSoft ?? this.lineSoft,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      bg: Color.lerp(bg, other.bg, t)!,
      bgWarm: Color.lerp(bgWarm, other.bgWarm, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      mutedLight: Color.lerp(mutedLight, other.mutedLight, t)!,
      line: Color.lerp(line, other.line, t)!,
      lineSoft: Color.lerp(lineSoft, other.lineSoft, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppColorsExtension get colors => AppTheme.colors(this);
}
