#!/bin/bash
#
# build_xcframework.sh
# Copyright © 2020 Dmitriy Borovikov. All rights reserved.
#

set -e

export ROOT_PATH=$(cd "$(dirname "$0")/.."; pwd -P)
pushd $ROOT_PATH > /dev/null

TAG="0.1.0"
FRAMEWORK_ZIPNAME=SwiftSH-$SPM_TAG.framework.zip
XCFRAMEWORK_ZIPNAME=SwiftSH-$SPM_TAG.xcframework.zip

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
