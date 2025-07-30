import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern Energy-focused Color Palette
  static const Color primaryColor = Color(0xFF059669); // Emerald-600 - represents energy, sustainability
  static const Color primaryLight = Color(0xFF10B981); // Emerald-500
  static const Color primaryDark = Color(0xFF047857); // Emerald-700
  
  static const Color secondaryColor = Color(0xFFF59E0B); // Amber-500 - energy, warmth
  static const Color secondaryLight = Color(0xFFFBBF24); // Amber-400
  static const Color secondaryDark = Color(0xFFD97706); // Amber-600
  
  // Status Colors
  static const Color successColor = Color(0xFF10B981); // Emerald-500
  static const Color errorColor = Color(0xFFEF4444); // Red-500
  static const Color warningColor = Color(0xFFF59E0B); // Amber-500
  static const Color infoColor = Color(0xFF3B82F6); // Blue-500
  
  // Neutral Colors
  static const Color backgroundColor = Color(0xFFF8FAFC); // Slate-50 - cleaner background
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Slate-100
  static const Color textPrimary = Color(0xFF0F172A); // Slate-900
  static const Color textSecondary = Color(0xFF64748B); // Slate-500
  static const Color textTertiary = Color(0xFF94A3B8); // Slate-400
  static const Color dividerColor = Color(0xFFE2E8F0); // Slate-200
  static const Color borderColor = Color(0xFFCBD5E1); // Slate-300
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      primaryContainer: primaryLight,
      secondary: secondaryColor,
      secondaryContainer: secondaryLight,
      tertiary: infoColor,
      error: errorColor,
      surface: surfaceColor,
      surfaceContainerHighest: surfaceVariant,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onSurface: textPrimary,
      outline: borderColor,
    ),
    
    // Enhanced AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: surfaceColor,
      foregroundColor: textPrimary,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    ),
    
    // Enhanced Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.white.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return Colors.white.withValues(alpha: 0.05);
            }
            return null;
          },
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
    ),
    
    // Enhanced Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.inter(
        color: textTertiary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // Enhanced Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: dividerColor),
      ),
      color: surfaceColor,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
    ),
    
    // Enhanced Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: surfaceVariant,
      selectedColor: primaryLight.withValues(alpha: 0.2),
      labelStyle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.transparent),
      ),
    ),
    
    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      iconColor: textSecondary,
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // Tab Bar Theme
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: textSecondary,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
        borderSide: const BorderSide(color: primaryColor, width: 3),
        borderRadius: BorderRadius.circular(3),
      ),
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 1,
    ),
    
    // Dialog Theme
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 16,
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // Text Theme
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: textPrimary,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: textPrimary,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: textPrimary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: textSecondary,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: textPrimary,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: textPrimary,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: textSecondary,
      ),
    ),
  );
  
  // Helper method for status colors
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'online':
      case 'connected':
      case 'success':
        return successColor;
      case 'warning':
      case 'pending':
        return warningColor;
      case 'error':
      case 'offline':
      case 'disconnected':
      case 'failed':
        return errorColor;
      default:
        return textSecondary;
    }
  }
  
  // Helper method for meter type colors
  static Color getMeterTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'single_phase':
        return primaryColor;
      case 'three_phase':
        return secondaryColor;
      case 'ct_operated':
        return infoColor;
      default:
        return textSecondary;
    }
  }
}