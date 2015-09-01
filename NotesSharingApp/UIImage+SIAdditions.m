//
//  UIImage+Coloring.m
//  SMCFootballV4
//
//  Created by Naveen Aranha on 30/04/14.
//  Copyright (c) 2014 SI. All rights reserved.
//

#import "UIImage+SIAdditions.h"

@implementation UIImage (SIAdditions)
+ (UIImage *)si_convertToGreyscale:(UIImage *)images
{
    
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen | kBlue | kRed;
    int m_width = images.size.width;
    int m_height = images.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [images CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultUIImage;
}
-(UIImage*) si_imageWithColorOverlay:(UIColor*)color
{
    //create context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //drawingcode
    //bg
    CGRect rect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);

    [self drawInRect:rect];
    
    //fg
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    //mask
    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
    
    //end
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(UIImage*) si_imageWithColorUnderlay:(UIColor*)color
{
    //create context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //drawingcode
    //bg
    CGRect rect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    
    [self drawInRect:rect];
    
    //fg
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    [self drawInRect:rect];
    //mask
  //  [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
    
    //end
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+(UIImage *)si_imageWithColor:(UIColor *)color andSize:(CGSize)size {
    //Create a context of the appropriate size
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //Build a rect of appropriate size at origin 0,0
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    
    //Set the fill color
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    
    //Fill the color
    CGContextFillRect(currentContext, fillRect);
    
    //Snap the picture and close the context
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retval;
}

+(UIImage*)si_imageWithImage:(UIImage *)image orientation:(UIImageOrientation)orientation
{
    UIImage* flippedImage = [UIImage imageWithCGImage:image.CGImage
                                                scale:image.scale
                                          orientation: orientation];
    return flippedImage;
}


//+(UIImage) getBackGroundImage:(UIImage *)images{
//    return nil;
//}

//-(UIImage *) si_scaledToSize:(CGSize)newSize keepAspectRatio:(BOOL)keepAspectRatio
//{
//    //UIGraphicsBeginImageContext(newSize);
//    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
//    // Pass 1.0 to force exact pixel size.
//
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
-(UIImage*)si_scaletoSize:(CGSize)newSize
{
//    float actualHeight = self.size.height;
//    float actualWidth = self.size.width;
//    float imgRatio = actualWidth/actualHeight;
//    float maxRatio = 320.0/480.0;
//    
//    if(imgRatio!=maxRatio){
//        if(imgRatio < maxRatio){
//            imgRatio = 480.0 / actualHeight;
//            actualWidth = imgRatio * actualWidth;
//            actualHeight = 480.0;
//        }
//        else{
//            imgRatio = 320.0 / actualWidth;
//            actualHeight = imgRatio * actualHeight;
//            actualWidth = 320.0;
//        }
//    }
//    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
//    UIGraphicsBeginImageContext(rect.size);
//    [self drawInRect:rect];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
    
    //newSize = CGSizeMake(newSize.width*2, newSize.height*2);
    float width = newSize.width;
    float height = newSize.height;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    //UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = self.size.width / width;
    float heightRatio = self.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = self.size.width / divisor;
    height = self.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    //indent in case of width or height difference
//    float offset = (width - height) / 2;
//    if (offset > 0) {
//        rect.origin.y = offset;
//    }
//    else {
//        rect.origin.x = -offset;
//    }
    
    [self drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}
//+(UIImage *)si_SetColorInImage:(NSString*)imageName withColor:(UIColor*)color
//{
//    UIImage *image = [UIImage imageNamed:imageName];//@"jersey.png"
//    
//    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextClipToMask(context, rect, image.CGImage);
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage
//                                                scale:1.0 orientation: UIImageOrientationDownMirrored];
//    
//    return flippedImage;
//}

@end
