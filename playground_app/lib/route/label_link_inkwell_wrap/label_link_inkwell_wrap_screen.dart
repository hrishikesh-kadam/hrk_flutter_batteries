// ignore_for_file: directives_ordering

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hrk_batteries/hrk_batteries.dart';
import 'package:hrk_flutter_batteries/hrk_flutter_batteries.dart';
import 'package:hrk_logging/hrk_logging.dart';

import '../../constants/constants.dart';
import '../../constants/dimensions.dart';
import '../../globals.dart';
import '../../widgets/app_bar.dart';

class LabelLinkInkWellWrapScreen extends StatelessWidget {
  LabelLinkInkWellWrapScreen({
    super.key,
    required this.title,
    required this.l10n,
    this.routeExtraMap,
  });

  final String title;
  final AppLocalizations l10n;
  final JsonMap? routeExtraMap;
  // ignore: unused_field
  final _logger = Logger('$appNamePascalCase.LabelLinkInkWellWrapScreen');
  static const String keyPrefix = 'label_link_inkwell_wrap_screen_';
  static const Key listViewKey = Key('${keyPrefix}list_view_key');
  static const Key demo1Key = Key('${keyPrefix}demo_1_key');
  static const Key demo2Key = Key('${keyPrefix}demo_2_key');
  static const Key demo3Key = Key('${keyPrefix}demo_3_key');
  static const Key demo4Key = Key('${keyPrefix}demo_4_key');
  static const Key demo1LabelKey = Key('${keyPrefix}demo_1_label_key');
  static const Key demo2LabelKey = Key('${keyPrefix}demo_2_label_key');
  static const Key demo3LabelKey = Key('${keyPrefix}demo_3_label_key');
  static const Key demo4LabelKey = Key('${keyPrefix}demo_4_label_key');
  static const Key demo1LinkKey = Key('${keyPrefix}demo_1_link_key');
  static const Key demo2LinkKey = Key('${keyPrefix}demo_2_link_key');
  static const Key demo3LinkKey = Key('${keyPrefix}demo_3_link_key');
  static const Key demo4LinkKey = Key('${keyPrefix}demo_4_link_key');

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: getAppBar(
          context: context,
          title: Tooltip(
            message: title,
            child: Text(title),
          ),
        ),
        body: _getBody(context: context),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
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
        return const SizedBox(height: Dimensions.bodyItemSpacer);
      },
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
    );
  }

  List<Widget> _getScrollableContents({required BuildContext context}) {
    return [
      _getDemo1(),
      _getDemo2(),
      _getDemo3(),
      _getDemo4(),
    ];
  }

  // Basic
  Widget _getDemo1() {
    return LabelLinkInkWellWrap(
      key: demo1Key,
      labelKey: demo1LabelKey,
      label: l10n.source,
      uri: Constants.sourceRepoUrl,
      linkKey: demo1LinkKey,
    );
  }

  // With preFollowLink
  Widget _getDemo2() {
    return LabelLinkInkWellWrap(
      key: demo2Key,
      labelKey: demo2LabelKey,
      label: l10n.source,
      uri: Constants.sourceRepoUrl,
      linkKey: demo2LinkKey,
      preFollowLink: () async {},
    );
  }

  // With customFollowLink
  Widget _getDemo3() {
    return LabelLinkInkWellWrap(
      key: demo3Key,
      labelKey: demo3LabelKey,
      label: l10n.source,
      uri: Constants.sourceRepoUrl,
      linkKey: demo3LinkKey,
      customFollowLink: () async {},
    );
  }

  // With preFollowLink, customFollowLink
  Widget _getDemo4() {
    return LabelLinkInkWellWrap(
      key: demo4Key,
      labelKey: demo4LabelKey,
      label: l10n.source,
      uri: Constants.sourceRepoUrl,
      linkKey: demo4LinkKey,
      preFollowLink: () async {},
      customFollowLink: () async {},
    );
  }
}