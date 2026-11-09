import '../../core/errors/app_exception.dart';
import '../../l10n/app_localizations.dart';

extension AppErrorTypeMessage on AppErrorType {
  String message(AppLocalizations l10n) {
    return switch (this) {
      AppErrorType.noConnection => l10n.errorNoConnection,
      AppErrorType.rateLimited => l10n.errorRateLimited,
      AppErrorType.notFound => l10n.errorNotFound,
      AppErrorType.server => l10n.errorServer,
      AppErrorType.unknown => l10n.errorUnknown,
    };
  }
}
