import 'package:hrk_batteries/hrk_batteries.dart';
import 'package:hrk_logging/hrk_logging.dart';
import 'package:recase/recase.dart';

import 'constants/constants.dart';

final String appNamePascalCase = Constants.appName.pascalCase;

final bool flutterTest = isFlutterTest();

final logger = Logger(appNamePascalCase);

/// isNormalLink is used to check if the route was opened by normal-link or
/// deep-link.
const isNormalLink = 'isNormalLink';

JsonMap getRouteExtraMap() {
  JsonMap extra = {};
  extra[isNormalLink] = true;
  return extra;
}
