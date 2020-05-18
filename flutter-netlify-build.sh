#!/bin/bash
FLUTTER_BRANCH=`grep channel: .metadata | sed 's/  channel: //g'`
FLUTTER_REVISION=`grep revision: .metadata | sed 's/  revision: //g'`

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

# Setup dart
DART=`echo $FLUTTER | sed 's/flutter$/cache\/dart-sdk\/bin\/dart/'`
echo $DART

$FLUTTER build web --release
