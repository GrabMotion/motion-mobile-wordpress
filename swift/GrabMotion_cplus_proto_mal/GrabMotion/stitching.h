//
//  stitching.h
//  CVOpenTemplate
//
//  Created by Foundry on 05/01/2013.
//  Copyright (c) 2013 Foundry. All rights reserved.
//

#ifndef CVOpenTemplate_Header_h
#define CVOpenTemplate_Header_h
#include <opencv2/opencv.hpp>


cv::Mat stringToMat (std::string * decodedstr);

cv::Mat stitch (std::vector <cv::Mat> & images);

std::string base64_decode(std::string const& s);

#endif
