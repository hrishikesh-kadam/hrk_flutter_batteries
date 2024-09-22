import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hrk_flutter_batteries/hrk_flutter_batteries.dart';
import 'package:hrk_logging/hrk_logging.dart';
import 'package:hrk_nasa_apis/hrk_nasa_apis.dart';

import '../../globals.dart';
import '../../widgets/app_bar.dart';
import 'bloc/settings_bloc.dart';
import 'bloc/settings_state.dart';
import 'date_format_pattern.dart';
import 'locale.dart';
import 'theme/basic_theme.dart';
import 'theme/custom_theme.dart';
import 'theme/stock_theme.dart';
import 'theme/theme_data.dart';
import 'time_format_pattern.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({
    super.key,
    required this.title,
    required this.l10n,
  });

  final String title;
  final AppLocalizations l10n;
  final _logger = Logger('$appNamePascalCase.SettingsScreen');
  static const String keyPrefix = 'settings_screen_';
  static const Key listViewKey = Key('${keyPrefix}list_view_key');
  static const String themeDataTileKeyPrefix = '${keyPrefix}theme_data_tile_';
  static const Key themeDataTileKey = Key('${themeDataTileKeyPrefix}key');
  static final Set<ThemeData?> themeDatas = {
    ThemeDataExt.system,
    ThemeDataExt.light,
    ThemeDataExt.dark,
    StockTheme.stockThemeDataLight,
    StockTheme.stockThemeDataDark,
    BasicTheme.themeDataLight,
    BasicTheme.themeDataDark,
    CustomTheme.themeDataLight,
    CustomTheme.themeDataDark,
  };
  static const String localeTileKeyPrefix = '${keyPrefix}locale_tile_';
  static const Key localeTileKey = Key('${localeTileKeyPrefix}key');
  static final Set<Locale?> locales = {
    LocaleExt.systemPreferred,
    ...LocaleExt.getSupportedLocales(),
  };
  static const String dateFormatTileKeyPrefix = '${keyPrefix}date_format_tile_';
  static const Key dateFormatTileKey = Key('${dateFormatTileKeyPrefix}key');
  static final Set<DateFormatPattern> dateFormatPatterns =
      DateFormatPattern.values.toSet();
  static const String timeFormatTileKeyPrefix = '${keyPrefix}time_format_tile_';
  static const Key timeFormatTileKey = Key('${timeFormatTileKeyPrefix}key');
  static final Set<TimeFormatPattern> timeFormatPatterns =
      TimeFormatPattern.values.toSet();
  static const String textDirectionTileKeyPrefix =
      '${keyPrefix}text_direction_tile_';
  static const Key textDirectionTileKey =
      Key('${textDirectionTileKeyPrefix}key');
  static final Set<TextDirection?> textDirections = {
    null,
    TextDirection.ltr,
    TextDirection.rtl,
  };
  static const String distanceUnitTileKeyPrefix =
      '${keyPrefix}distance_unit_tile_';
  static const Key distanceUnitTileKey = Key('${distanceUnitTileKeyPrefix}key');
  static final Set<DistanceUnit> distanceUnits = {
    DistanceUnit.au,
    DistanceUnit.LD,
    DistanceUnit.km,
    DistanceUnit.mi,
    DistanceUnit.Re,
  };
  static const String velocityUnitTileKeyPrefix =
      '${keyPrefix}velocity_unit_tile_';
  static const Key velocityUnitTileKey = Key('${velocityUnitTileKeyPrefix}key');
  static final Set<VelocityUnit> velocityUnits = {
    VelocityUnit.kmps,
    VelocityUnit.miph,
    VelocityUnit.aupd,
  };
  static const String diameterUnitTileKeyPrefix =
      '${keyPrefix}diameter_unit_tile_';
  static const Key diameterUnitTileKey = Key('${diameterUnitTileKeyPrefix}key');
  static final Set<DistanceUnit> diameterUnits = {
    DistanceUnit.km,
    DistanceUnit.m,
    DistanceUnit.mi,
    DistanceUnit.ft,
  };

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) =>
          previous.systemLocales != current.systemLocales,
      listener: (context, state) {
        final isAnyDialogOpen = state.isAnyDialogShown;
        _logger.fine(
            'systemLocales listener -> isAnyDialogOpen = $isAnyDialogOpen');
        if (isAnyDialogOpen != null && isAnyDialogOpen) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: getAppBar(
          context: context,
          title: Tooltip(
            message: title,
            child: Text(title),
          ),
        ),
        body: _getBody(),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Widget _getBody() {
    return Builder(
      builder: (context) {
        final settingsTiles = _getSettingsTiles();
        return ListView.separated(
          key: listViewKey,
          itemCount: settingsTiles.length,
          itemBuilder: (context, index) {
            return settingsTiles[index];
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        );
      },
    );
  }

  List<Widget> _getSettingsTiles() {
    return [
      _getThemeDataTile(),
      _getLocaleTile(),
      _getDateFormatTile(),
      _getTimeFormatTile(),
      _getTextDirectionTile(),
      _getDistanceUnitTile(),
      _getVelocityUnitTile(),
      _getDiameterUnitTile(),
    ];
  }

  Widget _getThemeDataTile() {
    final Set<ThemeData?> values = themeDatas;
    final Set<String> valueTitles = values
        .map((themeData) => ThemeDataExt.getDisplayName(
              l10n: l10n,
              themeData: themeData,
            ))
        .toSet();
    return BlocSelector<SettingsBloc, SettingsState, ThemeData?>(
      selector: (state) => state.themeData,
      builder: (context, themeData) {
        final settingsBloc = context.read<SettingsBloc>();
        final ThemeData savedThemeData = Theme.of(context);
        return RadioSettingsTile<ThemeData?>(
          keyPrefix: themeDataTileKeyPrefix,
          key: themeDataTileKey,
          leading: savedThemeData.brightness == Brightness.light
              ? Icon(
                  Icons.dark_mode_outlined,
                  color: savedThemeData.colorScheme.primary,
                )
              : Icon(
                  Icons.light_mode,
                  color: savedThemeData.colorScheme.primary,
                ),
          title: l10n.theme,
          subTitle: ThemeDataExt.getDisplayName(
            l10n: l10n,
            themeData: themeData,
          ),
          values: values,
          valueTitles: valueTitles,
          groupValue: themeData,
          onSelected: (_, index) {
            final ThemeData? selectedThemeData = values.elementAt(index);
            final String themeTitle = ThemeDataExt.getDisplayName(
              l10n: l10n,
              themeData: selectedThemeData,
            );
            _logger.fine('_getThemeDataTile() -> themeTitle -> $themeTitle');
            settingsBloc.add(SettingsThemeSelected(
              themeData: selectedThemeData,
            ));
            Navigator.pop(context);
          },
          beforeShowDialog: () {
            _logger.finer('_getThemeDataTile() -> beforeShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: true,
            ));
          },
          afterShowDialog: () {
            _logger.finer('_getThemeDataTile() -> afterShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: false,
            ));
          },
        );
      },
    );
  }

  static String getLocaleValueTitle({
    required AppLocalizations l10n,
    required Locale? locale,
  }) {
    return switch (locale) {
      null => l10n.system,
      _ => locale.toDisplayName(),
    };
  }

  Widget _getLocaleTile() {
    final Set<Locale?> values = locales;
    final Set<String> valueTitles =
        values.map((e) => getLocaleValueTitle(l10n: l10n, locale: e)).toSet();
    return BlocSelector<SettingsBloc, SettingsState, Locale?>(
      selector: (state) => state.locale,
      builder: (context, locale) {
        final settingsBloc = context.read<SettingsBloc>();
        final ThemeData themeData = Theme.of(context);
        return RadioSettingsTile<Locale?>(
          keyPrefix: localeTileKeyPrefix,
          key: localeTileKey,
          leading: Icon(
            Icons.language,
            color: themeData.colorScheme.primary,
          ),
          title: l10n.language,
          subTitle: getLocaleValueTitle(l10n: l10n, locale: locale),
          values: values,
          valueTitles: valueTitles,
          groupValue: locale,
          onSelected: (_, index) {
            final Locale? selectedLocale = locales.elementAt(index);
            _logger
                .fine('_getLocaleTile() -> selectedLocale -> $selectedLocale');
            if (selectedLocale == null) {
              final Locale resolvedLocale = basicLocaleListResolution(
                settingsBloc.state.systemLocales,
                LocaleExt.getSupportedLocales(),
              );
              settingsBloc.add(
                SettingsLocaleResolved(resolvedLocale: resolvedLocale),
              );
            }
            settingsBloc.add(SettingsLocaleSelected(
              locale: selectedLocale,
            ));
            Navigator.pop(context);
          },
          beforeShowDialog: () {
            _logger.finer('_getLocaleTile() -> beforeShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: true,
            ));
          },
          afterShowDialog: () {
            _logger.finer('_getLocaleTile() -> afterShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: false,
            ));
          },
        );
      },
    );
  }

  static String getDateFormatValueTitle({
    required AppLocalizations l10n,
    required DateFormatPattern dateFormatPattern,
  }) {
    return switch (dateFormatPattern) {
      DateFormatPattern.yMd => l10n.languageDefault,
      _ => dateFormatPattern.pattern,
    };
  }

  Widget _getDateFormatTile() {
    final Set<DateFormatPattern> values = dateFormatPatterns;
    final Set<String> valueTitles = values
        .map((e) => getDateFormatValueTitle(l10n: l10n, dateFormatPattern: e))
        .toSet();
    return BlocSelector<SettingsBloc, SettingsState, DateFormatPattern>(
      selector: (state) => state.dateFormatPattern,
      builder: (context, dateFormatPattern) {
        final settingsBloc = context.read<SettingsBloc>();
        final ThemeData themeData = Theme.of(context);
        return RadioSettingsTile<DateFormatPattern>(
          keyPrefix: dateFormatTileKeyPrefix,
          key: dateFormatTileKey,
          leading: Icon(
            Icons.calendar_month,
            color: themeData.colorScheme.primary,
          ),
          title: l10n.dateFormat,
          subTitle: getDateFormatValueTitle(
            l10n: l10n,
            dateFormatPattern: dateFormatPattern,
          ),
          values: values,
          valueTitles: valueTitles,
          groupValue: dateFormatPattern,
          onSelected: (selectedDateFormatPattern, _) {
            if (selectedDateFormatPattern != null) {
              _logger.fine(
                  '_getDateFormatTile() -> selectedDateFormatPattern -> $selectedDateFormatPattern');
              settingsBloc.add(SettingsDateFormatSelected(
                dateFormatPattern: selectedDateFormatPattern,
              ));
            }
            Navigator.pop(context);
          },
          beforeShowDialog: () {
            _logger.finer('_getDateFormatTile() -> beforeShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: true,
            ));
          },
          afterShowDialog: () {
            _logger.finer('_getDateFormatTile() -> afterShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: false,
            ));
          },
        );
      },
    );
  }

  static String getTimeFormatValueTitle({
    required AppLocalizations l10n,
    required TimeFormatPattern timeFormatPattern,
  }) {
    return switch (timeFormatPattern) {
      TimeFormatPattern.jm => l10n.languageDefault,
      TimeFormatPattern.twelveHourClock => l10n.twelveHourClock,
      TimeFormatPattern.twentyFourHourClock => l10n.twentyFourHourClock,
    };
  }

  Widget _getTimeFormatTile() {
    final Set<TimeFormatPattern> values = timeFormatPatterns;
    final Set<String> valueTitles = values
        .map((e) => getTimeFormatValueTitle(l10n: l10n, timeFormatPattern: e))
        .toSet();
    return BlocSelector<SettingsBloc, SettingsState, TimeFormatPattern>(
      selector: (state) => state.timeFormatPattern,
      builder: (context, timeFormatPattern) {
        final settingsBloc = context.read<SettingsBloc>();
        final ThemeData themeData = Theme.of(context);
        return RadioSettingsTile<TimeFormatPattern>(
          keyPrefix: timeFormatTileKeyPrefix,
          key: timeFormatTileKey,
          leading: Icon(
            Icons.schedule,
            color: themeData.colorScheme.primary,
          ),
          title: l10n.timeFormat,
          subTitle: getTimeFormatValueTitle(
            l10n: l10n,
            timeFormatPattern: timeFormatPattern,
          ),
          values: values,
          valueTitles: valueTitles,
          groupValue: timeFormatPattern,
          onSelected: (selectedTimeFormatPattern, _) {
            if (selectedTimeFormatPattern != null) {
              _logger.fine(
                  '_getTimeFormatTile() -> selectedTimeFormatPattern -> $selectedTimeFormatPattern');
              settingsBloc.add(SettingsTimeFormatSelected(
                timeFormatPattern: selectedTimeFormatPattern,
              ));
            }
            Navigator.pop(context);
          },
          beforeShowDialog: () {
            _logger.finer('_getTimeFormatTile() -> beforeShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: true,
            ));
          },
          afterShowDialog: () {
            _logger.finer('_getTimeFormatTile() -> afterShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: false,
            ));
          },
        );
      },
    );
  }

  static String getTextDirectionValueTitle({
    required AppLocalizations l10n,
    required TextDirection? textDirection,
  }) {
    return switch (textDirection) {
      null => l10n.languageDefault,
      TextDirection.ltr => l10n.leftToRight,
      TextDirection.rtl => l10n.rightToLeft,
    };
  }

  Widget _getTextDirectionTile() {
    final Set<TextDirection?> values = textDirections;
    final Set<String> valueTitles = values
        .map((e) => getTextDirectionValueTitle(l10n: l10n, textDirection: e))
        .toSet();
    return BlocSelector<SettingsBloc, SettingsState, TextDirection?>(
      selector: (state) => state.textDirection,
      builder: (context, textDirection) {
        final settingsBloc = context.read<SettingsBloc>();
        final ThemeData themeData = Theme.of(context);
        return RadioSettingsTile<TextDirection?>(
          keyPrefix: textDirectionTileKeyPrefix,
          key: textDirectionTileKey,
          leading: Icon(
            Icons.format_textdirection_l_to_r,
            color: themeData.colorScheme.primary,
          ),
          title: l10n.textDirection,
          subTitle: getTextDirectionValueTitle(
            l10n: l10n,
            textDirection: textDirection,
          ),
          values: values,
          valueTitles: valueTitles,
          groupValue: textDirection,
          onSelected: (_, index) {
            final TextDirection? selectedTextDirection =
                textDirections.elementAt(index);
            _logger.fine(
                '_getTextDirectionTile() -> selectedTextDirection -> $selectedTextDirection');
            settingsBloc.add(SettingsTextDirectionSelected(
              textDirection: selectedTextDirection,
            ));
            Navigator.pop(context);
          },
          beforeShowDialog: () {
            _logger.finer('_getTextDirectionTile() -> beforeShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: true,
            ));
          },
          afterShowDialog: () {
            _logger.finer('_getTextDirectionTile() -> afterShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: false,
            ));
          },
        );
      },
    );
  }

  static String getDistanceUnitValueTitle({
    required AppLocalizations l10n,
    required DistanceUnit distanceUnit,
  }) {
    return switch (distanceUnit) {
      DistanceUnit.au =>
        '${l10n.auDistanceUnitLabel} (${l10n.auDistanceUnitSymbol})',
      DistanceUnit.LD =>
        '${l10n.lunarDistanceUnitLabel} (${l10n.lunarDistanceUnitSymbol})',
      DistanceUnit.km =>
        '${l10n.kmDistanceUnitLabel} (${l10n.kmDistanceUnitSymbol})',
      DistanceUnit.mi =>
        '${l10n.miDistanceUnitLabel} (${l10n.miDistanceUnitSymbol})',
      DistanceUnit.Re =>
        '${l10n.reDistanceUnitLabel} (${l10n.reDistanceUnitSymbol})',
      _ => throw ArgumentError.value(distanceUnit),
    };
  }

  Widget _getDistanceUnitTile() {
    final Set<DistanceUnit> values = distanceUnits;
    final Set<String> valueTitles = values
        .map((e) => getDistanceUnitValueTitle(l10n: l10n, distanceUnit: e))
        .toSet();
    return BlocSelector<SettingsBloc, SettingsState, DistanceUnit>(
      selector: (state) => state.distanceUnit,
      builder: (context, distanceUnit) {
        final settingsBloc = context.read<SettingsBloc>();
        final ThemeData themeData = Theme.of(context);
        return RadioSettingsTile<DistanceUnit>(
          keyPrefix: distanceUnitTileKeyPrefix,
          key: distanceUnitTileKey,
          leading: Icon(
            Icons.straighten,
            color: themeData.colorScheme.primary,
          ),
          title: l10n.distanceUnit,
          subTitle: getDistanceUnitValueTitle(
            l10n: l10n,
            distanceUnit: distanceUnit,
          ),
          values: values,
          valueTitles: valueTitles,
          groupValue: distanceUnit,
          onSelected: (selectedDistanceUnit, _) {
            if (selectedDistanceUnit != null) {
              _logger.fine(
                  '_getDistanceUnitTile() -> selectedDistanceUnit -> $selectedDistanceUnit');
              settingsBloc.add(SettingsDistanceUnitSelected(
                distanceUnit: selectedDistanceUnit,
              ));
            }
            Navigator.pop(context);
          },
          beforeShowDialog: () {
            _logger.finer('_getDistanceUnitTile() -> beforeShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: true,
            ));
          },
          afterShowDialog: () {
            _logger.finer('_getDistanceUnitTile() -> afterShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: false,
            ));
          },
        );
      },
    );
  }

  static String getVelocityUnitValueTitle({
    required AppLocalizations l10n,
    required VelocityUnit velocityUnit,
  }) {
    return switch (velocityUnit) {
      VelocityUnit.kmps =>
        '${l10n.kmpsVelocityUnitLabel} (${l10n.kmpsVelocityUnitSymbol})',
      VelocityUnit.miph =>
        '${l10n.miphVelocityUnitLabel} (${l10n.miphVelocityUnitSymbol})',
      VelocityUnit.aupd =>
        '${l10n.aupdVelocityUnitLabel} (${l10n.aupdVelocityUnitSymbol})',
      _ => throw ArgumentError.value(velocityUnit),
    };
  }

  Widget _getVelocityUnitTile() {
    final Set<VelocityUnit> values = velocityUnits;
    final Set<String> valueTitles = values
        .map((e) => getVelocityUnitValueTitle(l10n: l10n, velocityUnit: e))
        .toSet();
    return BlocSelector<SettingsBloc, SettingsState, VelocityUnit>(
      selector: (state) => state.velocityUnit,
      builder: (context, velocityUnit) {
        final settingsBloc = context.read<SettingsBloc>();
        final ThemeData themeData = Theme.of(context);
        return RadioSettingsTile<VelocityUnit>(
          keyPrefix: velocityUnitTileKeyPrefix,
          key: velocityUnitTileKey,
          leading: Icon(
            Icons.speed,
            color: themeData.colorScheme.primary,
          ),
          title: l10n.velocityUnit,
          subTitle: getVelocityUnitValueTitle(
            l10n: l10n,
            velocityUnit: velocityUnit,
          ),
          values: values,
          valueTitles: valueTitles,
          groupValue: velocityUnit,
          onSelected: (selectedVelocityUnit, _) {
            if (selectedVelocityUnit != null) {
              _logger.fine(
                  '_getVelocityUnitTile() -> selectedVelocityUnit -> $selectedVelocityUnit');
              settingsBloc.add(SettingsVelocityUnitSelected(
                velocityUnit: selectedVelocityUnit,
              ));
            }
            Navigator.pop(context);
          },
          beforeShowDialog: () {
            _logger.finer('_getVelocityUnitTile() -> beforeShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: true,
            ));
          },
          afterShowDialog: () {
            _logger.finer('_getVelocityUnitTile() -> afterShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: false,
            ));
          },
        );
      },
    );
  }

  static String getDiameterUnitValueTitle({
    required AppLocalizations l10n,
    required DistanceUnit diameterUnit,
  }) {
    return switch (diameterUnit) {
      DistanceUnit.km =>
        '${l10n.kmDistanceUnitLabel} (${l10n.kmDistanceUnitSymbol})',
      DistanceUnit.m =>
        '${l10n.mDistanceUnitLabel} (${l10n.mDistanceUnitSymbol})',
      DistanceUnit.mi =>
        '${l10n.miDistanceUnitLabel} (${l10n.miDistanceUnitSymbol})',
      DistanceUnit.ft =>
        '${l10n.ftDistanceUnitLabel} (${l10n.ftDistanceUnitSymbol})',
      _ => throw ArgumentError.value(diameterUnit),
    };
  }

  Widget _getDiameterUnitTile() {
    final Set<DistanceUnit> values = diameterUnits;
    final Set<String> valueTitles = values
        .map((e) => getDiameterUnitValueTitle(l10n: l10n, diameterUnit: e))
        .toSet();
    return BlocSelector<SettingsBloc, SettingsState, DistanceUnit>(
      selector: (state) => state.diameterUnit,
      builder: (context, diameterUnit) {
        final settingsBloc = context.read<SettingsBloc>();
        final ThemeData themeData = Theme.of(context);
        return RadioSettingsTile<DistanceUnit>(
          keyPrefix: diameterUnitTileKeyPrefix,
          key: diameterUnitTileKey,
          leading: Icon(
            Icons.hide_source,
            color: themeData.colorScheme.primary,
          ),
          title: l10n.diameterUnit,
          subTitle: getDiameterUnitValueTitle(
            l10n: l10n,
            diameterUnit: diameterUnit,
          ),
          values: values,
          valueTitles: valueTitles,
          groupValue: diameterUnit,
          onSelected: (selectedDiameterUnit, _) {
            if (selectedDiameterUnit != null) {
              _logger.fine(
                  '_getDiameterUnitTile() -> selectedDiameterUnit -> $selectedDiameterUnit');
              settingsBloc.add(SettingsDiameterUnitSelected(
                diameterUnit: selectedDiameterUnit,
              ));
            }
            Navigator.pop(context);
          },
          beforeShowDialog: () {
            _logger.finer('_getDiameterUnitTile() -> beforeShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: true,
            ));
          },
          afterShowDialog: () {
            _logger.finer('_getDiameterUnitTile() -> afterShowDialog');
            settingsBloc.add(const SettingsDialogEvent(
              isAnyDialogShown: false,
            ));
          },
        );
      },
    );
  }
}
