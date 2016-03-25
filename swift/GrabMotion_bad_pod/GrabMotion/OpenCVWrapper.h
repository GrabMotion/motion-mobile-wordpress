//
//  OpenCVWrapper..h
//  GrabMotion
//
//  Created by Macbook Pro DT on 3/7/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

#ifndef OpenCVWrapper__h
#define OpenCVWrapper__h


#endif /* OpenCVWrapper__h */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface OpenCVWrapper : NSObject

+ (UIImage *)processImageWithOpenCV:(UIImage*)inputImage;
+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat;

@end
