#!/usr/bin/env bash

set -e -o pipefail

rm -rf coverage

flutter test test/unit_test \
  --coverage \
  --coverage-path coverage/package/unit_test_lcov.info
# lcov --list coverage/package/unit_test_lcov.info \
#   | grep -v ".*|.*100%.*|.*"

flutter test test/widget_test \
  --coverage \
  --coverage-path coverage/package/widget_test_lcov.info
# lcov --list coverage/package/widget_test_lcov.info \
#   | grep -v ".*|.*100%.*|.*"

pushd playground_app &> /dev/null

if (( $(git status -s pubspec.yaml | wc -l) > 0 )); then
  PUBSPEC_MODIFIED=true
  git stash push -m "pubspec.yaml at $(date +"%d/%m/%Y %r")" pubspec.yaml
  git stash apply 0
fi

yq -i '.flutter.assets += [ "assets/fonts/Roboto/" ]' pubspec.yaml
yq -i '.flutter.assets += [ "assets/fonts/MaterialIcons/" ]' pubspec.yaml

flutter test test/widget_test \
  --coverage \
  --coverage-package hrk_flutter_batteries \
  --coverage-path ../coverage/playground_app/widget_test_lcov.info

git restore pubspec.yaml
if [[ $PUBSPEC_MODIFIED == true ]]; then
  git stash apply 0
fi

popd &> /dev/null

sed -i 's/SF:..\//SF:/g' coverage/playground_app/widget_test_lcov.info
# lcov --list coverage/playground_app/widget_test_lcov.info \
#   | grep -v ".*|.*100%.*|.*"

lcov --add-tracefile coverage/package/unit_test_lcov.info \
  --add-tracefile coverage/package/widget_test_lcov.info \
  --add-tracefile coverage/playground_app/widget_test_lcov.info \
  --output-file coverage/lcov.info

lcov --list coverage/lcov.info \
  | grep -v ".*|.*100%.*|.*"
