DIR=`pwd`
DESTINATION=$DIR/android/src/main/jniLibs

if [ ! -d "$DESTINATION" ]; then
  # Only download if destination does not exist
  curl -O https://jaist.dl.sourceforge.net/project/opencvlibrary/3.4.4/opencv-3.4.4-android-sdk.zip

  unzip opencv-3.4.4-android-sdk.zip
  mkdir $DESTINATION
  cp -r $DIR/OpenCV-android-sdk/sdk/native/libs/ $DESTINATION
  rm -rf opencv-3.4.4-android-sdk.zip
  rm -rf OpenCV-android-sdk/
fi