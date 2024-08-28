import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hrk_batteries/hrk_batteries.dart';
import 'package:hrk_logging/hrk_logging.dart';
import 'package:url_launcher/link.dart';

import '../extension/go_router.dart';
import '../globals.dart';
import '../route/about/about_route.dart';
import '../route/about/license/license_route.dart';
import '../route/home/home_route.dart' hide $SettingsRouteExtension;
import '../route/page_not_found/page_not_found_route.dart';
import '../route/settings/settings_route.dart';

const Key settingsActionKey = Key('settings_action_key');
const Key aboutActionKey = Key('about_action_key');

AppBar getAppBar({
  Key? key,
  required BuildContext context,
  Widget? leading,
  Widget? title,
  List<Widget>? actions,
  PreferredSizeWidget? bottom,
  bool deferedLoadingPlaceholder = false,
}) {
  leading ??= getLeadingWidget(context: context);
  actions ??= getDefaultAppBarActions(
    context: context,
    deferedLoadingPlaceholder: deferedLoadingPlaceholder,
  );
  return AppBar(
    key: key,
    leading: leading,
    title: title,
    actions: actions,
    bottom: bottom,
    // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  );
}

SliverAppBar getSliverAppBar({
  Key? key,
  required BuildContext context,
  Widget? leading,
  Widget? title,
  List<Widget>? actions,
  PreferredSizeWidget? bottom,
  bool floating = false,
  bool snap = false,
  bool deferedLoadingPlaceholder = false,
}) {
  leading ??= getLeadingWidget(context: context);
  actions ??= getDefaultAppBarActions(
    context: context,
    deferedLoadingPlaceholder: deferedLoadingPlaceholder,
  );
  return SliverAppBar(
    key: key,
    leading: leading,
    title: title,
    actions: actions,
    bottom: bottom,
    // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    floating: floating,
    snap: snap,
  );
}

Widget? getLeadingWidget({
  required BuildContext context,
}) {
  String? location;
  try {
    // throws expected AssertionError for errorBuilder Widgets
    location = GoRouterState.of(context).matchedLocation;
  } catch (_) {}
  switch (location) {
    // Routes which doesn't need leading BackButton
    case HomeRoute.pathSegment:
      return null;
    default:
      return getAppBarBackButton(context: context);
  }
}

BackButton getAppBarBackButton({
  required BuildContext context,
}) {
  return BackButton(
    onPressed: () {
      late final Object? extraObject;
      try {
        // throws expected AssertionError for errorBuilder widgets
        extraObject = GoRouterState.of(context).extra;
      } catch (_) {
        extraObject = null;
      }
      Level logLevel = flutterTest ? Level.FINER : Level.SHOUT;
      if (extraObject == null) {
        GoRouter.of(context).topOrHomeRoute();
      } else if (extraObject is JsonMap) {
        JsonMap extraMap = extraObject;
        if (extraMap.containsKey(isNormalLink)) {
          GoRouter.of(context).popOrHomeRoute();
        } else {
          logger.log(
              logLevel, 'getAppBarBackButton -> Unusual navigation observed');
          logger.log(logLevel, 'extra doesn\'t contains isNormalLink key');
          final routeMatchList = GoRouter.of(context).getListOfRouteMatch();
          logger.log(
              logLevel, 'routeMatchList.length = ${routeMatchList.length}');
          GoRouter.of(context).go(HomeRoute.uri.path);
        }
      } else {
        logger.log(
            logLevel, 'getAppBarBackButton -> Unusual navigation observed');
        logger.log(logLevel, 'extra is not a JsonMap');
        final routeMatchList = GoRouter.of(context).getListOfRouteMatch();
        logger.log(
            logLevel, 'routeMatchList.length = ${routeMatchList.length}');
        GoRouter.of(context).go(HomeRoute.uri.path);
      }
    },
  );
}

List<Widget> getDefaultAppBarActions({
  required BuildContext context,
  bool deferedLoadingPlaceholder = false,
}) {
  String? location;
  try {
    // throws expected AssertionError for errorBuilder Widgets
    location = GoRouterState.of(context).matchedLocation;
  } catch (_) {}
  return <Widget>[
    if (location != null && location == HomeRoute.uri.path)
      getAboutAction(context: context),
    if (location != null &&
        ![
          SettingsRoute.uri.path,
          PageNotFoundRoute.uri.path,
          AboutRoute.uri.path,
          LicenseRoute.uri.path,
        ].contains(location) &&
        deferedLoadingPlaceholder == false)
      getSettingsAction(context: context),
  ];
}

Widget getSettingsAction({required BuildContext context}) {
  return IconButton(
    key: settingsActionKey,
    tooltip: AppLocalizations.of(context).settings,
    icon: const Icon(Icons.settings),
    onPressed: () {
      GoRouter.of(context).push(
        SettingsRoute.uri.path,
        extra: getRouteExtraMap(),
      );
    },
  );
}

Widget getAboutAction({required BuildContext context}) {
  return Link(
    uri: AboutRoute.uri,
    builder: (context, followLink) {
      return IconButton(
        key: aboutActionKey,
        tooltip: AppLocalizations.of(context).about,
        icon: const Icon(Icons.info),
        onPressed: () {
          GoRouter.of(context)
              .go(AboutRoute.uri.path, extra: getRouteExtraMap());
        },
      );
    },
  );
}
