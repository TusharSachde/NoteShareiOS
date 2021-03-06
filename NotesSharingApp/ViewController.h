//
//  ViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 19/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleSignIn/GoogleSignIn.h>


@interface ViewController : UIViewController<UITextFieldDelegate,GIDSignInUIDelegate>


//text fields

@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

//Buttons

- (IBAction)signUp:(id)sender;
- (IBAction)signIn:(id)sender;

- (IBAction)facebookButton:(id)sender;
- (IBAction)gmailButton:(id)sender;


@end

