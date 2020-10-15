#!/bin/bash
# Subversion properties
#
# Script to deploy sfscript(s) from SVN tag to production location (/home/sfscript)
#
TOP="/home/raychorn"
#
PROJECT=pyMonit
HOME=$TOP/python-projects
PROJECTPATH=$TOP/$PROJECT
CURRENT_FILE=$HOME/CURRENT
DEPLOYMENT_HISTORY_FILE=$HOME/DEPLOYMENT_HISTORY_FILE
SVN_HOME="https://SQL2005:8443/svn/repo1/trunk/python/$PROJECT"
#
cd $HOME
OLD_DEST=`cat $CURRENT_FILE`
#
echo "Current deployment is in: $OLD_DEST"
echo '========== The following SVN ROOT repository will be used ======================='
svn info $SVN_HOME
echo 'The following TAGS are available:'
svn list $SVN_HOME
TAG1=`svn list $SVN_HOME | tail -n 1`
echo '================================================================================='
#
echo -n "Please enter TAG (see above) to deploy, last selected by default [$TAG1]: "
read -t 60 TAG
if [ -z $TAG ]; then
	TAG=$TAG1
fi
#
CURRENT=$PROJECT
DEST=$HOME/$CURRENT
#
echo '========== The following directories / files will be deployed ==================='
svn info $SVN_HOME/$TAG
svn list -v $SVN_HOME/$TAG
REVISION=`svn info $SVN_HOME/$TAG | grep "Last Changed Rev:"`
echo "Files will be deployed to: $DEST"
echo '================================================================================='
read -p 'Please type yes to continue with deployment: ' -t 60 CONFIRM
if [ "$CONFIRM" != "yes" ]; then
  echo "You typed '$CONFIRM'. Exiting"
  exit
fi
#
echo "You typed 'yes'. OK, deployment will be performed."
#
if [ -d $DEST ]; then
	rm -rf $DEST
fi
mkdir $DEST
svn export --force -q $SVN_HOME/$TAG $DEST/
#
echo $CURRENT > $CURRENT_FILE
echo "$CURRENT	$SVN_HOME/$TAG	$REVISION	`date`" >> $DEPLOYMENT_HISTORY_FILE
#
chmod -R 744 $DEST/*.py
#
echo "Files deployed."
#
exit
