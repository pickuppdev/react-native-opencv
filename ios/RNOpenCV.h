#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import "OpenCV/imgproc/imgproc.hpp"

@interface RNOpenCV : NSObject <RCTBridgeModule>

@end
