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

-(void)setProfileImageStatus:(BOOL)profileHashKey
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:[NSNumber numberWithBool:profileHashKey] forKey:imageSaveInDefaultsStatus];
    [defaults synchronize];
}
-(BOOL)getProfileImageStatus
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *user = [defaults rm_customObjectForKey:imageSaveInDefaultsStatus];
    return user.boolValue;
}

-(void)setProfileImage:(NSData*)profileHashKey
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:profileHashKey forKey:imageSaveInDefaults];
    [defaults synchronize];
}
-(NSData*)getProfileImage
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
     id user = [defaults rm_customObjectForKey:imageSaveInDefaults];
    return user;
    
}

-(void)loggedinuserDetail:(UserDetail*)userdetail{
    
    _userDetail=userdetail;
    //[self setProfileHashKey:_userDetail.uploadKey];
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

-(void)setMasterLockCode:(NSString *)strLockCode
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:strLockCode forKey:_userDetail.userID];
    [defaults synchronize];
}

-(NSString *)getMasterLockCode
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:_userDetail.userID];
}

-(void)tutorialMethodDetail:(UserDetail*)userdetail{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:userdetail forKey:USERPREFTUTORIAL];
    [defaults synchronize];
    
}

-(UserDetail*)tutorialMethod{
    
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
    [[DataManger sharedmanager]setProfileImage:nil];
    [[DataManger sharedmanager]setProfileImageStatus:NO];
    UserDetail *userdetail=[[UserDetail alloc]init];
    _userDetail=userdetail;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:userdetail forKey:USERPREF];
    [defaults synchronize];
    
}

-(void)setProfileHashKey:(NSString *)profileHashKey
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:profileHashKey forKey:uploadHashKey];
    [defaults synchronize];
    
}
-(NSString *)getProfileHashKey
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults rm_customObjectForKey:uploadHashKey];
}

-(void)setSortBy:(NSString *)sortBy
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:sortBy forKey:uploadSortKey];
    [defaults synchronize];
    
}

-(NSString *)getSortBy
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults rm_customObjectForKey:uploadSortKey];
}



-(NSString *)getUserId
{
    
    return _userDetail.userID;
}

-(void)parsingImageData:(NSString*)fileId
{
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        
        NSString *URLString = [NSString stringWithFormat:@"http://104.154.57.170/user/getupload?file=%@",self.userDetail.uploadKey];
        
        NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        //Perform request and get JSON as a NSData object
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // Parse the retrieved JSON to an NSDictionary
        NSError *error;
        
        if (!data) {
            return;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
        
        
            [self setProfileImage:data];
            [self setProfileImageStatus:YES];
        
            [self.datamanagerdelegate updateProfilePic];
        
        });
    });
    
    
    
    
}




@end
