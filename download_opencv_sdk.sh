DIR=`pwd`
JNI_DESTINATION=$DIR/android/libraries/opencv/jniLibs
JAVA_DESTINATION=$DIR/android/libraries/opencv/src/main


downloadSdk() {
  # Only download if destination does not exist
  curl -O https://jaist.dl.sourceforge.net/project/opencvlibrary/3.4.4/opencv-3.4.4-android-sdk.zip

  unzip opencv-3.4.4-android-sdk.zip
}

copySdk() {
  # copy jni
  if [ -d "$JNI_DESTINATION" ]; then
    rm -rf $JNI_DESTINATION
  fi
  mkdir $JNI_DESTINATION
  cp -r $1/sdk/native/libs/ $JNI_DESTINATION
  # copy java
  cp -r $1/sdk/java/src/ $JAVA_DESTINATION/java
  cp -r $1/sdk/java/res $JAVA_DESTINATION/res
  cp -r $1/sdk/java/AndroidManifest.xml $JAVA_DESTINATION/AndroidManifest.xml
}

cleanupSdk() {
  rm -rf opencv-3.4.4-android-sdk.zip
  rm -rf OpenCV-android-sdk/
}

if [[ -z "${OPENCV_ANDROID_SDK}" ]] && [[ -d "$OPENCV_ANDROID_SDK" ]]; then
  downloadSdk
  copySdk $DIR/OpenCV-android-sdk
  cleanupSdk
else
  copySdk $OPENCV_ANDROID_SDK
fi
