//
//  UIColor+hexColor.h
//  SISMCFootBallV4
//
//  Created by NaveenA on 09/05/14.
//  Copyright (c) 2014 NaveenA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hexColor)
+(UIColor*)si_getColorWithHexString:(NSString*)hexString;
+(UIColor*)si_visibleTextColorOnBackgroundColor:(UIColor*)backgroundColor;
+ (UIColor *) si_colorWithHex:(int)hex;
@end
