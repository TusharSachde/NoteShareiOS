//
//  DataManger.h
//  CekretChatApplication
//  Created by Heba Khan on 28/11/2014.
//  Copyright (c) 2014 Nisakii. All rights reserved.

#import <Foundation/Foundation.h>
#import "UserDetail.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#define USERPREF @"userpref"
#define USERPREFTUTORIAL @"userTutorialYes"

@interface DataManger : NSObject

@property()UserDetail *userDetail;
@property()UserDetail *tutorialResult;
-(void)loggedinuserDetail:(UserDetail*)userdetail;
+(id)sharedmanager;
-(UserDetail*)getLoogedInUserdetail;
-(void)logoutUser;
-(UserDetail*)tutorialMethod;
-(void)tutorialMethodDetail:(UserDetail*)userdetail;


@end
