// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      name: 'Playground App',
      factory: $HomeRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'settings',
          name: 'Settings',
          factory: $SettingsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'about',
          name: 'About',
          factory: $AboutRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'license',
              name: 'Licenses',
              factory: $LicenseRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'choice-chip-input-widget',
          name: 'ChoiceChipInputWidget',
          factory: $ChoiceChipInputWidgetRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'date-range-widget',
          name: 'DateRangeWidget',
          factory: $DateRangeWidgetRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'choice-chip-group',
          name: 'ChoiceChipGroup',
          factory: $ChoiceChipGroupRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'filter-chip-group',
          name: 'FilterChipGroup',
          factory: $FilterChipGroupRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'label-link-inkwell-wrap',
          name: 'LabelLinkInkWellWrap',
          factory: $LabelLinkInkWellWrapRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'label-value-wrap',
          name: 'LabelValueWrap',
          factory: $LabelValueWrapRouteExtension._fromState,
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AboutRouteExtension on AboutRoute {
  static AboutRoute _fromState(GoRouterState state) => const AboutRoute();

  String get location => GoRouteData.$location(
        '/about',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LicenseRouteExtension on LicenseRoute {
  static LicenseRoute _fromState(GoRouterState state) => const LicenseRoute();

  String get location => GoRouteData.$location(
        '/about/license',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ChoiceChipInputWidgetRouteExtension on ChoiceChipInputWidgetRoute {
  static ChoiceChipInputWidgetRoute _fromState(GoRouterState state) =>
      ChoiceChipInputWidgetRoute(
        $extra: state.extra as Map<String, dynamic>?,
      );

  String get location => GoRouteData.$location(
        '/choice-chip-input-widget',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $DateRangeWidgetRouteExtension on DateRangeWidgetRoute {
  static DateRangeWidgetRoute _fromState(GoRouterState state) =>
      DateRangeWidgetRoute(
        $extra: state.extra as Map<String, dynamic>?,
      );

  String get location => GoRouteData.$location(
        '/date-range-widget',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $ChoiceChipGroupRouteExtension on ChoiceChipGroupRoute {
  static ChoiceChipGroupRoute _fromState(GoRouterState state) =>
      ChoiceChipGroupRoute(
        $extra: state.extra as Map<String, dynamic>?,
      );

  String get location => GoRouteData.$location(
        '/choice-chip-group',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $FilterChipGroupRouteExtension on FilterChipGroupRoute {
  static FilterChipGroupRoute _fromState(GoRouterState state) =>
      FilterChipGroupRoute(
        $extra: state.extra as Map<String, dynamic>?,
      );

  String get location => GoRouteData.$location(
        '/filter-chip-group',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $LabelLinkInkWellWrapRouteExtension on LabelLinkInkWellWrapRoute {
  static LabelLinkInkWellWrapRoute _fromState(GoRouterState state) =>
      LabelLinkInkWellWrapRoute(
        $extra: state.extra as Map<String, dynamic>?,
      );

  String get location => GoRouteData.$location(
        '/label-link-inkwell-wrap',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $LabelValueWrapRouteExtension on LabelValueWrapRoute {
  static LabelValueWrapRoute _fromState(GoRouterState state) =>
      LabelValueWrapRoute(
        $extra: state.extra as Map<String, dynamic>?,
      );

  String get location => GoRouteData.$location(
        '/label-value-wrap',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}
