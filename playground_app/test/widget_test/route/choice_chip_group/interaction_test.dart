import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hrk_flutter_batteries/hrk_flutter_batteries.dart';

import 'package:playground_app/route/choice_chip_group/choice_chip_group_screen.dart';
import '../../../src/route/choice_chip_group/choice_chip_group_route.dart';

void main() {
  group('$ChoiceChipGroup Interaction Test', () {
    testWidgets('Demo 0', (tester) async {
      const int index = 0;
      await pumpChoiceChipGroupRoute(tester);
      await ensureDemoVisible(tester, index);
      final chipFinders = getChipFindersOf(index);
      var chipElements = chipFinders.evaluate().toList();
      final int firstRandomIndex = Random().nextInt(chipElements.length);
      var firstRandomChip = chipElements[firstRandomIndex].widget as ChoiceChip;
      int secondRandomIndex;
      do {
        secondRandomIndex = Random().nextInt(chipElements.length);
      } while (firstRandomIndex == secondRandomIndex);
      var secondRandomChip =
          chipElements[secondRandomIndex].widget as ChoiceChip;
      expect(firstRandomChip.selected, false);
      expect(secondRandomChip.selected, false);
      await tester.tap(find.byKey(firstRandomChip.key!));
      await tester.pump();
      chipElements = chipFinders.evaluate().toList();
      firstRandomChip = chipElements[firstRandomIndex].widget as ChoiceChip;
      secondRandomChip = chipElements[secondRandomIndex].widget as ChoiceChip;
      expect(firstRandomChip.selected, true);
      expect(secondRandomChip.selected, false);
    });

    testWidgets('Demo 3, default selected', (tester) async {
      const int index = 3;
      await pumpChoiceChipGroupRoute(tester);
      await ensureDemoVisible(tester, index);
      final chipFinders = getChipFindersOf(index);
      var chipElements = chipFinders.evaluate().toList();
      final defaultIndex = ChoiceChipGroupScreen.defaultSelectionIndex;
      var defaultChip = chipElements[defaultIndex].widget as ChoiceChip;
      int randomIndex;
      do {
        randomIndex = Random().nextInt(chipElements.length);
      } while (defaultIndex == randomIndex);
      var nonDefaultChip = chipElements[randomIndex].widget as ChoiceChip;
      expect(defaultChip.selected, true);
      expect(nonDefaultChip.selected, false);

      await tester.tap(find.byKey(nonDefaultChip.key!));
      await tester.pump();
      chipElements = chipFinders.evaluate().toList();
      defaultChip = chipElements[defaultIndex].widget as ChoiceChip;
      nonDefaultChip = chipElements[randomIndex].widget as ChoiceChip;
      expect(defaultChip.selected, false);
      expect(nonDefaultChip.selected, true);

      await tester.tap(find.byKey(nonDefaultChip.key!));
      await tester.pump();
      chipElements = chipFinders.evaluate().toList();
      defaultChip = chipElements[defaultIndex].widget as ChoiceChip;
      nonDefaultChip = chipElements[randomIndex].widget as ChoiceChip;
      expect(defaultChip.selected, true);
      expect(nonDefaultChip.selected, false);
    });

    testWidgets('Demo 5, disableInputs', (tester) async {
      const int index = 5;
      await pumpChoiceChipGroupRoute(tester);
      await ensureDemoVisible(tester, index);
      final chipElements = getChipFindersOf(index).evaluate();
      for (final chipElement in chipElements) {
        final chipWidget = chipElement.widget as ChoiceChip;
        final selected = chipWidget.selected;
        await tester.tap(find.byKey(chipWidget.key!), warnIfMissed: false);
        await tester.pump();
        expect(chipWidget.selected, selected);
      }
    });
  });
}