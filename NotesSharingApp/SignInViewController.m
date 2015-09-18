//
//  SignInViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 20/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "SignInViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SignInViewController ()<GIDSignInDelegate>

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.userName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.userName.delegate=self;
    self.password.delegate=self;
    
    
    //gplus
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)signIn:(id)sender {
}

- (IBAction)signUp:(id)sender {
}

- (IBAction)facebookButton:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut ];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    
    
    [login logInWithReadPermissions:@[@"email",@"public_profile",@"basic_info"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error) {
             // Process error
         } else if (result.isCancelled) {
             // Handle cancellations
         } else {
             // If you ask for multiple permissions at once, you
             // should check if specific permissions missing
             
             if ([result.grantedPermissions containsObject:@"email"]) {
                 if ([FBSDKAccessToken currentAccessToken]) {
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                          if (!error) {
                              NSLog(@"fetched user:%@", result);
                              
                              
                              
                              
                              if ([FBSDKProfile currentProfile])
                              {
                                  NSString *title = [NSString stringWithFormat:@"%@", [FBSDKProfile currentProfile].name];NSString *userID = [NSString stringWithFormat:@"%@", [FBSDKProfile currentProfile].userID];
                                  NSString *firstName = [NSString stringWithFormat:@"%@", [FBSDKProfile currentProfile].firstName];
                                  NSString *lastName = [NSString stringWithFormat:@"%@", [FBSDKProfile currentProfile].lastName];
                                  NSString *middleName = [NSString stringWithFormat:@"%@", [FBSDKProfile currentProfile].middleName];
                                  NSLog(@"{\nName:%@,userID:%@,firstName:%@,lastName:%@,middleName:%@ \n}",title,userID,firstName,lastName,middleName);
                              }
                          }
                      }];
                 }
             }
         }
     }];
    

}

- (IBAction)gmailButton:(id)sender {
    
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [[GIDSignIn sharedInstance] signIn];
    
}

#pragma hideKeyboard

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}



#pragma gmail login

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}


// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    
//    _lblEmail.text=user.profile.email;
//    _lblName.text=user.profile.name;
//    _lblId.text=user.userID;
//    NSURL *profUrl=[user.profile imageURLWithDimension:71];
//    _imgProfile.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:profUrl]];
//    _imgProfile.layer.cornerRadius=_imgProfile.frame.size.height/2.0f;
    
}
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}
- (IBAction)didTapSignOut:(id)sender
{
    [[GIDSignIn sharedInstance] signOut];
}



@end
