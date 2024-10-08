// ignore_for_file: directives_ordering

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hrk_flutter_batteries/hrk_flutter_batteries.dart';
import 'package:hrk_nasa_apis/hrk_nasa_apis.dart';
import 'package:hrk_nasa_apis_test/hrk_nasa_apis_test.dart';

import '../../constants/labels.dart';
import '../../extension/distance.dart';
import '../../extension/velocity.dart';
import '../../widgets/app_bar.dart';
import '../settings/bloc/settings_bloc.dart';
import '../settings/bloc/settings_state.dart';

class LabelValueWrapScreen extends StatelessWidget {
  const LabelValueWrapScreen({
    super.key,
    required this.title,
    required this.l10n,
    this.routeExtraMap,
    required this.zeroDigit,
  });

  final String title;
  final AppLocalizations l10n;
  final JsonMap? routeExtraMap;
  final String zeroDigit;
  static const String keyPrefix = 'label_value_wrap_screen_';
  static const Key listViewKey = Key('${keyPrefix}list_view_key');
  static const String demoKeyPrefix = '${keyPrefix}demo_';
  static const String desKeyPrefix = 'des_';
  static const String orbitIdKeyPrefix = 'orbit_id_';
  static const String jdKeyPrefix = 'jd_';
  static const String cdKeyPrefix = 'cd_';
  static const String distKeyPrefix = 'dist_';
  static const String distMinKeyPrefix = 'dist_min_';
  static const String distMaxKeyPrefix = 'dist_max_';
  static const String vRelKeyPrefix = 'v_rel_';
  static const String vInfKeyPrefix = 'v_inf_';
  static const String tSigmaFKeyPrefix = 't_sigma_f_';
  static const String bodyKeyPrefix = 'body_';
  static const String hKeyPrefix = 'h_';
  static const String diameterKeyPrefix = 'diameter_';
  static const String diameterSigmaKeyPrefix = 'diameter_sigma_';
  static const String fullnameKeyPrefix = 'fullname_';
  static const double demo1Width = 300;

  static String getDemoKeyPrefix(int index) {
    return '$demoKeyPrefix${index}_';
  }

  static Key getDemoScaffoldKey(int index) {
    return Key('${getDemoKeyPrefix(index)}_scaffold_key');
  }

  static Key getDemoHeaderKey(int index) {
    return Key('${getDemoKeyPrefix(index)}_header_key');
  }

  static Key getDemoKey(int index) {
    return Key('$demoKeyPrefix${index}_key');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Tooltip(
          message: title,
          child: Text(title),
        ),
      ),
      body: _getBody(context: context),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  Widget _getBody({required BuildContext context}) {
    final scrollableContents = _getScrollableContents(context: context);
    return ListView.separated(
      key: listViewKey,
      itemCount: scrollableContents.length,
      itemBuilder: (context, index) {
        return scrollableContents[index];
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: HrkDimensions.bodyItemSpacing);
      },
      padding: const EdgeInsets.symmetric(
        vertical: HrkDimensions.pageMarginVertical,
        horizontal: HrkDimensions.pageMarginHorizontal,
      ),
    );
  }

  List<Widget> _getScrollableContents({required BuildContext context}) {
    int demoIndex = 0;
    final SbdbCadBody sbdbCadBody = SbdbCadBodyExt.getSample('200/all-fields');
    return [
      _getDemo0(
        context: context,
        demoIndex: demoIndex++,
        sbdbCadBody: sbdbCadBody,
      ),
      _getDemo1(
        context: context,
        demoIndex: demoIndex++,
        sbdbCadBody: sbdbCadBody,
      ),
      _getDemo2(
        context: context,
        demoIndex: demoIndex++,
        sbdbCadBody: sbdbCadBody,
      ),
    ];
  }

  Widget _getDemoScaffold({
    required BuildContext context,
    required int demoIndex,
    required String demoHeader,
    required Widget demoWidget,
  }) {
    return Column(
      key: getDemoScaffoldKey(demoIndex),
      children: [
        Text(
          demoHeader,
          key: getDemoHeaderKey(demoIndex),
          style: _getDemoHeaderTextStyle(context: context),
        ),
        const SizedBox(height: HrkDimensions.bodyItemSpacing),
        demoWidget,
      ],
    );
  }

  TextStyle _getDemoHeaderTextStyle({required BuildContext context}) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.tertiary,
    );
  }

  Widget _getDemo0({
    required BuildContext context,
    required int demoIndex,
    required SbdbCadBody sbdbCadBody,
  }) {
    return _getDemoScaffold(
      context: context,
      demoIndex: demoIndex,
      demoHeader: 'Not wrapped',
      demoWidget: getDemoWidget(
        sbdbCadBody: sbdbCadBody,
        sbdbCadData: sbdbCadBody.data![0],
        demoIndex: demoIndex,
      ),
    );
  }

  Widget _getDemo1({
    required BuildContext context,
    required int demoIndex,
    required SbdbCadBody sbdbCadBody,
  }) {
    return _getDemoScaffold(
      context: context,
      demoIndex: demoIndex,
      demoHeader: 'Wrapped',
      demoWidget: SizedBox(
        width: demo1Width,
        child: getDemoWidget(
          sbdbCadBody: sbdbCadBody,
          sbdbCadData: sbdbCadBody.data![0],
          demoIndex: demoIndex,
        ),
      ),
    );
  }

  Widget _getDemo2({
    required BuildContext context,
    required int demoIndex,
    required SbdbCadBody sbdbCadBody,
  }) {
    return _getDemoScaffold(
      context: context,
      demoIndex: demoIndex,
      demoHeader: 'expectNoOverflow()',
      demoWidget: SizedBox(
        width: DeviceDimensions.galaxyFoldPortraitWidth -
            (HrkDimensions.pageMarginHorizontal * 2),
        child: getDemoWidget(
          sbdbCadBody: sbdbCadBody,
          sbdbCadData: sbdbCadBody.data![0],
          demoIndex: demoIndex,
        ),
      ),
    );
  }

  Widget getDemoWidget({
    required SbdbCadBody sbdbCadBody,
    required SbdbCadData sbdbCadData,
    required int demoIndex,
  }) {
    return BodyItemContainer(
      key: Key('$demoKeyPrefix${demoIndex}_container_key'),
      child: SelectionArea(
        child: getItemBody(
          sbdbCadBody: sbdbCadBody,
          data: sbdbCadData,
          demoIndex: demoIndex,
        ),
      ),
    );
  }

  Widget getItemBody({
    required SbdbCadBody sbdbCadBody,
    required SbdbCadData data,
    required int demoIndex,
  }) {
    final fields = List<String>.from(sbdbCadBody.rawBody!['fields']);
    final String demoIndexKeyPrefix = '$demoKeyPrefix${demoIndex}_';
    const spacing = HrkDimensions.bodyItemSpacing;
    return Column(
      key: getDemoKey(demoIndex),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelValueWrap(
          keyPrefix: '$demoIndexKeyPrefix$desKeyPrefix',
          label: '${l10n.designation}:',
          value: data.des.localizeDigits(toZeroDigit: zeroDigit),
          spacing: spacing,
        ),
        if (fields.contains('fullname'))
          LabelValueWrap(
            keyPrefix: '$demoIndexKeyPrefix$fullnameKeyPrefix',
            label: '${l10n.fullname}:',
            value: data.fullname
                .toString()
                .trim()
                .localizeDigits(toZeroDigit: zeroDigit),
            spacing: spacing,
          ),
        LabelValueWrap(
          keyPrefix: '$demoIndexKeyPrefix$orbitIdKeyPrefix',
          label: '${l10n.orbitId}:',
          value: data.orbitId.localizeDigits(toZeroDigit: zeroDigit),
          spacing: spacing,
        ),
        LabelValueWrap(
          keyPrefix: '$demoIndexKeyPrefix$jdKeyPrefix',
          label: '${l10n.julianDate}:',
          value:
              '${data.jd} ${Labels.tdb}'.localizeDigits(toZeroDigit: zeroDigit),
          spacing: spacing,
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          buildWhen: (previous, current) {
            return previous.dateFormatPattern != current.dateFormatPattern ||
                previous.timeFormatPattern != current.timeFormatPattern;
          },
          builder: (context, settingsState) {
            return LabelValueWrap(
              keyPrefix: '$demoIndexKeyPrefix$cdKeyPrefix',
              label: '${l10n.dateSlashTime}:',
              value: _formatCloseApproachDateTime(
                settingsState: settingsState,
                cd: data.cd,
              ),
              spacing: spacing,
            );
          },
        ),
        LabelValueWrap(
          keyPrefix: '$demoIndexKeyPrefix$tSigmaFKeyPrefix',
          label: '${l10n.timeSigma}:',
          value: data.tSigmaF.localizeDigits(toZeroDigit: zeroDigit),
          spacing: spacing,
        ),
        if (fields.contains('body'))
          LabelValueWrap(
            keyPrefix: '$demoIndexKeyPrefix$bodyKeyPrefix',
            label: '${l10n.closeApproachBody}:',
            value: data.body != null
                ? getLocalizedBody(body: data.body!, l10n: l10n)
                : Labels.na,
            spacing: spacing,
          ),
        BlocSelector<SettingsBloc, SettingsState, DistanceUnit>(
          selector: (state) {
            return state.distanceUnit;
          },
          builder: (context, distanceUnit) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LabelValueWrap(
                  keyPrefix: '$demoIndexKeyPrefix$distKeyPrefix',
                  label: '${l10n.distance}:',
                  value: data.dist
                      .convert(to: distanceUnit)
                      .toLocalizedString(l10n)
                      .localizeDigits(toZeroDigit: zeroDigit),
                  spacing: spacing,
                ),
                LabelValueWrap(
                  keyPrefix: '$demoIndexKeyPrefix$distMinKeyPrefix',
                  label: '${l10n.distanceMin}:',
                  value: data.distMin
                      .convert(to: distanceUnit)
                      .toLocalizedString(l10n)
                      .localizeDigits(toZeroDigit: zeroDigit),
                  spacing: spacing,
                ),
                LabelValueWrap(
                  keyPrefix: '$demoIndexKeyPrefix$distMaxKeyPrefix',
                  label: '${l10n.distanceMax}:',
                  value: data.distMax
                      .convert(to: distanceUnit)
                      .toLocalizedString(l10n)
                      .localizeDigits(toZeroDigit: zeroDigit),
                  spacing: spacing,
                ),
              ],
            );
          },
        ),
        BlocSelector<SettingsBloc, SettingsState, VelocityUnit>(
          selector: (state) {
            return state.velocityUnit;
          },
          builder: (context, velocityUnit) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LabelValueWrap(
                  keyPrefix: '$demoIndexKeyPrefix$vRelKeyPrefix',
                  label: '${l10n.velocityRel}:',
                  value: data.vRel
                      .convert(to: velocityUnit)
                      .toLocalizedString(l10n)
                      .localizeDigits(toZeroDigit: zeroDigit),
                  spacing: spacing,
                ),
                LabelValueWrap(
                  keyPrefix: '$demoIndexKeyPrefix$vInfKeyPrefix',
                  label: '${l10n.velocityInf}:',
                  value: data.vInf != null
                      ? data.vInf!
                          .convert(to: velocityUnit)
                          .toLocalizedString(l10n)
                          .localizeDigits(toZeroDigit: zeroDigit)
                      : Labels.na,
                  spacing: spacing,
                ),
              ],
            );
          },
        ),
        LabelValueWrap(
          keyPrefix: '$demoIndexKeyPrefix$hKeyPrefix',
          label: '${l10n.absoulteMagnitude}:',
          value: data.h != null
              ? '${data.h} H'.localizeDigits(toZeroDigit: zeroDigit)
              : Labels.na,
          spacing: spacing,
        ),
        if (fields.contains('diameter'))
          BlocSelector<SettingsBloc, SettingsState, DistanceUnit>(
            selector: (state) {
              return state.diameterUnit;
            },
            builder: (context, diameterUnit) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LabelValueWrap(
                    keyPrefix: '$demoIndexKeyPrefix$diameterKeyPrefix',
                    label: '${l10n.diameter}:',
                    value: data.diameter != null
                        ? data.diameter!
                            .convert(to: diameterUnit)
                            .toLocalizedString(l10n)
                            .localizeDigits(toZeroDigit: zeroDigit)
                        : Labels.na,
                    spacing: spacing,
                  ),
                  LabelValueWrap(
                    keyPrefix: '$demoIndexKeyPrefix$diameterSigmaKeyPrefix',
                    label: '${l10n.diameterSigma}:',
                    value: data.diameterSigma != null
                        ? data.diameterSigma!
                            .convert(to: diameterUnit)
                            .toLocalizedString(l10n)
                            .localizeDigits(toZeroDigit: zeroDigit)
                        : Labels.na,
                    spacing: spacing,
                  ),
                ],
              );
            },
          ),
      ],
    );
  }

  String _formatCloseApproachDateTime({
    required SettingsState settingsState,
    required DateTime cd,
  }) {
    final dateFormat = settingsState.getDateFormat();
    final dateTimeStringBuffer = StringBuffer(dateFormat.format(cd));
    dateTimeStringBuffer.write(' ');
    final timeFormat = settingsState.getTimeFormat();
    dateTimeStringBuffer.write(timeFormat.format(cd));
    dateTimeStringBuffer.write(' ${Labels.tdb}');
    return dateTimeStringBuffer.toString();
  }

  static String getLocalizedBody({
    required String body,
    required AppLocalizations l10n,
  }) {
    return switch (body) {
      'Earth' => l10n.earth,
      'Moon' => l10n.moon,
      'Mercury' => l10n.mercury,
      'Venus' => l10n.venus,
      'Mars' => l10n.mars,
      'Jupiter' => l10n.jupiter,
      'Saturn' => l10n.saturn,
      'Uranus' => l10n.uranus,
      'Neptune' => l10n.neptune,
      'Pluto' => l10n.pluto,
      _ => body
    };
  }
}
