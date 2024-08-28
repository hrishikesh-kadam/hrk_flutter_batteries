import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:go_router/go_router.dart';
import 'package:hrk_batteries/hrk_batteries.dart';
import 'package:hrk_logging/hrk_logging.dart';

import '../../globals.dart';
import '../route/home/home_route.dart';
import '../route/page_not_found/page_not_found_route.dart';

extension GoRouterExt on GoRouter {
  static final _logger = Logger('$appNamePascalCase.GoRouterExt');

  void popOrHomeRoute() {
    if (canPop()) {
      pop();
    } else {
      go(HomeRoute.uri.path);
    }
  }

  void topOrHomeRoute() {
    if (canPop()) {
      pop();
      void addPostFrameCallbackForCanPop() {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (canPop()) {
            pop();
            addPostFrameCallbackForCanPop();
          }
        });
      }

      addPostFrameCallbackForCanPop();
    } else {
      go(HomeRoute.uri.path);
    }
  }

  List getListOfRouteMatch() {
    return routerDelegate.currentConfiguration.matches;
  }

  static void onException(
    BuildContext context,
    GoRouterState state,
    GoRouter router,
  ) {
    _logger.error('onException -> ${state.uri}');
    late final JsonMap extra;
    if (state.extra != null) {
      extra = state.extra as JsonMap;
    } else {
      extra = {};
    }
    extra['$GoRouterState'] = state;
    router.go(PageNotFoundRoute.uri.path, extra: extra);
  }
}
