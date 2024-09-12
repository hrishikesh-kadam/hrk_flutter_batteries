import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrk_flutter_batteries/hrk_flutter_batteries.dart';
import 'package:hrk_flutter_test_batteries/hrk_flutter_test_batteries.dart';

import 'package:playground_app/route/settings/bloc/settings_state.dart';
import 'package:playground_app/route/settings/date_format_pattern.dart';
import 'package:playground_app/route/settings/settings_screen.dart';
import '../settings_route.dart';

const DateFormatPattern dateFormatPatternDefault =
    SettingsState.dateFormatPatternDefault;
final DateFormatPattern dateFormatPatternNonDefault = SettingsScreen
    .dateFormatPatterns
    .toList()
    .reversed
    .firstWhere((element) => element != dateFormatPatternDefault);
final Finder dateFormatTileFinder =
    find.byKey(SettingsScreen.dateFormatTileKey);
final Finder dateFormatDialogFinder = find.byKey(const Key(
  '${SettingsScreen.dateFormatTileKeyPrefix}'
  '${RadioDialog.keySuffixDefault}',
));
const String dateFormatDialogKeyPrefix =
    '${SettingsScreen.dateFormatTileKeyPrefix}'
    '${RadioDialog.keyPrefixDefault}';
final Finder dateFormatListViewFinder = find.byKey(const Key(
  '$dateFormatDialogKeyPrefix'
  '${RadioDialog.listViewKeySuffix}',
));

Finder getDateFormatPatternFinder({
  required AppLocalizations l10n,
  required DateFormatPattern dateFormatPattern,
}) {
  return find.byKey(Key(
    '$dateFormatDialogKeyPrefix'
    '${SettingsScreen.getDateFormatValueTitle(
      l10n: l10n,
      dateFormatPattern: dateFormatPattern,
    )}',
  ));
}

Future<void> tapDateFormatTile(WidgetTester tester) async {
  await ensureTileVisible(tester, dateFormatTileFinder);
  await tester.tap(dateFormatTileFinder);
  await tester.pumpAndSettle();
}

Future<void> chooseDateFormat(
  WidgetTester tester, {
  required AppLocalizations l10n,
  required DateFormatPattern dateFormatPattern,
}) async {
  final dateFormatPatternFinder = getDateFormatPatternFinder(
    l10n: l10n,
    dateFormatPattern: dateFormatPattern,
  );
  await tester.dragUntilVisible(
    dateFormatPatternFinder,
    dateFormatListViewFinder,
    const Offset(0, -200),
  );
  await tester.pumpAndSettle();
  await tester.tap(dateFormatPatternFinder);
  await tester.pumpAndSettle();
}

Future<void> verifyDateFormatTileSubtitle(
  WidgetTester tester, {
  required AppLocalizations l10n,
  required DateFormatPattern dateFormatPattern,
}) async {
  final subTitleFinder = find.descendantText(
    of: dateFormatTileFinder,
    text: SettingsScreen.getDateFormatValueTitle(
      l10n: l10n,
      dateFormatPattern: dateFormatPattern,
    ),
  );
  expect(subTitleFinder, findsOneWidget);
}
