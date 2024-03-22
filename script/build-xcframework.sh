#!/bin/bash
#
# build_xcframework.sh
# Copyright © 2020 Dmitriy Borovikov. All rights reserved.
#

set -e

export ROOT_PATH=$(cd "$(dirname "$0")/.."; pwd -P)
pushd $ROOT_PATH > /dev/null

current_version=$(grep -o "spec.version.*=.*['\"]\([^'\"]*\)['\"]" SwiftSH.podspec | grep -o "[0-9]*\.[0-9]*\.[0-9]*")

IFS='.' read -r MAJOR MINOR PATCH <<< "$current_version"
NEW_MINOR=$((MINOR + 1))
NEW_VERSION="$MAJOR.$NEW_MINOR.$PATCH"

TAG=$NEW_VERSION
FRAMEWORK_ZIPNAME=SwiftSH-$TAG.framework.zip
XCFRAMEWORK_ZIPNAME=SwiftSH-$TAG.xcframework.zip

echo "New TAG for release: $TAG"

zip --recurse-paths -X --quiet $FRAMEWORK_ZIPNAME SwiftSH.framework
zip --recurse-paths -X --quiet $XCFRAMEWORK_ZIPNAME SwiftSH.xcframework

sed -i '' "s/SwiftSH.binaries [0-9]*\.[0-9]*\.[0-9]* build/SwiftSH.binaries $TAG build/" script/release-note.md
sed -i '' "s/spec.version[[:space:]]*=[[:space:]]*'[0-9]*\.[0-9]*\.[0-9]*'/spec.version = '$TAG'/" SwiftSH.podspec

git add .
git commit -m "Build $TAG"
git tag $TAG
git push
git push --tags
gh release create "$TAG" $FRAMEWORK_ZIPNAME $XCFRAMEWORK_ZIPNAME --title "$TAG" --notes-file $ROOT_PATH/script/release-note.md

popd > /dev/null
