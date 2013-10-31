#!/bin/bash

SELF=`basename $0`
SOURCE_BRANCH="master"
DEST_BRANCH="gh-pages"
DEPLOY_DIR="_deploy"

git checkout $SOURCE_BRANCH
jekyll build -d $DEPLOY_DIR
git checkout $DEST_BRANCH
# This will remove previous files, which we may not want (e.g. CNAME)
git rm -rf .
git clean -xdf -e $DEPLOY_DIR
cp -r $DEPLOY_DIR/. .
# Delete this script from the output
rm ./$SELF
rm -r $DEPLOY_DIR
git add -A
git commit
#git checkout $SOURCE_BRANCH
