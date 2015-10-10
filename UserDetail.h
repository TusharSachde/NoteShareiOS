//
//  UserDetail.h
//  CekretChatApplication
//  Created by Heba Khan on 28/11/2014.
//  Copyright (c) 2014 Nisakii. All rights reserved.

#import <Foundation/Foundation.h>

@interface UserDetail : NSObject


@property(nonatomic,strong)NSString *Tutorial;
@property(nonatomic)BOOL tutorialAppSeen;

@property(nonatomic)BOOL isUserKeepLoggedIn;
@property(nonatomic,strong)NSString *userEmail;
@property(nonatomic,strong)NSString *userPassword;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userID;
@property(nonatomic,strong)NSString *uploadKey;

@end
