// ignore_for_file: directives_ordering

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hrk_flutter_batteries/hrk_flutter_batteries.dart';
import 'package:hrk_logging/hrk_logging.dart';
import 'package:url_launcher/link.dart';

import '../../config/config.dart';
import '../../constants/constants.dart';
import '../../globals.dart';
import '../../widgets/app_bar.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({
    super.key,
    required this.title,
    required this.l10n,
  });

  final String title;
  final AppLocalizations l10n;
  // ignore: unused_field
  final _logger = Logger('$appNamePascalCase.AboutScreen');
  static const String keyPrefix = 'about_screen_';
  static const Key scaffoldKey = Key('${keyPrefix}scaffold_key');
  static const Key listViewKey = Key('${keyPrefix}list_view_key');
  static const Key licenseButtonKey = Key('${keyPrefix}license_button_key');
  static const Key linktreeUriKey = Key('${keyPrefix}linktree_key');
  static const Key sourceUriKey = Key('${keyPrefix}source_key');

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        key: scaffoldKey,
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
        return const SizedBox(height: HrkDimensions.bodyItemSpacing);
      },
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
    );
  }

  List<Widget> _getScrollableContents({required BuildContext context}) {
    return [
      _getAppIcon(),
      _getAppText(context: context),
      _getVersion(context: context),
      _getAuthor(context: context),
      _getLinktreeText(context: context),
      _getMadeWithLoveText(context: context),
      LabelLinkInkWellWrap(
        label: l10n.source,
        uri: Constants.sourceRepoUrl,
        linkKey: sourceUriKey,
      ),
      _getLicenseButton(context: context),
    ];
  }

  Widget _getAppIcon() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/app-icons/app-icon.png',
          width: 96,
          height: 96,
        ),
      ),
    );
  }

  Widget _getAppText({required BuildContext context}) {
    return Center(
      child: Text(
        l10n.playgroundApp,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _getVersion({required BuildContext context}) {
    final String completeVersion = getCompleteVersion();
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          '${l10n.version}: ',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        Text(
          completeVersion,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _getAuthor({required BuildContext context}) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          '${l10n.author}: ',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        Text(
          l10n.authorNameAka,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _getLinktreeText({required BuildContext context}) {
    return Center(
      child: Link(
        uri: Constants.linktreeUrl,
        target: LinkTarget.blank,
        builder: (context, followLink) {
          return InkWell(
            key: linktreeUriKey,
            onTap: () {
              followLink?.call();
            },
            child: Text(
              Constants.linktreeUrl.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget _getMadeWithLoveText({required BuildContext context}) {
    return Center(
      child: Text(
        'Made with 💙 using Flutter',
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _getLicenseButton({required BuildContext context}) {
    return Center(
      child: FilledButton(
        key: licenseButtonKey,
        child: Text(
          MaterialLocalizations.of(context).viewLicensesButtonLabel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          // context.go(
          //   LicenseRoute.path,
          //   extra: getRouteExtraMap(),
          // );
          showLicensePage(
            context: context,
            applicationName: l10n.playgroundApp,
            applicationVersion: getCompleteVersion(),
            useRootNavigator: true,
          );
        },
      ),
    );
  }
}
