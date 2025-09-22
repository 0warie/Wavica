import 'package:flutter/widgets.dart';
import 'package:wavica/l10n/gen/app_localizations.dart';

export 'package:wavica/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
