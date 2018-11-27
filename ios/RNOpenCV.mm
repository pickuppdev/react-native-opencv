#import "RNOpenCV.h"
#import <React/RCTLog.h>

@implementation RNOpenCV

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(
  laplacianBlurryCheck:(NSString *)imageAsBase64 
  resolver:(RCTPromiseResolveBlock)resolve
  rejecter:(RCTPromiseRejectBlock)reject
  ) {
  NSError *error;
  UIImage* image = [self decodeBase64ToImage:imageAsBase64];

  int laplacianScore = [self laplacianBlurryCheck:image];

  if (laplacianScore) {
    resolve([NSNumber numberWithInt:laplacianScore]);
  } else {
    reject(@"invaild_score", @"Cannot calculate score", error);
  }
}

RCT_EXPORT_METHOD(tenengradBlurryCheck:(NSString *)imageAsBase64 callback:(RCTResponseSenderBlock)callback) {
  UIImage* image = [self decodeBase64ToImage:imageAsBase64];

  double tenengradScore = [self tenengradBlurryCheck:image];

  callback(@[[NSNull null], [NSNumber numberWithDouble:tenengradScore]]);
}

RCT_EXPORT_METHOD(brennerBlurryCheck:(NSString *)imageAsBase64 callback:(RCTResponseSenderBlock)callback) {
  UIImage* image = [self decodeBase64ToImage:imageAsBase64];

  double brennerScore = [self brennerBlurryCheck:image];

  callback(@[[NSNull null], [NSNumber numberWithDouble:brennerScore]]);
}

RCT_EXPORT_METHOD(stdevBlurryCheck:(NSString *)imageAsBase64 callback:(RCTResponseSenderBlock)callback) {
  UIImage* image = [self decodeBase64ToImage:imageAsBase64];

  float stdevScore = [self stdevBlurryCheck:image];

  callback(@[[NSNull null], [NSNumber numberWithFloat:stdevScore]]);
}

RCT_EXPORT_METHOD(entropyBlurryCheck:(NSString *)imageAsBase64 callback:(RCTResponseSenderBlock)callback) {
  UIImage* image = [self decodeBase64ToImage:imageAsBase64];

  double entropyScore = [self entropyBlurryCheck:image];

  callback(@[[NSNull null], [NSNumber numberWithDouble:entropyScore]]);
}

// native code
- (cv::Mat)convertUIImageToCVMat:(UIImage *)image {
  CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
  CGFloat cols = image.size.width;
  CGFloat rows = image.size.height;

  cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)

  CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                  cols,                       // Width of bitmap
                                                  rows,                       // Height of bitmap
                                                  8,                          // Bits per component
                                                  cvMat.step[0],              // Bytes per row
                                                  colorSpace,                 // Colorspace
                                                  kCGImageAlphaNoneSkipLast |
                                                  kCGBitmapByteOrderDefault); // Bitmap info flags

  CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
  CGContextRelease(contextRef);

  return cvMat;
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
  NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
  return [UIImage imageWithData:data];
}

- (int) laplacianBlurryCheck:(UIImage *) image {
  // converting UIImage to OpenCV format - Mat
  cv::Mat matImage = [self convertUIImageToCVMat:image];
  cv::Mat matImageGrey;
  // converting image's color space (RGB) to grayscale
  cv::cvtColor(matImage, matImageGrey, CV_BGR2GRAY);

  cv::Mat dst2 = [self convertUIImageToCVMat:image];
  cv::Mat laplacianImage;
  dst2.convertTo(laplacianImage, CV_8UC1);

  // applying Laplacian operator to the image
  cv::Laplacian(matImageGrey, laplacianImage, CV_8U);
  cv::Mat laplacianImage8bit;
  laplacianImage.convertTo(laplacianImage8bit, CV_8UC1);

  unsigned char *pixels = laplacianImage8bit.data;

  // 16777216 = 256*256*256
  int maxLap = -16777216;
  for (int i = 0; i < ( laplacianImage8bit.elemSize()*laplacianImage8bit.total()); i++) {
    if (pixels[i] > maxLap) {
      maxLap = pixels[i];
    }
  }
  // one of the main parameters here: threshold sets the sensitivity for the blur check
  // smaller number = less sensitive; default = 180
  int threshold = 180;

  return maxLap;
}

- (double) tenengradBlurryCheck:(UIImage *) image {
    // converting UIImage to OpenCV format - Mat
    cv::Mat matImage = [self convertUIImageToCVMat:image];
    cv::Mat matImageGrey;
    // converting image's color space (RGB) to grayscale
    cv::cvtColor(matImage, matImageGrey, CV_BGR2GRAY);

    cv::Mat imageSobel;
    Sobel(matImageGrey,imageSobel,CV_16U,1,1);
    double meanValue = 0.0;
    meanValue = mean(imageSobel)[0];

    return meanValue;
}

- (float) brennerBlurryCheck:(UIImage *) image {
  // converting UIImage to OpenCV format - Mat
  cv::Mat matImage = [self convertUIImageToCVMat:image];
  cv::Mat matImageGrey;
  // converting image's color space (RGB) to grayscale
  cv::cvtColor(matImage, matImageGrey, CV_BGR2GRAY);

  // Brenner's Algorithm

 	cv::Size s = matImageGrey.size();
 	int rows = s.height;
 	int cols = s.width;
 	cv::Mat DH = cv::Mat(rows,cols, CV_64F, double(0));
 	cv::Mat DV = cv::Mat(rows,cols, CV_64F, double(0));
  cv::subtract(matImageGrey.rowRange(2,rows).colRange(0,cols),matImageGrey.rowRange(0,rows-2).colRange(0,cols), DV.rowRange(0,rows-2).colRange(0,cols));
  cv::subtract(matImageGrey.rowRange(0,rows).colRange(2,cols),matImageGrey.rowRange(0,rows).colRange(0,cols-2), DH.rowRange(0,rows).colRange(0,cols-2));

  cv::Mat FM = cv::max(DH,DV);
  FM = FM.mul(FM);
  cv::Scalar tempVal = mean( FM );
  float myMatMean = tempVal.val[0];
  return myMatMean;
}

- (double) stdevBlurryCheck:(UIImage *) image {
  // converting UIImage to OpenCV format - Mat
  cv::Mat matImage = [self convertUIImageToCVMat:image];
  cv::Mat matImageGrey;
  // converting image's color space (RGB) to grayscale
  cv::cvtColor(matImage, matImageGrey, CV_BGR2GRAY);

  cv::Mat meanValueImage;
  cv::Mat meanStdValueImage;
  meanStdDev(matImageGrey, meanValueImage, meanStdValueImage);
  double meanValue = 0.0;
  meanValue = meanStdValueImage.at<double>(0, 0);

  return meanValue;
}

- (double) entropyBlurryCheck:(UIImage *) image {
  // converting UIImage to OpenCV format - Mat
  cv::Mat matImage = [self convertUIImageToCVMat:image];
  //开辟内存
  double temp[256] = { 0.0 };

  // 计算每个像素的累积值
  for (int m = 0; m < matImage.rows; m++)
  {// 有效访问行列的方式
      const uchar* t = matImage.ptr<uchar>(m);
      for (int n = 0; n < matImage.cols; n++)
      {
          int i = t[n];
          temp[i] = temp[i] + 1;
      }
  }

  // 计算每个像素的概率
  for (int i = 0; i < 256; i++)
  {
      temp[i] = temp[i] / (matImage.rows*matImage.cols);
  }

  double result = 0;
  // 计算图像信息熵
  for (int i = 0; i < 256; i++)
  {
      if (temp[i] == 0.0)
          result = result;
      else
          result = result - temp[i] * (log(temp[i]) / log(2.0));
  }

  return result;

}

@end
