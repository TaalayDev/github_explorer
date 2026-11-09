part of 'theme.dart';

/// GitHub "Dark default" palette.
abstract final class _Gh {
  // Canvas
  static const canvasDefault = Color(0xFF0D1117);
  static const canvasSubtle = Color(0xFF161B22);
  static const canvasInset = Color(0xFF010409);
  static const neutralMuted = Color(0xFF21262D);

  // Borders
  static const borderDefault = Color(0xFF30363D);
  static const borderMuted = Color(0xFF21262D);

  // Foreground
  static const fgDefault = Color(0xFFE6EDF3);
  static const fgMuted = Color(0xFF8D96A0);
  static const fgSubtle = Color(0xFF6E7681);

  // Accent (blue)
  static const accentFg = Color(0xFF4493F8);
  static const accentEmphasis = Color(0xFF1F6FEB);

  // Semantic
  static const successFg = Color(0xFF3FB950);
  static const successEmphasis = Color(0xFF238636);
  static const attentionFg = Color(0xFFD29922);
  static const severeFg = Color(0xFFDB6D28);
  static const dangerFg = Color(0xFFF85149);
  static const doneFg = Color(0xFFAB7DF8);
  static const tealFg = Color(0xFF39C5CF);
}

AppTheme buildGithubDarkTheme() {
  const primary = _Gh.accentFg;

  final base = ThemeData(brightness: Brightness.dark).textTheme;
  final textTheme = GoogleFonts.notoSansTextTheme(base).apply(bodyColor: _Gh.fgDefault, displayColor: _Gh.fgDefault);

  TextStyle style(Color color, double size, [FontWeight? weight]) =>
      GoogleFonts.notoSans(color: color, fontSize: size, fontWeight: weight);

  return AppTheme(
    type: ThemeType.githubDark,
    isDark: true,
    primaryColor: primary,
    primaryVariant: _Gh.accentEmphasis,
    onPrimary: Colors.white,
    primaryDark: _Gh.accentEmphasis,
    accentColor: _Gh.successEmphasis,
    onAccent: Colors.white,
    background: _Gh.canvasDefault,
    surface: _Gh.canvasSubtle,
    surfaceVariant: _Gh.neutralMuted,
    textPrimary: _Gh.fgDefault,
    textSecondary: _Gh.fgMuted,
    textDisabled: _Gh.fgSubtle,
    divider: _Gh.borderMuted,
    toolbarColor: _Gh.canvasSubtle,
    error: _Gh.dangerFg,
    success: _Gh.successFg,
    warning: _Gh.attentionFg,
    gridLine: _Gh.borderMuted,
    gridBackground: _Gh.canvasDefault,
    canvasBackground: _Gh.canvasDefault,
    selectionOutline: primary,
    selectionFill: primary.withValues(alpha: 0.12),
    activeIcon: _Gh.fgDefault,
    inactiveIcon: _Gh.fgMuted,
    textTheme: textTheme,
    primaryFontWeight: FontWeight.w600,
    surfaceContainerLow: _Gh.canvasSubtle,
    surfaceContainerHighest: _Gh.neutralMuted,
    inputFillColor: _Gh.canvasInset,
    extraColors: ExtraThemeColors(
      highlightColor: primary.withValues(alpha: 0.15),
      shadowColor: Colors.black,
      textSecondaryColor: _Gh.fgMuted,
      primarySubtle: primary.withValues(alpha: 0.15),
      linkColor: primary,
      hintColor: _Gh.fgSubtle,
      successLight: _Gh.successFg.withValues(alpha: 0.15),
      errorLight: _Gh.dangerFg.withValues(alpha: 0.15),
      warningLight: _Gh.attentionFg.withValues(alpha: 0.15),
      infoLight: primary.withValues(alpha: 0.15),
      iconBgBlue: primary.withValues(alpha: 0.15),
      iconBgOrange: _Gh.severeFg.withValues(alpha: 0.15),
      iconBgGreen: _Gh.successFg.withValues(alpha: 0.15),
      iconBgYellow: _Gh.attentionFg.withValues(alpha: 0.15),
      iconBgRed: _Gh.dangerFg.withValues(alpha: 0.15),
      iconBgPurple: _Gh.doneFg.withValues(alpha: 0.15),
      accentOrange: _Gh.severeFg,
      accentGreen: _Gh.successFg,
      accentPurple: _Gh.doneFg,
      accentTeal: _Gh.tealFg,
      accentYellow: _Gh.attentionFg,
      shimmerBase: _Gh.canvasSubtle,
      shimmerHighlight: _Gh.neutralMuted,
      overlayDark: Colors.black.withValues(alpha: 0.6),
      overlayLight: Colors.white.withValues(alpha: 0.08),
      badgeBackground: _Gh.neutralMuted,
      badgeText: _Gh.fgDefault,
      cardBorder: _Gh.borderDefault,
      inputBorder: _Gh.borderDefault,
      inputFocusBorder: primary,
      dividerLight: _Gh.borderMuted,
      navActiveIcon: _Gh.fgDefault,
      navInactiveIcon: _Gh.fgMuted,
      navActiveBackground: _Gh.neutralMuted,
      buttonSecondary: _Gh.neutralMuted,
      primaryGradientColors: const [_Gh.accentFg, _Gh.accentEmphasis],
    ),
    exraTextStyles: ExraTextStyles(
      highlightedTextStyle: style(primary, 14, FontWeight.w600),
      digitTextStyle: style(_Gh.fgDefault, 24, FontWeight.w600),
      linkTextStyle: style(primary, 14, FontWeight.w500),
      buttonTextStyle: style(Colors.white, 14, FontWeight.w600),
      captionTextStyle: style(_Gh.fgMuted, 12),
      overlineTextStyle: style(_Gh.fgSubtle, 10, FontWeight.w600),
      cardTitleTextStyle: style(_Gh.fgDefault, 16, FontWeight.w600),
      cardSubtitleTextStyle: style(_Gh.fgMuted, 13),
      inputTextStyle: style(_Gh.fgDefault, 14),
      inputLabelTextStyle: style(_Gh.fgMuted, 14),
      inputHintTextStyle: style(_Gh.fgSubtle, 14),
      badgeTextStyle: style(_Gh.fgDefault, 12, FontWeight.w500),
      tabActiveTextStyle: style(_Gh.fgDefault, 14, FontWeight.w600),
      tabInactiveTextStyle: style(_Gh.fgMuted, 14),
      sectionHeaderTextStyle: style(_Gh.fgDefault, 18, FontWeight.w600),
      priceTextStyle: style(_Gh.fgDefault, 16, FontWeight.w600),
      codeTextStyle: GoogleFonts.jetBrainsMono(color: _Gh.fgDefault, fontSize: 13),
    ),
  );
}
