import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_type.dart';

export 'theme_type.dart';

part 'github_dark.dart';

class AppTheme {
  static const defaultType = ThemeType.githubDark;
  static final defaultTheme = AppTheme.fromType(defaultType);

  final ThemeType type;
  final bool isDark;

  // Primary colors
  final Color primaryColor;
  final Color primaryVariant;
  final Color onPrimary;
  final Color primaryDark;

  // Secondary colors
  final Color accentColor;
  final Color onAccent;

  // Background colors
  final Color background;
  final Color surface;
  final Color surfaceVariant;

  // Text colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;

  // UI element colors
  final Color divider;
  final Color toolbarColor;
  final Color error;
  final Color success;
  final Color warning;

  // Grid colors
  final Color gridLine;
  final Color gridBackground;

  // Canvas-related colors
  final Color canvasBackground;
  final Color selectionOutline;
  final Color selectionFill;

  // Icon colors
  final Color activeIcon;
  final Color inactiveIcon;

  // Font settings
  final TextTheme textTheme;
  final FontWeight primaryFontWeight;

  final Color surfaceContainerLow;
  final Color surfaceContainerHighest;

  final Color inputFillColor;
  final bool inputFilled;

  final ExtraThemeColors extraColors;
  final ExraTextStyles exraTextStyles;

  AppTheme({
    required this.type,
    required this.isDark,
    required this.primaryColor,
    required this.primaryVariant,
    required this.onPrimary,
    required this.primaryDark,
    required this.accentColor,
    required this.onAccent,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.divider,
    required this.toolbarColor,
    required this.error,
    required this.success,
    required this.warning,
    required this.gridLine,
    required this.gridBackground,
    required this.canvasBackground,
    required this.selectionOutline,
    required this.selectionFill,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.textTheme,
    required this.primaryFontWeight,
    required this.surfaceContainerLow,
    required this.surfaceContainerHighest,
    required this.extraColors,
    required this.exraTextStyles,
    required this.inputFillColor,
    this.inputFilled = true,
  });

  factory AppTheme.fromType(ThemeType type) {
    return switch (type) {
      ThemeType.githubDark => buildGithubDarkTheme(),
    };
  }

  AppTheme withBrandPrimary(Color brandPrimary) {
    final onBrandPrimary =
        ThemeData.estimateBrightnessForColor(brandPrimary) == Brightness.dark
        ? Colors.white
        : const Color(0xFF111827);
    final primaryDarkColor = _shiftLightness(brandPrimary, -0.18);
    final primaryVariantColor = _shiftLightness(brandPrimary, -0.12);
    final primarySubtleColor = Color.lerp(brandPrimary, Colors.white, 0.86)!;
    final highlightColor = Color.lerp(brandPrimary, Colors.white, 0.9)!;
    final navActiveBackgroundColor = Color.lerp(
      brandPrimary,
      Colors.white,
      0.88,
    )!;
    final gradientEndColor = _shiftLightness(brandPrimary, -0.06);

    return AppTheme(
      type: type,
      isDark: isDark,
      primaryColor: brandPrimary,
      primaryVariant: primaryVariantColor,
      onPrimary: onBrandPrimary,
      primaryDark: primaryDarkColor,
      accentColor: accentColor,
      onAccent: onAccent,
      background: background,
      surface: surface,
      surfaceVariant: surfaceVariant,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      textDisabled: textDisabled,
      divider: divider,
      toolbarColor: toolbarColor,
      error: error,
      success: success,
      warning: warning,
      gridLine: gridLine,
      gridBackground: gridBackground,
      canvasBackground: canvasBackground,
      selectionOutline: brandPrimary,
      selectionFill: brandPrimary.withValues(alpha: 0.12),
      activeIcon: activeIcon,
      inactiveIcon: inactiveIcon,
      textTheme: textTheme,
      primaryFontWeight: primaryFontWeight,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainerHighest: surfaceContainerHighest,
      inputFillColor: inputFillColor,
      inputFilled: inputFilled,
      extraColors:
          extraColors.copyWith(
                highlightColor: highlightColor,
                primarySubtle: primarySubtleColor,
                linkColor: brandPrimary,
                infoLight: primarySubtleColor,
                accentTeal: brandPrimary,
                inputFocusBorder: brandPrimary,
                navActiveIcon: brandPrimary,
                navActiveBackground: navActiveBackgroundColor,
                primaryGradientColors: [brandPrimary, gradientEndColor],
              )
              as ExtraThemeColors,
      exraTextStyles:
          exraTextStyles.copyWith(
                highlightedTextStyle: exraTextStyles.highlightedTextStyle
                    .copyWith(color: brandPrimary),
                linkTextStyle: exraTextStyles.linkTextStyle.copyWith(
                  color: brandPrimary,
                ),
                buttonTextStyle: exraTextStyles.buttonTextStyle.copyWith(
                  color: onBrandPrimary,
                ),
                tabActiveTextStyle: exraTextStyles.tabActiveTextStyle.copyWith(
                  color: brandPrimary,
                ),
                codeTextStyle: exraTextStyles.codeTextStyle.copyWith(
                  color: brandPrimary,
                ),
              )
              as ExraTextStyles,
    );
  }

  ThemeData get themeData {
    var t = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        onPrimary: onPrimary,
        secondary: accentColor,
        onSecondary: onAccent,
        error: error,
        onError: isDark ? Colors.black : Colors.white,
        surface: surface,
        surfaceContainerHighest: surfaceContainerHighest,
        surfaceContainerLow: surfaceContainerLow,
        onSurface: textPrimary,
      ),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      dividerColor: divider,
      dividerTheme: DividerThemeData(color: divider, thickness: 1),
      textTheme: textTheme,
      iconTheme: IconThemeData(color: activeIcon),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF00003D),
        centerTitle: true,
        elevation: 0,
        leadingWidth: 85,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: Color(0xFF00003D),
        ),
        // The bar is see-through: guessed from it, the status bar icons came out white on the light page
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) => Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Icon(Icons.arrow_back_ios_new, size: 14, color: textPrimary),
        ),
      ),
      dialogTheme: DialogThemeData(backgroundColor: surface),
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        textStyle: TextStyle(color: textPrimary),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(color: toolbarColor),
      cardTheme: CardThemeData(
        color: surface,
        shadowColor: isDark ? Colors.black54 : Colors.black12,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: inputFillColor,
        filled: inputFilled,
        hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        labelStyle: GoogleFonts.montserrat(color: textSecondary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: extraColors.inputBorder),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: extraColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: extraColors.inputBorder),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: onPrimary,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: onPrimary,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryColor.withValues(alpha: 0.3),
        thumbColor: primaryColor,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return isDark ? Colors.grey.shade800 : Colors.grey.shade200;
        }),
        checkColor: WidgetStateProperty.all(onPrimary),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return isDark ? Colors.grey.shade800 : Colors.grey.shade200;
        }),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return isDark ? Colors.grey.shade800 : Colors.grey.shade300;
        }),
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return onPrimary;
          }
          return isDark ? Colors.grey.shade200 : Colors.white;
        }),
      ),
      extensions: [extraColors, exraTextStyles],
    );

    return t;
  }

  Color shift(Color c, double amount) {
    amount *= (isDark ? -1 : 1);

    /// Convert to HSL
    var hslc = HSLColor.fromColor(c);

    /// Add/Remove lightness
    double lightness = (hslc.lightness + amount).clamp(0, 1.0).toDouble();

    /// Convert back to Color
    return hslc.withLightness(lightness).toColor();
  }

  Color _shiftLightness(Color color, double amount) {
    final hslColor = HSLColor.fromColor(color);
    final lightness = (hslColor.lightness + amount).clamp(0.0, 1.0);
    return hslColor.withLightness(lightness).toColor();
  }

  /// Text and icons drawn on a cargo colour: white on a dark or saturated one, ink on a light one
  /// (yellow, light green). The loading screen, the splash and the share cards use it.
  static Color onBrand(Color background) =>
      ThemeData.estimateBrightnessForColor(background) == Brightness.dark
      ? Colors.white
      : const Color(0xFF1F2430);

  static Color? parseHexColor(String? value) {
    if (value == null) return null;

    final normalized = value.trim().replaceAll('#', '');
    if (normalized.isEmpty) return null;

    final buffer = StringBuffer();
    if (normalized.length == 6) {
      buffer.write('FF');
      buffer.write(normalized);
    } else if (normalized.length == 8) {
      buffer.write(normalized);
    } else {
      return null;
    }

    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return null;
    }
  }
}

/// Extended theme colors for additional UI elements
class ExtraThemeColors extends ThemeExtension<ExtraThemeColors> {
  // Core extra colors
  final Color highlightColor;
  final Color shadowColor;
  final Color textSecondaryColor;

  // Subtle/Light variants
  final Color primarySubtle;
  final Color linkColor;
  final Color hintColor;
  final Color successLight;
  final Color errorLight;
  final Color warningLight;
  final Color infoLight;

  // Icon background colors
  final Color iconBgBlue;
  final Color iconBgOrange;
  final Color iconBgGreen;
  final Color iconBgYellow;
  final Color iconBgRed;
  final Color iconBgPurple;

  // Additional accent colors
  final Color accentOrange;
  final Color accentGreen;
  final Color accentPurple;
  final Color accentTeal;
  final Color accentYellow;

  // UI element colors
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color overlayDark;
  final Color overlayLight;
  final Color badgeBackground;
  final Color badgeText;
  final Color cardBorder;
  final Color inputBorder;
  final Color inputFocusBorder;
  final Color dividerLight;

  // Navigation colors
  final Color navActiveIcon;
  final Color navInactiveIcon;
  final Color navActiveBackground;

  final Color buttonSecondary;

  final List<Color> primaryGradientColors;

  ExtraThemeColors({
    required this.highlightColor,
    required this.shadowColor,
    required this.textSecondaryColor,
    required this.primarySubtle,
    required this.linkColor,
    required this.hintColor,
    required this.successLight,
    required this.errorLight,
    required this.warningLight,
    required this.infoLight,
    required this.iconBgBlue,
    required this.iconBgOrange,
    required this.iconBgGreen,
    required this.iconBgYellow,
    required this.iconBgRed,
    required this.iconBgPurple,
    required this.accentOrange,
    required this.accentGreen,
    required this.accentPurple,
    required this.accentTeal,
    required this.accentYellow,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.overlayDark,
    required this.overlayLight,
    required this.badgeBackground,
    required this.badgeText,
    required this.cardBorder,
    required this.inputBorder,
    required this.inputFocusBorder,
    required this.dividerLight,
    required this.navActiveIcon,
    required this.navInactiveIcon,
    required this.navActiveBackground,
    required this.primaryGradientColors,
    required this.buttonSecondary,
  });

  @override
  ThemeExtension<ExtraThemeColors> copyWith({
    Color? highlightColor,
    Color? shadowColor,
    Color? textSecondaryColor,
    Color? primarySubtle,
    Color? linkColor,
    Color? hintColor,
    Color? successLight,
    Color? errorLight,
    Color? warningLight,
    Color? infoLight,
    Color? iconBgBlue,
    Color? iconBgOrange,
    Color? iconBgGreen,
    Color? iconBgYellow,
    Color? iconBgRed,
    Color? iconBgPurple,
    Color? accentOrange,
    Color? accentGreen,
    Color? accentPurple,
    Color? accentTeal,
    Color? accentYellow,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? overlayDark,
    Color? overlayLight,
    Color? badgeBackground,
    Color? badgeText,
    Color? cardBorder,
    Color? inputBorder,
    Color? inputFocusBorder,
    Color? dividerLight,
    Color? navActiveIcon,
    Color? navInactiveIcon,
    Color? navActiveBackground,
    List<Color>? primaryGradientColors,
    Color? buttonSecondary,
  }) {
    return ExtraThemeColors(
      highlightColor: highlightColor ?? this.highlightColor,
      shadowColor: shadowColor ?? this.shadowColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      primarySubtle: primarySubtle ?? this.primarySubtle,
      linkColor: linkColor ?? this.linkColor,
      hintColor: hintColor ?? this.hintColor,
      successLight: successLight ?? this.successLight,
      errorLight: errorLight ?? this.errorLight,
      warningLight: warningLight ?? this.warningLight,
      infoLight: infoLight ?? this.infoLight,
      iconBgBlue: iconBgBlue ?? this.iconBgBlue,
      iconBgOrange: iconBgOrange ?? this.iconBgOrange,
      iconBgGreen: iconBgGreen ?? this.iconBgGreen,
      iconBgYellow: iconBgYellow ?? this.iconBgYellow,
      iconBgRed: iconBgRed ?? this.iconBgRed,
      iconBgPurple: iconBgPurple ?? this.iconBgPurple,
      accentOrange: accentOrange ?? this.accentOrange,
      accentGreen: accentGreen ?? this.accentGreen,
      accentPurple: accentPurple ?? this.accentPurple,
      accentTeal: accentTeal ?? this.accentTeal,
      accentYellow: accentYellow ?? this.accentYellow,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      overlayDark: overlayDark ?? this.overlayDark,
      overlayLight: overlayLight ?? this.overlayLight,
      badgeBackground: badgeBackground ?? this.badgeBackground,
      badgeText: badgeText ?? this.badgeText,
      cardBorder: cardBorder ?? this.cardBorder,
      inputBorder: inputBorder ?? this.inputBorder,
      inputFocusBorder: inputFocusBorder ?? this.inputFocusBorder,
      dividerLight: dividerLight ?? this.dividerLight,
      navActiveIcon: navActiveIcon ?? this.navActiveIcon,
      navInactiveIcon: navInactiveIcon ?? this.navInactiveIcon,
      navActiveBackground: navActiveBackground ?? this.navActiveBackground,
      primaryGradientColors:
          primaryGradientColors ?? this.primaryGradientColors,
      buttonSecondary: buttonSecondary ?? this.buttonSecondary,
    );
  }

  @override
  ThemeExtension<ExtraThemeColors> lerp(
    covariant ThemeExtension<ExtraThemeColors>? other,
    double t,
  ) {
    if (other is! ExtraThemeColors) {
      return this;
    }
    return ExtraThemeColors(
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      textSecondaryColor: Color.lerp(
        textSecondaryColor,
        other.textSecondaryColor,
        t,
      )!,
      primarySubtle: Color.lerp(primarySubtle, other.primarySubtle, t)!,
      linkColor: Color.lerp(linkColor, other.linkColor, t)!,
      hintColor: Color.lerp(hintColor, other.hintColor, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      infoLight: Color.lerp(infoLight, other.infoLight, t)!,
      iconBgBlue: Color.lerp(iconBgBlue, other.iconBgBlue, t)!,
      iconBgOrange: Color.lerp(iconBgOrange, other.iconBgOrange, t)!,
      iconBgGreen: Color.lerp(iconBgGreen, other.iconBgGreen, t)!,
      iconBgYellow: Color.lerp(iconBgYellow, other.iconBgYellow, t)!,
      iconBgRed: Color.lerp(iconBgRed, other.iconBgRed, t)!,
      iconBgPurple: Color.lerp(iconBgPurple, other.iconBgPurple, t)!,
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t)!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      accentPurple: Color.lerp(accentPurple, other.accentPurple, t)!,
      accentTeal: Color.lerp(accentTeal, other.accentTeal, t)!,
      accentYellow: Color.lerp(accentYellow, other.accentYellow, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
      overlayDark: Color.lerp(overlayDark, other.overlayDark, t)!,
      overlayLight: Color.lerp(overlayLight, other.overlayLight, t)!,
      badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t)!,
      badgeText: Color.lerp(badgeText, other.badgeText, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputFocusBorder: Color.lerp(
        inputFocusBorder,
        other.inputFocusBorder,
        t,
      )!,
      dividerLight: Color.lerp(dividerLight, other.dividerLight, t)!,
      navActiveIcon: Color.lerp(navActiveIcon, other.navActiveIcon, t)!,
      navInactiveIcon: Color.lerp(navInactiveIcon, other.navInactiveIcon, t)!,
      navActiveBackground: Color.lerp(
        navActiveBackground,
        other.navActiveBackground,
        t,
      )!,
      buttonSecondary: Color.lerp(buttonSecondary, other.buttonSecondary, t)!,
      primaryGradientColors: List<Color>.generate(
        primaryGradientColors.length,
        (index) => Color.lerp(
          primaryGradientColors[index],
          other.primaryGradientColors[index],
          t,
        )!,
      ),
    );
  }
}

/// Extended text styles for additional typography needs
class ExraTextStyles extends ThemeExtension<ExraTextStyles> {
  // Core extra styles
  final TextStyle highlightedTextStyle;
  final TextStyle digitTextStyle;

  // Link & Button styles
  final TextStyle linkTextStyle;
  final TextStyle buttonTextStyle;

  // Caption & Overline styles
  final TextStyle captionTextStyle;
  final TextStyle overlineTextStyle;

  // Card styles
  final TextStyle cardTitleTextStyle;
  final TextStyle cardSubtitleTextStyle;

  // Input styles
  final TextStyle inputTextStyle;
  final TextStyle inputLabelTextStyle;
  final TextStyle inputHintTextStyle;

  // Badge & Tab styles
  final TextStyle badgeTextStyle;
  final TextStyle tabActiveTextStyle;
  final TextStyle tabInactiveTextStyle;

  // Section & Price styles
  final TextStyle sectionHeaderTextStyle;
  final TextStyle priceTextStyle;

  // Code style (for verification codes, etc.)
  final TextStyle codeTextStyle;

  ExraTextStyles({
    required this.highlightedTextStyle,
    required this.digitTextStyle,
    required this.linkTextStyle,
    required this.buttonTextStyle,
    required this.captionTextStyle,
    required this.overlineTextStyle,
    required this.cardTitleTextStyle,
    required this.cardSubtitleTextStyle,
    required this.inputTextStyle,
    required this.inputLabelTextStyle,
    required this.inputHintTextStyle,
    required this.badgeTextStyle,
    required this.tabActiveTextStyle,
    required this.tabInactiveTextStyle,
    required this.sectionHeaderTextStyle,
    required this.priceTextStyle,
    required this.codeTextStyle,
  });

  @override
  ThemeExtension<ExraTextStyles> copyWith({
    TextStyle? highlightedTextStyle,
    TextStyle? digitTextStyle,
    TextStyle? linkTextStyle,
    TextStyle? buttonTextStyle,
    TextStyle? captionTextStyle,
    TextStyle? overlineTextStyle,
    TextStyle? cardTitleTextStyle,
    TextStyle? cardSubtitleTextStyle,
    TextStyle? inputTextStyle,
    TextStyle? inputLabelTextStyle,
    TextStyle? inputHintTextStyle,
    TextStyle? badgeTextStyle,
    TextStyle? tabActiveTextStyle,
    TextStyle? tabInactiveTextStyle,
    TextStyle? sectionHeaderTextStyle,
    TextStyle? priceTextStyle,
    TextStyle? codeTextStyle,
  }) {
    return ExraTextStyles(
      highlightedTextStyle: highlightedTextStyle ?? this.highlightedTextStyle,
      digitTextStyle: digitTextStyle ?? this.digitTextStyle,
      linkTextStyle: linkTextStyle ?? this.linkTextStyle,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      captionTextStyle: captionTextStyle ?? this.captionTextStyle,
      overlineTextStyle: overlineTextStyle ?? this.overlineTextStyle,
      cardTitleTextStyle: cardTitleTextStyle ?? this.cardTitleTextStyle,
      cardSubtitleTextStyle:
          cardSubtitleTextStyle ?? this.cardSubtitleTextStyle,
      inputTextStyle: inputTextStyle ?? this.inputTextStyle,
      inputLabelTextStyle: inputLabelTextStyle ?? this.inputLabelTextStyle,
      inputHintTextStyle: inputHintTextStyle ?? this.inputHintTextStyle,
      badgeTextStyle: badgeTextStyle ?? this.badgeTextStyle,
      tabActiveTextStyle: tabActiveTextStyle ?? this.tabActiveTextStyle,
      tabInactiveTextStyle: tabInactiveTextStyle ?? this.tabInactiveTextStyle,
      sectionHeaderTextStyle:
          sectionHeaderTextStyle ?? this.sectionHeaderTextStyle,
      priceTextStyle: priceTextStyle ?? this.priceTextStyle,
      codeTextStyle: codeTextStyle ?? this.codeTextStyle,
    );
  }

  @override
  ThemeExtension<ExraTextStyles> lerp(
    covariant ThemeExtension<ExraTextStyles>? other,
    double t,
  ) {
    if (other is! ExraTextStyles) {
      return this;
    }
    return ExraTextStyles(
      highlightedTextStyle: TextStyle.lerp(
        highlightedTextStyle,
        other.highlightedTextStyle,
        t,
      )!,
      digitTextStyle: TextStyle.lerp(digitTextStyle, other.digitTextStyle, t)!,
      linkTextStyle: TextStyle.lerp(linkTextStyle, other.linkTextStyle, t)!,
      buttonTextStyle: TextStyle.lerp(
        buttonTextStyle,
        other.buttonTextStyle,
        t,
      )!,
      captionTextStyle: TextStyle.lerp(
        captionTextStyle,
        other.captionTextStyle,
        t,
      )!,
      overlineTextStyle: TextStyle.lerp(
        overlineTextStyle,
        other.overlineTextStyle,
        t,
      )!,
      cardTitleTextStyle: TextStyle.lerp(
        cardTitleTextStyle,
        other.cardTitleTextStyle,
        t,
      )!,
      cardSubtitleTextStyle: TextStyle.lerp(
        cardSubtitleTextStyle,
        other.cardSubtitleTextStyle,
        t,
      )!,
      inputTextStyle: TextStyle.lerp(inputTextStyle, other.inputTextStyle, t)!,
      inputLabelTextStyle: TextStyle.lerp(
        inputLabelTextStyle,
        other.inputLabelTextStyle,
        t,
      )!,
      inputHintTextStyle: TextStyle.lerp(
        inputHintTextStyle,
        other.inputHintTextStyle,
        t,
      )!,
      badgeTextStyle: TextStyle.lerp(badgeTextStyle, other.badgeTextStyle, t)!,
      tabActiveTextStyle: TextStyle.lerp(
        tabActiveTextStyle,
        other.tabActiveTextStyle,
        t,
      )!,
      tabInactiveTextStyle: TextStyle.lerp(
        tabInactiveTextStyle,
        other.tabInactiveTextStyle,
        t,
      )!,
      sectionHeaderTextStyle: TextStyle.lerp(
        sectionHeaderTextStyle,
        other.sectionHeaderTextStyle,
        t,
      )!,
      priceTextStyle: TextStyle.lerp(priceTextStyle, other.priceTextStyle, t)!,
      codeTextStyle: TextStyle.lerp(codeTextStyle, other.codeTextStyle, t)!,
    );
  }
}

extension ThemeBuildContextX on BuildContext {
  AppTheme get appTheme => Theme.of(this).extension<AppTheme>()!;
  ExraTextStyles get extraTextStyles =>
      Theme.of(this).extension<ExraTextStyles>()!;
  ExtraThemeColors get extraColors =>
      Theme.of(this).extension<ExtraThemeColors>()!;
}

extension ThemeX on ThemeData {
  AppTheme get appTheme => extension<AppTheme>()!;
  ExraTextStyles get extraTextStyles => extension<ExraTextStyles>()!;
  ExtraThemeColors get extraColors => extension<ExtraThemeColors>()!;
}
