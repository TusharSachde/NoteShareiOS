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
//#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UserDetail *userDetail=[[DataManger sharedmanager]tutorialMethod]; //here get the user prefrerence,saved during login
    
    
    

    
    
//    NSLog(@"%@",[UIFont familyNames]);
//    
//    for (NSString *fonts in [UIFont familyNames])
//    {
//        NSLog(@"fonts array{\n %@ \n}",[UIFont fontNamesForFamilyName:fonts]);
//    }
    
    
    NSString *storyboardId =userDetail.tutorialAppSeen ? @"signIn" : @"MainVC";
    
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    id rootViewController = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    
    if ([rootViewController isKindOfClass:[UIViewController class]])
    {
        self.window.rootViewController = (UIViewController*)rootViewController;
        
        
        
    }
    else{
        self.window.rootViewController = (ViewController*)rootViewController;
    }
    
  //  [self configurePushNotiFication:launchOptions applictaion:application];
    
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]];
    

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTranslucent:NO];
    
    return YES;
    
//    
//    [[FBSDKApplicationDelegate sharedInstance] application:application
//                             didFinishLaunchingWithOptions:launchOptions]
    
   // return YES;
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return YES;
    
//    
//    [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                   openURL:url
//                                         sourceApplication:sourceApplication
//                                                annotation:annotation]
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   // [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
