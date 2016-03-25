//
//  CVWrapper.h
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


struct ComplexNumber
{
    var real: Float
    var imaginary: Float
}

@interface CVWrapper : NSObject

+ (UIImage*) processImageWithStrToCVMat:(NSString*)strMat;

+ (UIImage*) processImageWithOpenCV: (UIImage*) inputImage;

+ (UIImage*) processWithOpenCVImage1:(UIImage*)inputImage1 image2:(UIImage*)inputImage2;

+ (UIImage*) processWithArray:(NSArray*)imageArray;

+ (NSString*) processProtoToString:(UnsafePoiner<ComplexNumberF>()) user;

@end
