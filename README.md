
# @pickupp/react-native-opencv

## Getting started

`$ npm install @pickupp/react-native-opencv --save`

### Mostly automatic installation

`$ react-native link @pickupp/react-native-opencv`

### Prerequisite

You can directly install the package but it will take a while for downloading the sdk required,
you can download the sdk first and create a enviornment variable `export OPENCV_ANDROID_SDK=/path/to/sdk`

### Manual installation


#### iOS

# RN <0.60

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `@pickupp/react-native-opencv` and add `RNOpenCV.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNOpenCV.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)

#### Android

# RN >= 0.60

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
	- Add 
			```
			import org.opencv.android.BaseLoaderCallback;
			import org.opencv.android.LoaderCallbackInterface;
			import org.opencv.android.OpenCVLoader;
			```
		- Add 
			```
				private BaseLoaderCallback mLoaderCallback = new BaseLoaderCallback(this) {
					@Override
					public void onManagerConnected(int status) {
						switch (status) {
							case LoaderCallbackInterface.SUCCESS:
							{
								Log.i("OpenCV", "OpenCV loaded successfully");
							} break;
							default:
							{
								super.onManagerConnected(status);
							} break;
						}
					}
				};

				public void onCreate() {
					super.onCreate();
					if (!OpenCVLoader.initDebug()) {
						Log.d("OpenCv", "Error while init");
					}
				}

				public void onResume()
				{
					if (!OpenCVLoader.initDebug()) {
						Log.d("OpenCV", "Internal OpenCV library not found. Using OpenCV Manager for initialization");
						OpenCVLoader.initAsync(OpenCVLoader.OPENCV_VERSION_3_0_0, this, mLoaderCallback);
					} else {
						Log.d("OpenCV", "OpenCV library found inside package. Using it!");
						mLoaderCallback.onManagerConnected(LoaderCallbackInterface.SUCCESS);
					}
				}
		```
2. Insert the following lines inside the dependencies block in `android/build.gradle` under `allProjects -> dependencies`:
  	```
			maven {
				url "https://dl.bintray.com/pickuppdev/pickupp"
			}
  	```

3. Insert the following lines inside the dependencies block in `android/app/build.gradle` under `allProjects -> dependencies`:
  	```
	    implementation 'org.opencv.android:opencv-android-sdk:3.4.+'
  	```

# RN < 0.60

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import io.pickupp.recatnativeopencv.RNOpenCVPackage;` to the imports at the top of the file
  - Add `new RNOpenCVPackage()` to the list returned by the `getPackages()` method
	- Add 
		```
		import org.opencv.android.BaseLoaderCallback;
		import org.opencv.android.LoaderCallbackInterface;
		import org.opencv.android.OpenCVLoader;
		```
	- Add 
		```
			private BaseLoaderCallback mLoaderCallback = new BaseLoaderCallback(this) {
				@Override
				public void onManagerConnected(int status) {
					switch (status) {
						case LoaderCallbackInterface.SUCCESS:
						{
							Log.i("OpenCV", "OpenCV loaded successfully");
						} break;
						default:
						{
							super.onManagerConnected(status);
						} break;
					}
				}
			};

			public void onCreate() {
				super.onCreate();
				if (!OpenCVLoader.initDebug()) {
					Log.d("OpenCv", "Error while init");
				}
			}

			public void onResume()
			{
				if (!OpenCVLoader.initDebug()) {
					Log.d("OpenCV", "Internal OpenCV library not found. Using OpenCV Manager for initialization");
					OpenCVLoader.initAsync(OpenCVLoader.OPENCV_VERSION_3_0_0, this, mLoaderCallback);
				} else {
					Log.d("OpenCV", "OpenCV library found inside package. Using it!");
					mLoaderCallback.onManagerConnected(LoaderCallbackInterface.SUCCESS);
				}
			}
	```
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-opencv'
  	project(':react-native-opencv').projectDir = new File(rootProject.projectDir, 	'../node_modules/@pickupp/react-native-opencv/android')
		include ':opencv-android-sdk'
		project(':opencv-android-sdk').projectDir = new File(rootProject.projectDir, '../node_modules/@pickupp/react-native-opencv/android/libraries/opencv')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      implementation project(':react-native-opencv')
			implementation project(':opencv-android-sdk')
  	```
4. Insert the following lines inside the android block `andriod/app/build.gradle`
		```
		sourceSets.main {
      // include opencv native jni
      jniLibs.srcDir '../../node_modules/@pickupp/react-native-opencv/android/libraries/opencv/jniLibs'
      jni.srcDirs = [] //disable automatic ndk-build call
    }
		```

## Usage
```javascript
import RNOpenCV from '@pickupp/react-native-opencv';

const maxEdgeLength = await RNOpenCV.findMaxEdge(/* base64ImageString */)
const laplacianScore = await RNOpenCV.laplacianBlurryCheck(/* base64ImageString */)
```
  
