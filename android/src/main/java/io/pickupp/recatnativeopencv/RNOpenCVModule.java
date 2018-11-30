package io.pickupp.recatnativeopencv;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import org.opencv.core.CvType;
import org.opencv.core.Mat;

import org.opencv.android.Utils;
import org.opencv.imgproc.Imgproc;

import android.util.Base64;

public class RNOpenCVModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNOpenCVModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNOpenCV";
    }

    public Mat imageBase64ToMat(String imageAsBase64) {
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inDither = true;
        options.inPreferredConfig = Bitmap.Config.ARGB_8888;

        byte[] decodedString = Base64.decode(imageAsBase64, Base64.DEFAULT);
        Bitmap image = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
        Mat matImage = new Mat();
        Utils.bitmapToMat(image, matImage);

        return matImage;
    }

    @ReactMethod
    public void laplacianBlurryCheck(String imageAsBase64, Promise promise) {
        try {
            // https://stackoverflow.com/questions/36862451/opencv-with-laplacian-formula-to-detect-image-is-blur-or-not-in-android
            Mat matImage = this.imageBase64ToMat(imageAsBase64);
            int l = CvType.CV_8UC1; //8-bit grey scale image
            Mat matImageGrey = new Mat();
            Imgproc.cvtColor(matImage, matImageGrey, Imgproc.COLOR_BGR2GRAY);

            Mat laplacianImage = new Mat();
            matImage.convertTo(laplacianImage, l);
            Imgproc.Laplacian(matImageGrey, laplacianImage, CvType.CV_8U);
            Mat laplacianImage8bit = new Mat();
            laplacianImage.convertTo(laplacianImage8bit, l);

            int size = (int)(laplacianImage8bit.elemSize() * laplacianImage8bit.total());
            byte[] pixels = new byte[size];
            laplacianImage8bit.get(0, 0, pixels);
            int maxLap = 0;
            for (byte pixel : pixels) {
                int value = pixel & 0xFF;
                if (value > maxLap) {
                  maxLap = value;
                }
            }

            promise.resolve(maxLap);
        } catch (Exception e) {
            promise.reject("unable to calculate laplacian score", e);
        }
    }

    // TODO: implement other methods
}
