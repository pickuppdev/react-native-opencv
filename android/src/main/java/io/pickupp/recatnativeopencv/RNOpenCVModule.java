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

            Bitmap bmp = Bitmap.createBitmap(laplacianImage8bit.cols(), laplacianImage8bit.rows(), Bitmap.Config.ARGB_8888);
            Utils.matToBitmap(laplacianImage8bit, bmp);
            int[] pixels = new int[bmp.getHeight() * bmp.getWidth()];
            bmp.getPixels(pixels, 0, bmp.getWidth(), 0, 0, bmp.getWidth(), bmp.getHeight());
            int maxLap = -16777216; // 16m, 256 * 256 * 256
            for (int pixel : pixels) {
                if (pixel > maxLap) {
                    maxLap = pixel;
                }
            }

            int soglia = -8118750;
            if (maxLap <= soglia) {
                System.out.println("is blur image");
            }

            promise.resolve(maxLap <= soglia);
        } catch (Exception e) {
            promise.reject("unable to calculate laplacian score", e);
        }
    }

    // TODO: implement other methods
}
