DIR=`pwd`
JNI_DESTINATION=$DIR/android/libraries/opencv/jniLibs
JAVA_DESTINATION=$DIR/android/libraries/opencv/src/main

if [ ! -d "$JNI_DESTINATION" ] || [ ! -d "$JAVA_DESTINATION" ]; then
  # Only download if destination does not exist
  curl -O https://jaist.dl.sourceforge.net/project/opencvlibrary/3.4.4/opencv-3.4.4-android-sdk.zip

  unzip opencv-3.4.4-android-sdk.zip

  if [ ! -d "$JNI_DESTINATION" ]; then
    # copy jni
    mkdir $JNI_DESTINATION
    cp -r $DIR/OpenCV-android-sdk/sdk/native/libs/ $JNI_DESTINATION
  fi


  if [ ! -d "$JAVA_DESTINATION/java" ]; then
    # copy java
    mkdir $JAVA_DESTINATION
    cp -r $DIR/OpenCV-android-sdk/sdk/java/src/ $JAVA_DESTINATION/java
    cp -r $DIR/OpenCV-android-sdk/sdk/java/res $JAVA_DESTINATION/res
    cp -r $DIR/OpenCV-android-sdk/sdk/java/AndroidManifest.xml $JAVA_DESTINATION/AndroidManifest.xml
  fi

  rm -rf opencv-3.4.4-android-sdk.zip
  rm -rf OpenCV-android-sdk/
fi
