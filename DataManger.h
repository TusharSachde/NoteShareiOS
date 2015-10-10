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

#define postNotification @"PostNotification"
#define masterLock @"ISEnable"
#define uploadHashKey @"isHashKey"
#define uploadSortKey @"isSorted"
#define imageSaveInDefaults @"imageSave"
#define imageSaveInDefaultsStatus @"imageSaveStatus"




@protocol DataManageDelegate <NSObject>

-(void)updateProfilePic;

@end

@interface DataManger : NSObject

@property(nonatomic,strong)UserDetail *userDetail;
@property(nonatomic,strong)UserDetail *tutorialResult;
-(void)loggedinuserDetail:(UserDetail*)userdetail;
+(id)sharedmanager;
+(id)sharedmanagerTutorial;
-(UserDetail*)getLoogedInUserdetail;
-(void)logoutUser;
-(UserDetail*)tutorialMethod;
-(void)tutorialMethodDetail:(UserDetail*)userdetail;

-(void)setMasterLockCode:(NSString*)strLockCode;
-(NSString*)getMasterLockCode;

-(void)setProfileHashKey:(NSString*)profileHashKey;
-(NSString*)getProfileHashKey;


-(void)setSortBy:(NSString*)sortBy;
-(NSString*)getSortBy;


-(void)setProfileImage:(NSData*)profileHashKey;
-(NSData*)getProfileImage;

-(void)setProfileImageStatus:(BOOL)profileHashKey;
-(BOOL)getProfileImageStatus;

-(NSString*)getUserId;
-(void)parsingImageData:(NSString*)fileId;

@property(nonatomic,weak)id<DataManageDelegate> datamanagerdelegate;

@end
