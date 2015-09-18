//
//  DataManger.m
//  CekretChatApplication
//  Created by Heba Khan on 28/11/2014.
//  Copyright (c) 2014 Nisakii. All rights reserved.

#import "DataManger.h"

@implementation DataManger

+(id)sharedmanager{ //this will initilize once
    
    
    static id datamangare=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datamangare=[[DataManger alloc]init];
    });
    return datamangare;
}

-(void)loggedinuserDetail:(UserDetail*)userdetail{

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:userdetail forKey:USERPREF];
    [defaults synchronize];
    
}

-(UserDetail*)getLoogedInUserdetail
{
     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    id user = [defaults rm_customObjectForKey:USERPREF];
    
    if (user) //if we get saved preference
    {
        UserDetail *userdetail=(UserDetail*)user;
        _userDetail=userdetail;
    }
    else //if we not get saved preference

    {
        UserDetail *userdetail=[[UserDetail alloc]init];
        _userDetail=userdetail;
    }
    return _userDetail;
}

-(void)tutorialMethodDetail:(UserDetail*)userdetail{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:userdetail forKey:USERPREFTUTORIAL];
    [defaults synchronize];
    
}

-(UserDetail*)tutorialMethod{

    
  //  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  //  id tutorialYes = [defaults rm_customObjectForKey:USERPREFTUTORIAL];
   // UserDetail *tutorialresult=(UserDetail*)tutorialYes;
  //  _tutorialResult=tutorialResult;
  //  [defaults synchronize];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    id tutorialYes = [defaults rm_customObjectForKey:USERPREFTUTORIAL];
    
    if (tutorialYes) //if we get saved preference
    {
        UserDetail *tutorialresult=(UserDetail*)tutorialYes;
        _tutorialResult=tutorialresult;
    }
    else //if we not get saved preference
        
    {
        UserDetail *tutorialresult=[[UserDetail alloc]init];
        _tutorialResult=tutorialresult;
    }
    
    return _tutorialResult;
}

-(void)logoutUser 
{
    UserDetail *userdetail=[[UserDetail alloc]init];
    _userDetail=userdetail;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:userdetail forKey:USERPREF];
    [defaults synchronize];
    
}

@end
