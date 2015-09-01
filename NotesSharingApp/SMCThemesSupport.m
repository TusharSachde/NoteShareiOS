//
//  SMCGraphics.m
//  SMCFootballV4
//
//  Created by Naveen Aranha on 29/04/14.
//  Copyright (c) 2014 SI. All rights reserved.
//

#import "SMCThemesSupport.h"

@implementation SMCThemesSupport


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
@end
