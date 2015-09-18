//
//  SignInViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 20/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface SignInViewController : UIViewController<UITextFieldDelegate,GIDSignInUIDelegate>

//Text fields

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;

//buttons

- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;

- (IBAction)facebookButton:(id)sender;
- (IBAction)gmailButton:(id)sender;



//gmail
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@end
