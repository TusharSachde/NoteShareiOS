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
#import "NSDictionary+SIAdditions.h"
#import "DataManger.h"

@interface ViewController ()<GIDSignInDelegate>

@property(nonatomic,strong)NSDictionary *userDetailsDictionary;
@property(nonatomic,strong)NSString *userIDFacebook;
@property(nonatomic,strong)NSString *emailFacebook;
@property(nonatomic,strong)NSString *userNameFacebook;
@property(nonatomic,strong)NSString *userIDGmail;
@property(nonatomic,strong)NSString *emailGmail;
@property(nonatomic,strong)NSString *userNameGmail;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeProfileChange:) name:FBSDKProfileDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];
    
    [_loader stopAnimating];
    _loader.hidden=YES;
    
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

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = tag;
    [alertView show];
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
    
    [self signUp];
    [_loader startAnimating];
    _loader.hidden=NO;
}

- (IBAction)signIn:(id)sender {
    
}

-(BOOL)isValidateField
{
    if ((!_firstName.text.length>0)) {
        
        [self alertStatus:@"Firstname should not be blank" :@"" :-1];
        return NO;
    }else
    if ((!_lastName.text.length>0)) {
        
        [self alertStatus:@"Lastname should not be blank" :@"" :-1];
        return NO;
    }
    else
    if (!_email.text.length>0)
    {
        [self alertStatus:@"Username/Email should not be blank" :@"" :-1];
        return NO;
    }
    else
        if (![self NSStringIsValidEmail:_email.text])
        {
            [self alertStatus:@"Email should be proper" :@"" :-1];
            return NO;
        }
    
    else  if (!_password.text.length>0)
    {
        [self alertStatus:@"Password should not be blank" :@"" :-1];
        return NO;
    }
    else if(_password.text.length<6)
    {
        [self alertStatus:@"Password should be atleast 6 digit " :@"" :-1];
        return NO;
    }
    else if (!_confirmPassword.text.length>0)
    {
        [self alertStatus:@"Confirm Password should not be blank " :@"" :-1];
        return NO;
    }
    else if(_confirmPassword.text.length<6)
    {
        [self alertStatus:@"Confirm Password should be atleast 6 digit " :@"" :-1];
        return NO;
    }
    else if(![_confirmPassword.text isEqualToString:_password.text])
    {
        [self alertStatus:@"Password and Confirm Password mismatch" :@"" :-1];
        return NO;
    }
    
    
    return YES;
    
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)signUp{

    if ([self isValidateField])
    {
        
        
    [_loader startAnimating];
        _loader.hidden=NO;
            
            UserDetail *userDetail=[[UserDetail alloc]init];
            userDetail.isUserKeepLoggedIn=NO;
            
          
            
            NSString *URLString = [NSString stringWithFormat:@"http://104.154.57.170/user/save"];
            NSMutableDictionary *dictParameter=[[NSMutableDictionary alloc]init];
            
            
            [dictParameter setObject:_firstName.text forKey:@"username"];
            [dictParameter setObject:_password.text forKey:@"password"];
            [dictParameter setObject:_email.text forKey:@"email"];
            
       
            
            
            NSData *dataobject=[NSJSONSerialization dataWithJSONObject:dictParameter options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *strparameter=[[NSString alloc]initWithData:dataobject encoding:NSUTF8StringEncoding];
            
            
            NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSMutableURLRequest *requestPost=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            [requestPost setHTTPMethod:@"POST"];
            requestPost.HTTPBody=[strparameter dataUsingEncoding:NSUTF8StringEncoding];
            [requestPost setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            NSError *requestError=nil;
            NSURLResponse *response = nil;
            NSData *data=[NSURLConnection sendSynchronousRequest:requestPost returningResponse:&response error:&requestError];
            
            
            if (requestError == nil) {
                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                    if (statusCode != 200) {
                        NSLog(@"Warning, status code of response was not 200, it was %ld", (long)statusCode);
                    }
                }
                
                
                
                NSError *error;
                
                NSDictionary *returnDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                self.userDetailsDictionary = [[returnDictionary objectForKey:@"response"]objectAtIndex:0];
            
                
                
                if (returnDictionary)
                {
                    
                    BOOL value =[[returnDictionary objectForKey:@"value"] boolValue];
                    NSString *userId =[returnDictionary objectForKey:@"_id"];
                    
                    NSLog(@"%@", userId);
                    
                    if(value)
                    {
                        NSLog(@"returnDictionary=%@", returnDictionary);
                        
                        
                        userDetail.isUserKeepLoggedIn=YES;
                        userDetail.userName=[_firstName text];
                        userDetail.userEmail=[_email text];
                        userDetail.userID=[returnDictionary objectForKey:@"_id"];
                        [[DataManger sharedmanager]loggedinuserDetail:userDetail];
                        
                        //save prefrence here it
                        [[DataManger sharedmanager]loggedinuserDetail:userDetail];
                        [_loader stopAnimating];
                        _loader.hidden=YES;
                        [self performSegueWithIdentifier:@"success" sender:self];
                        
                    }
                    
                    else
                    {
                        
                        
                        NSLog(@"failed");
                        
                        [self alertStatus:[returnDictionary objectForKey:@"comment"] :@"ALERT" :0];
                        [_loader stopAnimating];
                        _loader.hidden=YES;
                    }
                }
                
                else
                {
                    NSLog(@"error parsing JSON response: %@", error);
                    
                    NSString *returnString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                    NSLog(@"returnString: %@", returnString);
                    [_loader stopAnimating];
                    _loader.hidden=YES;
                }
            }
            
            else
                
            {
                NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
                //[self alertStatus:@"Poor Network" :@"Please check your network and try again" :0];
                [_loader stopAnimating];
                _loader.hidden=YES;
            }

        }
}



#pragma mark-Facebook login observer

- (void)observeProfileChange:(NSNotification *)notfication
{
    //FBSDKProfile* profile= [FBSDKProfile currentProfile];
    
    if ([FBSDKProfile currentProfile])
    {
       
        
        
    }
    
}



- (void)observeTokenChange:(NSNotification *)notfication
{
    if (![FBSDKAccessToken currentAccessToken])
    {
        // [self observeProfileChange:nil];
        
    } else
    {
        
    }
}





- (IBAction)facebookButton:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    // [login logOut ];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [_loader startAnimating];
    _loader.hidden=NO;
    
    [login logInWithReadPermissions:@[@"email",@"public_profile",@"basic_info"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error) {
             // Process error
         } else if (result.isCancelled) {
             // Handle cancellations
         } else {
             // If you ask for multiple permissions at once, you
             // should check if specific permissions missing
             
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id,name,email,first_name,link,last_name,picture" forKey:@"fields"];
             
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                  if (!error)
                  {
                      NSLog(@"fetched user:%@", result);
                      
                      
                      
                      
                      NSMutableDictionary *dictUserInfo=[[NSMutableDictionary alloc]init];
                      
                      NSString *title = [NSString stringWithFormat:@"%@", [(NSMutableDictionary*)result si_objectOrNilForKey:@"name"]];
                      _userIDFacebook = [NSString stringWithFormat:@"%@", [(NSMutableDictionary*)result si_objectOrNilForKey:@"id"]];
                      _userNameFacebook = [NSString stringWithFormat:@"%@", [(NSMutableDictionary*)result si_objectOrNilForKey:@"first_name"]];
                      NSString *lastName = [NSString stringWithFormat:@"%@", [(NSMutableDictionary*)result si_objectOrNilForKey:@"last_name"]];
                      
                      _emailFacebook = [(NSMutableDictionary*)result si_objectOrNilForKey:@"email"];
                      
                      NSString *profilePic = [NSString stringWithFormat:@"%@", [[[(NSMutableDictionary*)result si_objectOrNilForKey:@"picture"] si_objectOrNilForKey:@"data"] si_objectOrNilForKey:@"url"]];
                      
                      NSLog(@"{\nName:%@,userID:%@,firstName:%@,lastName:%@,email:%@ \n}",title,_userIDFacebook,_userNameFacebook,lastName,_emailFacebook);
                      
                      
                      [dictUserInfo setObject:_userIDFacebook forKey:@"SocialId"];
                      [dictUserInfo setObject:title forKey:@"FullName"];
                      [dictUserInfo setObject:@"2" forKey:@"ClientId"];
                      [dictUserInfo setObject:profilePic forKey:@"ImgURL"];
                      [dictUserInfo setObject:@"" forKey:@"Dob"];
                      [dictUserInfo setObject:@"" forKey:@"Gender"];
                      [dictUserInfo setObject:@"" forKey:@"GUID"];
                      [dictUserInfo setObject:_userNameFacebook forKey:@"UserName"];
                      
                      if (_emailFacebook)
                      {
                          
                          
                      }
                      else{
                          
                      }
                      
                      
                      [self LoginFacebook];
                      
                      
                      
                  }
                  
              }];
         }
     }];
    


}

-(void)registerFacebook{
    
    UserDetail *userDetail=[[UserDetail alloc]init];
    userDetail.isUserKeepLoggedIn=NO;
    [_loader startAnimating];
    _loader.hidden=NO;
    
    
    
    NSString *URLString = [NSString stringWithFormat:@"http://104.154.57.170/user/save"];
    
    
    NSMutableDictionary *dictParameter=[[NSMutableDictionary alloc]init];
    
    
    [dictParameter setObject:_userNameFacebook forKey:@"username"];
    [dictParameter setObject:_emailFacebook forKey:@"email"];
    [dictParameter setObject:_userIDFacebook forKey:@"fbid"];
    
    
    
    
    
    NSData *dataobject=[NSJSONSerialization dataWithJSONObject:dictParameter options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *strparameter=[[NSString alloc]initWithData:dataobject encoding:NSUTF8StringEncoding];
    
    
    NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *requestPost=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [requestPost setHTTPMethod:@"POST"];
    requestPost.HTTPBody=[strparameter dataUsingEncoding:NSUTF8StringEncoding];
    [requestPost setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *requestError=nil;
    NSURLResponse *response = nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:requestPost returningResponse:&response error:&requestError];
    
    
    if (requestError == nil) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Warning, status code of response was not 200, it was %ld", (long)statusCode);
            }
        }
        
        
        
        NSError *error;
        
        NSDictionary *returnDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        self.userDetailsDictionary = [[returnDictionary objectForKey:@"response"]objectAtIndex:0];
      
    
        
        
        if (returnDictionary)
        {
            
            BOOL value =[[returnDictionary objectForKey:@"value"] boolValue];
            NSString *userId =[returnDictionary objectForKey:@"_id"];
            
            NSLog(@"%@", userId);
            
            if(value)
            {
                NSLog(@"returnDictionary=%@", returnDictionary);
                
                
                userDetail.isUserKeepLoggedIn=YES;
                userDetail.userName=_userNameFacebook;
                userDetail.userEmail=_emailFacebook;
                userDetail.userID=[returnDictionary objectForKey:@"_id"];
                [[DataManger sharedmanager]loggedinuserDetail:userDetail];
                
                //save prefrence here it
                [[DataManger sharedmanager]loggedinuserDetail:userDetail];
                
                if (userDetail.uploadKey)
                {
                    //mainVC
                    [self performSegueWithIdentifier:@"mainVC" sender:self];
                    [self getProfilePic];
                    
                    
                }else
                {
                    [self performSegueWithIdentifier:@"success" sender:self];
                    NSLog(@"success");
                    
                }
                
                [_loader stopAnimating];
                _loader.hidden=YES;
                //[self LoginFacebook];
                
            }
            
            else
            {
                
                //[self LoginFacebook];
                NSLog(@"failed");
               
                    
                    NSLog(@"failed");
                    [self alertStatus:[returnDictionary objectForKey:@"comment"] :@"ALERT" :0];
                [_loader stopAnimating];
                _loader.hidden=YES;
              
                
            }
        }
        
        else
        {
            NSLog(@"error parsing JSON response: %@", error);
            
            NSString *returnString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            NSLog(@"returnString: %@", returnString);
            [_loader stopAnimating];
            _loader.hidden=YES;
        }
    }
    
    else
        
    {
        NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
        //[self alertStatus:@"Poor Network" :@"Please check your network and try again" :0];
        [_loader stopAnimating];
        _loader.hidden=YES;
    }
    
}

-(void)LoginFacebook{
    
    UserDetail *userDetail=[[UserDetail alloc]init];
    userDetail.isUserKeepLoggedIn=NO;
    
    [_loader startAnimating];
    _loader.hidden=NO;
    //if (self.mobile.text.length>0)userDetail.userEmail=self.mobile.text;
    
    
    NSString *URLString = [NSString stringWithFormat:@"http://104.154.57.170/user/login"];
    
    
    NSMutableDictionary *dictParameter=[[NSMutableDictionary alloc]init];
    
    
    
    [dictParameter setObject:_userNameFacebook forKey:@"username"];
    [dictParameter setObject:_emailFacebook forKey:@"email"];
    [dictParameter setObject:_userIDFacebook forKey:@"fbid"];
    
    
    
    
    
    NSData *dataobject=[NSJSONSerialization dataWithJSONObject:dictParameter options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *strparameter=[[NSString alloc]initWithData:dataobject encoding:NSUTF8StringEncoding];
    
    
    NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *requestPost=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [requestPost setHTTPMethod:@"POST"];
    requestPost.HTTPBody=[strparameter dataUsingEncoding:NSUTF8StringEncoding];
    [requestPost setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *requestError=nil;
    NSURLResponse *response = nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:requestPost returningResponse:&response error:&requestError];
    
    
    if (requestError == nil) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Warning, status code of response was not 200, it was %ld", (long)statusCode);
            }
        }
        
        NSError *error;
        
        NSDictionary *returnDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        //self.userDetailsDictionary = [[returnDictionary objectForKey:@"response"]objectAtIndex:0];
    
        
        
        if (returnDictionary)
        {
            NSString *strName = [returnDictionary objectForKey:@"username"];
            NSString *strEmail = [returnDictionary objectForKey:@"email"];
            NSString *strID = [returnDictionary objectForKey:@"_id"];
           // BOOL status =[[returnDictionary objectForKey:@"value"] boolValue];
         
            //NSLog(@"%@", status);
            
            if([[returnDictionary objectForKey:@"isreg"] boolValue])
            {
                NSLog(@"returnDictionary=%@", returnDictionary);
                
                
                userDetail.isUserKeepLoggedIn=YES;
                userDetail.userName=strName;
                userDetail.userEmail=strEmail;
                userDetail.userID=strID;
                NSString *uploadKey = [returnDictionary objectForKey:@"profilepic"];
                userDetail.uploadKey=uploadKey;
                
                [[DataManger sharedmanager]loggedinuserDetail:userDetail];
                
                //save prefrence here it
                [[DataManger sharedmanager]loggedinuserDetail:userDetail];
                
                if (userDetail.uploadKey)
                {
                    //mainVC
                    [self performSegueWithIdentifier:@"mainVC" sender:self];
                    [self getProfilePic];
                    
                    
                }else
                {
                    [self performSegueWithIdentifier:@"success" sender:self];
                    NSLog(@"success");
                    
                }
                
                
                [_loader stopAnimating];
                _loader.hidden=YES;
                
            }
            
            else if(![[returnDictionary objectForKey:@"value"] boolValue])
            {
                
                
                [self registerFacebook];
                [_loader stopAnimating];
                _loader.hidden=YES;
                
            }
        }
        
        else
        {
            NSLog(@"error parsing JSON response: %@", error);
            
            NSString *returnString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            NSLog(@"returnString: %@", returnString);
            [_loader stopAnimating];
            _loader.hidden=YES;
        }
    }
    
    else
        
    {
        NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
        [_loader stopAnimating];
        _loader.hidden=YES;
        
    }
 
}



- (IBAction)gmailButton:(id)sender {
    
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [[GIDSignIn sharedInstance]signOut];;
    [[GIDSignIn sharedInstance] signIn];
    [_loader startAnimating];
    _loader.hidden=NO;
    
    
}



- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
  
}

// Present a view that prompts the user to sign in with ide
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
    
    if (!error)
    {
        _emailGmail=user.profile.email;
        _userNameGmail=user.profile.name;
        _userIDGmail=user.userID;
        
        [self LoginGmail];
    }
    
    
    
}


- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    
}


-(void)registerGmail{
    
    
    UserDetail *userDetail=[[UserDetail alloc]init];
    userDetail.isUserKeepLoggedIn=NO;
    
    [_loader startAnimating];
    _loader.hidden=NO;

    NSString *URLString = [NSString stringWithFormat:@"http://104.154.57.170/user/save"];
    
    
    NSMutableDictionary *dictParameter=[[NSMutableDictionary alloc]init];
    
    
    [dictParameter setObject:_userNameGmail forKey:@"username"];
    [dictParameter setObject:_emailGmail forKey:@"email"];
    [dictParameter setObject:_userIDGmail forKey:@"googleid"];
    

    NSData *dataobject=[NSJSONSerialization dataWithJSONObject:dictParameter options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *strparameter=[[NSString alloc]initWithData:dataobject encoding:NSUTF8StringEncoding];
    
    
    NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *requestPost=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [requestPost setHTTPMethod:@"POST"];
    requestPost.HTTPBody=[strparameter dataUsingEncoding:NSUTF8StringEncoding];
    [requestPost setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *requestError=nil;
    NSURLResponse *response = nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:requestPost returningResponse:&response error:&requestError];
    
    
    if (requestError == nil) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Warning, status code of response was not 200, it was %ld", (long)statusCode);
            }
        }
        
        
        
        NSError *error;
        
        NSDictionary *returnDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        self.userDetailsDictionary = [[returnDictionary objectForKey:@"response"]objectAtIndex:0];
        
        
       
        //NSLog(@"%@", value);
        
        
        if (returnDictionary)
        {
            
            
            BOOL value =[[returnDictionary objectForKey:@"value"] boolValue];
            NSString *userId =[returnDictionary objectForKey:@"_id"];
             NSLog(@"%@", userId);
            
            if(value)
            {
                NSLog(@"returnDictionary=%@", returnDictionary);
                
                
                userDetail.isUserKeepLoggedIn=YES;
                userDetail.userName=_userNameGmail;
                userDetail.userEmail =_emailGmail;
                userDetail.userID=[returnDictionary objectForKey:@"_id"];
                [[DataManger sharedmanager]loggedinuserDetail:userDetail];
                
                //save prefrence here it
                [[DataManger sharedmanager]loggedinuserDetail:userDetail];
                
                if (userDetail.uploadKey)
                {
                    //mainVC
                    [self performSegueWithIdentifier:@"mainVC" sender:self];
                    [self getProfilePic];
                    
                    
                }else
                {
                    [self performSegueWithIdentifier:@"success" sender:self];
                    NSLog(@"success");
                    
                }
                
                [_loader stopAnimating];
                _loader.hidden=YES;
                
            }
            
            else
                
            {
    
                NSLog(@"failed");
                [self alertStatus:[returnDictionary objectForKey:@"comment"] :@"ALERT" :0];
                [_loader stopAnimating];
                _loader.hidden=YES;
                
            }
        }
        
        else
        {
            NSLog(@"error parsing JSON response: %@", error);
            
            NSString *returnString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            NSLog(@"returnString: %@", returnString);
            [_loader stopAnimating];
            _loader.hidden=YES;
        }
    }
    
    else
        
    {
        NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
        [_loader stopAnimating];
        _loader.hidden=YES;
    }
    
}




-(void)LoginGmail{
    
    
    
    UserDetail *userDetail=[[UserDetail alloc]init];
    userDetail.isUserKeepLoggedIn=NO;
    
    
    //if (self.mobile.text.length>0)userDetail.userEmail=self.mobile.text;
    
    
    NSString *URLString = [NSString stringWithFormat:@"http://104.154.57.170/user/login"];
    
    
    NSMutableDictionary *dictParameter=[[NSMutableDictionary alloc]init];
    
    
    [dictParameter setObject:_emailGmail forKey:@"email"];
    [dictParameter setObject:_userIDGmail forKey:@"googleid"];
    

    
    NSData *dataobject=[NSJSONSerialization dataWithJSONObject:dictParameter options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *strparameter=[[NSString alloc]initWithData:dataobject encoding:NSUTF8StringEncoding];
    
    
    NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *requestPost=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [requestPost setHTTPMethod:@"POST"];
    requestPost.HTTPBody=[strparameter dataUsingEncoding:NSUTF8StringEncoding];
    [requestPost setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *requestError=nil;
    NSURLResponse *response = nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:requestPost returningResponse:&response error:&requestError];
    
    
    if (requestError == nil) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Warning, status code of response was not 200, it was %ld", (long)statusCode);
            }
        }
        
        NSError *error;
        
        NSDictionary *returnDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        //self.userDetailsDictionary = [[returnDictionary objectForKey:@"response"]objectAtIndex:0];

        if (returnDictionary)
        {
           id objectValue=[returnDictionary objectForKey:@"value"];
            
           
                if ([[returnDictionary objectForKey:@"isreg"] boolValue])
                {
                    NSString *strName = [returnDictionary objectForKey:@"username"];
                    NSString *strEmail = [returnDictionary objectForKey:@"email"];
                    NSString *strID = [returnDictionary objectForKey:@"_id"];
                    BOOL status =[[returnDictionary objectForKey:@"isreg"] boolValue];
                    
                    
                    if(status)
                    {
                        NSLog(@"returnDictionary=%@", returnDictionary);
                        
                        
                        userDetail.isUserKeepLoggedIn=YES;
                        userDetail.userName=strName;
                        userDetail.userEmail=strEmail;
                        userDetail.userID=strID;
                        NSString *uploadKey = [returnDictionary objectForKey:@"profilepic"];
                        userDetail.uploadKey=uploadKey;
                        
                        [[DataManger sharedmanager]loggedinuserDetail:userDetail];
                        
                        //save prefrence here it
                        [[DataManger sharedmanager]loggedinuserDetail:userDetail];
                        
                        
                        if (userDetail.uploadKey)
                        {
                            //mainVC
                             [self performSegueWithIdentifier:@"mainVC" sender:self];
                            [self getProfilePic];
                            
                            
                        }else
                        {
                            [self performSegueWithIdentifier:@"success" sender:self];
                            NSLog(@"success");
                            
                        }
                        
                        [_loader stopAnimating];
                        _loader.hidden=YES;
                        
                        
                        
                        
                        
                    }else
                    {
                        
                        NSLog(@"failed");
                        [self alertStatus:[returnDictionary objectForKey:@"comment"] :@"ALERT" :0];
                        [_loader stopAnimating];
                        _loader.hidden=YES;
                    }
                }
                else if(![[returnDictionary objectForKey:@"value"] boolValue])
                {
                    [self registerGmail];
                    [_loader stopAnimating];
                    _loader.hidden=YES;
                    
                }else
                {
                    
                    NSLog(@"failed");
                    [self alertStatus:[returnDictionary objectForKey:@"comment"] :@"ALERT" :0];
                    [_loader stopAnimating];
                    _loader.hidden=YES;
                }
            
            
            
        }
        
        else
        {
            NSLog(@"error parsing JSON response: %@", error);
            
            NSString *returnString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            NSLog(@"returnString: %@", returnString);
            [_loader stopAnimating];
            _loader.hidden=YES;
        }
    }
    
    else
        
    {
        NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
        [_loader stopAnimating];
        _loader.hidden=YES;
        
    }
    
    
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
-(void)getProfilePic
{
    
    [[DataManger sharedmanager]parsingImageData:nil];
}
@end
