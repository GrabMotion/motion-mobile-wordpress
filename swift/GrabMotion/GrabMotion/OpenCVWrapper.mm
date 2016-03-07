//
//  OpenCVWrapper.m
//  GrabMotion
//
//  Created by Macbook Pro DT on 3/7/16.
//  Copyright © 2016 GrabMotion Computer Vision. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "OpenCVWrapper.h"
#import "UIImage+OpenCV.h"

#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

@implementation OpenCVWrapper : NSObject

+ (UIImage *)processImageWithOpenCV:(UIImage*)inputImage {
    Mat mat = [inputImage CVMat];
    
    // do your processing here
    ...
    
    return [UIImage imageWithCVMat:mat];
}


+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                     // Width
                                        cvMat.rows,                                     // Height
                                        8,                                              // Bits per component
                                        8 * cvMat.elemSize(),                           // Bits per pixel
                                        cvMat.step[0],                                  // Bytes per row
                                        colorSpace,                                     // Colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
                                        provider,                                       // CGDataProviderRef
                                        NULL,                                           // Decode
                                        false,                                          // Should interpolate
                                        kCGRenderingIntentDefault);                     // Intent
    
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}

@end