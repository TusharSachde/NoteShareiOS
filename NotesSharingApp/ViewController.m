//
//  ViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 19/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.firstName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.lastName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.email setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    self.email.delegate = self;
    self.password.delegate = self;
    self.confirmPassword.delegate = self;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(id)sender {
}

- (IBAction)signIn:(id)sender {
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
}

#pragma hideKeyboard

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
    
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}


//delegates for scroll view method


@end
