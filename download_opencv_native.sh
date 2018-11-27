DIR=`pwd`
DESTINATION=$DIR/android/src/main
curl -O https://jaist.dl.sourceforge.net/project/opencvlibrary/3.4.4/opencv-3.4.4-android-sdk.zip

unzip opencv-3.4.4-android-sdk.zip
mkdir $DIR/android/src/main/jniLibs
cp -r $DIR/OpenCV-android-sdk/sdk/native/libs/ $DESTINATION/jniLibs
rm -rf opencv-3.4.4-android-sdk.zip
rm -rf OpenCV-android-sdk/