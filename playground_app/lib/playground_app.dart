import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hrk_logging/hrk_logging.dart';

import 'config/app_back_button_dispatcher.dart';
import 'globals.dart';
import 'route/home/home_route.dart';
import 'route/page_not_found/page_not_found_route.dart';
import 'route/settings/bloc/settings_bloc.dart';
import 'route/settings/bloc/settings_state.dart';
import 'route/settings/locale.dart';
import 'route/settings/theme/theme_data.dart';
import 'widgets/directionality_widget.dart';

class PlaygroundApp extends StatelessWidget {
  PlaygroundApp({
    super.key,
    GlobalKey<NavigatorState>? navigatorKey,
    String? initialLocation,
    SettingsBloc? settingsBloc,
    bool debugShowCheckedModeBanner = true,
  })  : _settingsBloc = settingsBloc ?? SettingsBloc(),
        _debugShowCheckedModeBanner = debugShowCheckedModeBanner {
    _goRouter = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation,
      routes: [
        $homeRoute,
        $pageNotFoundRoute,
      ],
      debugLogDiagnostics: kDebugMode,
    );
  }

  late final GoRouter _goRouter;
  final SettingsBloc _settingsBloc;
  final bool _debugShowCheckedModeBanner;
  final _logger = Logger('$appNamePascalCase.App');

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (_) => _settingsBloc,
      child: BlocSelector<SettingsBloc, SettingsState, ThemeData?>(
        selector: (state) => state.themeData,
        builder: (context, themeData) {
          ThemeData? darkThemeData;
          if (themeData == ThemeDataExt.system) {
            themeData = ThemeDataExt.light;
            darkThemeData = ThemeDataExt.dark;
          }
          return BlocSelector<SettingsBloc, SettingsState, Locale?>(
            selector: (state) => state.locale,
            builder: (context, locale) {
              return _getApp(
                context: context,
                themeData: themeData,
                darkThemeData: darkThemeData,
                locale: locale,
              );
            },
          );
        },
      ),
    );
  }

  Widget _getApp({
    required BuildContext context,
    ThemeData? themeData,
    ThemeData? darkThemeData,
    Locale? locale,
  }) {
    return MaterialApp.router(
      routeInformationProvider: _goRouter.routeInformationProvider,
      routeInformationParser: _goRouter.routeInformationParser,
      routerDelegate: _goRouter.routerDelegate,
      backButtonDispatcher: AppBackButtonDispatcher(goRouter: _goRouter),
      builder: _builder,
      // onGenerateTitle: (context) {
      //   return AppLocalizations.of(context).playgroundApp;
      // },
      theme: themeData,
      darkTheme: darkThemeData,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeListResolutionCallback: (locales, supportedLocales) {
        return _localeListResolutionCallback(
          context: context,
          locales: locales,
          supportedLocales: supportedLocales,
        );
      },
      supportedLocales: LocaleExt.getSupportedLocales(),
      debugShowCheckedModeBanner: _debugShowCheckedModeBanner,
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    assert(child != null);
    return getDirectionality(
      child: child!,
    );
  }

  // locales is not always systemLocales, when non-null Locale is given to
  // MaterialApp, then this callback is called by setting the given Locale as
  // single element List to locales
  Locale? _localeListResolutionCallback({
    required BuildContext context,
    List<Locale>? locales,
    required Iterable<Locale> supportedLocales,
  }) {
    _logger.fine('localeListResolutionCallback -> $locales');
    final settingsBloc = context.read<SettingsBloc>();
    if (!listEquals(settingsBloc.state.systemLocales,
        WidgetsBinding.instance.platformDispatcher.locales)) {
      settingsBloc.add(SettingsSystemLocalesChanged(
        systemLocales: WidgetsBinding.instance.platformDispatcher.locales,
      ));
    }
    final Locale resolvedLocale = basicLocaleListResolution(
      locales,
      supportedLocales,
    );
    settingsBloc.add(SettingsLocaleResolved(resolvedLocale: resolvedLocale));
    return resolvedLocale;
  }
}
