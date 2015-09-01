//
//  UIImage+Coloring.h
//  SMCFootballV4
//
//  Created by Naveen Aranha on 30/04/14.
//  Copyright (c) 2014 SI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SIAdditions)
-(UIImage*) si_imageWithColorOverlay:(UIColor*)color;
-(UIImage*) si_imageWithColorUnderlay:(UIColor*)color;
+(UIImage *)si_imageWithColor:(UIColor *)color andSize:(CGSize)size ;
+(UIImage*)si_imageWithImage:(UIImage *)image orientation:(UIImageOrientation)orientation;
-(UIImage*)si_scaletoSize:(CGSize)newSize;
//+(UIImage *)si_SetColorInImage:(NSString*)imageName withColor:(UIColor*)color;
+ (UIImage *)si_convertToGreyscale:(UIImage *)images;

//+ (UIImage)getBackGroundImage:(UIImage *)images;
@end
