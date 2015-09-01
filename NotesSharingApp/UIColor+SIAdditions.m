//
//  UIColor+hexColor.m
//  SISMCFootBallV4
//
//  Created by NaveenA on 09/05/14.
//  Copyright (c) 2014 NaveenA. All rights reserved.
//

#define SMCUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SMCUIColorFromRGBA(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
#import "UIColor+SIAdditions.h"
@implementation UIColor (hexColor)

+(UIColor*)si_getColorWithHexString:(NSString*)hexString
{
    
    
    //NSString *jerseyColorHex=hexString;
    
    
//    if (!jerseyColorHex)
//    {
//        jerseyColorHex = @"";
//    }
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    unsigned int intColor =0;
    NSScanner* scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&intColor];
    UIColor* color;
    if (hexString.length)
    {
        color = SMCUIColorFromRGB(intColor);
    }
    
    return color;
}

+(UIColor*)si_visibleTextColorOnBackgroundColor:(UIColor*)backgroundColor
{
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    BOOL foundRgb = NO;
    foundRgb = [backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    if (!foundRgb)
    {
        CGFloat white = 0.0;
        [backgroundColor getWhite:&white alpha:&alpha];
        red=green=blue=white;
    }
    
    double a = 1-(0.299 * red + 0.587 * green + 0.114 * blue);
    UIColor* textColor;
    if (a<.5) textColor = [UIColor blackColor];
    else textColor = [UIColor whiteColor];
    return textColor;
    
}

+ (UIColor *) si_colorWithHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}
@end
