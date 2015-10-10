//
//  AppDelegate.m
//  NotesSharingApp
//
//  Created by Heba khan on 19/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TutorialViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#define kClientID @"968760636161-b70lg7g16kcs9k2ln0rd0b239c2hs4ss.apps.googleusercontent.com"


@interface AppDelegate ()

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [GIDSignIn sharedInstance].clientID = kClientID;
    
    UserDetail *userDetail=[[DataManger sharedmanager]getLoogedInUserdetail];
    
    
//    UserDetail *userDetailTutorial=[[DataManger sharedmanagerTutorial]tutorialMethod]; //here get the user prefrerence
    

    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    
   // NSString *storyboardId =userDetail.tutorialAppSeen ? @"signIn" : @"MainVC";
    
   // UIStoryboard *storyboard = self.window.rootViewController.storyboard;
   // id rootViewController = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    
   // if ([rootViewController isKindOfClass:[UIViewController class]])
  //  {
   //     self.window.rootViewController = (UIViewController*)rootViewController;
        
        
        
   // }
  //  else{
  //      self.window.rootViewController = (ViewController*)rootViewController;
   // }
    
    
  
        
        NSString *storyboardId1 =userDetail.isUserKeepLoggedIn ? @"swVC" : @"signIn";
        
        UIStoryboard *storyboard1 = self.window.rootViewController.storyboard;
        id rootViewController1 = [storyboard1 instantiateViewControllerWithIdentifier:storyboardId1];
        
        if ([rootViewController1 isKindOfClass:[UIViewController class]])
        {
            self.window.rootViewController = (UIViewController*)rootViewController1;
            
            
            
        }
        else{
            self.window.rootViewController = (ViewController*)rootViewController1;
        }


    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]];
    

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTranslucent:NO];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
//    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    NSString *name = user.profile.name;
//    NSString *email = user.profile.email;
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    NSLog(@"%@",[url scheme]);
    
    if ([[url scheme]  isEqualToString:@"fb1666504960261727"])
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation
                ];
    }else{
        
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    }
    
   
    
    
    
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  
    
    [FBSDKAppEvents activateApp];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:postNotification object:nil];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}


+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler{
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            // If any error occurs then just display its description on the console.
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    
    // Resume the task.
    [task resume];
}

@end
