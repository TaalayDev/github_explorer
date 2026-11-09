enum ThemeType {
  githubDark;

  bool get isDark => [ThemeType.githubDark].contains(this);

  bool get isLight => !isDark;

  String get displayName {
    return switch (this) {
      ThemeType.githubDark => 'GitHub Dark',
    };
  }
}
