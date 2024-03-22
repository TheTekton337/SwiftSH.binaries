#!/bin/bash
#
# build_xcframework.sh
# Copyright © 2020 Dmitriy Borovikov. All rights reserved.
#

set -e

export ROOT_PATH=$(cd "$(dirname "$0")/.."; pwd -P)
pushd $ROOT_PATH > /dev/null

current_version=$(grep -o "spec.version.*=.*['\"]\([^'\"]*\)['\"]" SwiftSH.podspec | grep -o "[0-9]*\.[0-9]*\.[0-9]*")

IFS='.' read -r major minor patch <<< "$current_version"
new_minor=$((minor + 1))
new_version="$major.$new_minor.$patch"

TAG=$new_version
echo "New TAG for release: $TAG"

# TAG="0.1.1"
FRAMEWORK_ZIPNAME=SwiftSH-$TAG.framework.zip
XCFRAMEWORK_ZIPNAME=SwiftSH-$TAG.xcframework.zip

zip --recurse-paths -X --quiet $FRAMEWORK_ZIPNAME SwiftSH.framework
zip --recurse-paths -X --quiet $XCFRAMEWORK_ZIPNAME SwiftSH.xcframework

sed -i '' "s/spec.version[[:space:]]*=[[:space:]]*'[0-9]*\.[0-9]*\.[0-9]*'/spec.version = '$TAG'/" SwiftSH.podspec

git add .
git commit -m "Build $TAG"
git tag $TAG
git push
git push --tags
gh release create "$TAG" $FRAMEWORK_ZIPNAME $XCFRAMEWORK_ZIPNAME --title "$TAG" --notes-file $ROOT_PATH/script/release-note.md

popd > /dev/null
