#!/bin/bash
FLUTTER_BRANCH=`grep channel: .metadata | sed 's/  channel: //g'`
FLUTTER_REVISION=`grep revision: .metadata | sed 's/  revision: //g'`

# Generate the git info code for the version info
echo // This is generated file. > ./lib/git_info.g.dart
echo -n String shortSHA = \" >> ./lib/git_info.g.dart
git rev-parse --short HEAD | tr -d '\n' >> ./lib/git_info.g.dart
echo \"\; >> ./lib/git_info.g.dart

# Setup flutter
FLUTTER=`which flutter`
if [ $? -eq 0 ]
then
  # Flutter is installed
  FLUTTER=`which flutter`
else
  # Get flutter
  git clone https://github.com/flutter/flutter.git
  FLUTTER=flutter/bin/flutter
fi

cd flutter
git checkout $FLUTTER_BRANCH
git pull origin $FLUTTER_BRANCH
git checkout $FLUTTER_REVISION
cd ..

$FLUTTER config --enable-web

# Log config info
echo Flutter branch $FLUTTER_BRANCH
echo Flutter revision $FLUTTER_REVISION
$FLUTTER --version

# Setup dart
DART=`echo $FLUTTER | sed 's/flutter$/cache\/dart-sdk\/bin\/dart/'`
echo $DART

$FLUTTER build web --release
