//
//  inviteFriendsViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 28/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "inviteFriendsViewController.h"
#import "SWRevealViewController.h"
#import "PopUpViewController.h"



@interface inviteFriendsViewController ()<SWRevealViewControllerDelegate>

@end

@implementation inviteFriendsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getLeftBtn];
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getLeftBtn{
    
    UIView *viewLeftnavBar=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0,40.0, 40)];
    viewLeftnavBar.backgroundColor=[UIColor clearColor];
    
    UIButton *Btn=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 5.0, 30, 30)];
    // Btn.backgroundColor = [UIColor yellowColor];
    
    Btn.imageView.image=[UIImage imageNamed:@"sidebarIcon40x40.png"];
    
    [Btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"sidebarIcon40x40.png"]]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(sideBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:Btn];
    
    UIImageView *Btn2=[[UIImageView alloc]initWithFrame:CGRectMake(40.0, 10.0, 90, 20)];
    [Btn2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"noteshareNavBarTitle2.png"]]];
    [viewLeftnavBar addSubview:Btn2];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:viewLeftnavBar];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
}

-(IBAction)sideBarBtn:(id)sender{
    
    [[self revealViewController ]revealToggleAnimated:YES];
    
}



- (IBAction)sideBar:(id)sender{
}

- (IBAction)email:(id)sender {
    
    //email subject
    NSString * subject = @"send mail test";
    //email body
    NSString * body = @"Want to share a note?Please join us.";
    //recipient(s)
    NSArray * recipients = [NSArray arrayWithObjects:@"TypeEmailId.com", nil];
    
    //create the MFMailComposeViewController
    MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
    composer.mailComposeDelegate = self;
    [composer setSubject:subject];
    [composer setMessageBody:body isHTML:NO];
    //[composer setMessageBody:body isHTML:YES]; //if you want to send an HTML message
    [composer setToRecipients:recipients];
    
    //get the filepath from resources
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    
    //read the file using NSData
    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    // Set the MIME type
    /*you can use :
     - @"application/msword" for MS Word
     - @"application/vnd.ms-powerpoint" for PowerPoint
     - @"text/html" for HTML file
     - @"application/pdf" for PDF document
     - @"image/jpeg" for JPEG/JPG images
     */
    NSString *mimeType = @"image/png";
    
    //add attachement
    [composer addAttachmentData:fileData mimeType:mimeType fileName:filePath];
    
    //present it on the screen
    [self presentViewController:composer animated:YES completion:NULL];
}

- (IBAction)sms:(id)sender {
    [self sendSMS:@"Hi, Try cekret..new app for personalized chatting,save and secure!!!!" recipientList:[[NSArray alloc]initWithContentsOfFile:@"Click to select number"]];
    
    
}


- (IBAction)whatsapp:(id)sender {
    
    NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://send?text=Test%20message%20whatsapp!"];
    
    if ([[UIApplication sharedApplication] canOpenURL:whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support Whatsapp!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
    }
}


- (IBAction)fbMessanger:(id)sender {
    
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://www.mydomain.com/myapplink"];
    [FBSDKAppInviteDialog showWithContent:content delegate:self];
    
    
}

- (void) appInviteDialog: (FBSDKAppInviteDialog *)appInviteDialoge didFailWithError:(NSError *)error
{
    
    NSLog(@"Session connection failed with error %@",[error self]);
}

-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
    
      NSLog(@"Session connection failed with error %@",[results self]);

}

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled"); break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved"); break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent"); break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]); break;
        default:
            break;
    }
    
    // close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - SMS delegates

 - (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients{
 MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
 if([MFMessageComposeViewController canSendText])
 {
 controller.body = bodyOfMessage;
 controller.recipients = recipients;
 controller.messageComposeDelegate = self;
 [self presentViewController:controller animated:YES completion:nil];
 }
 }
 
 - (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
 [[controller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
 
 if (result == MessageComposeResultCancelled)
 NSLog(@"Message cancelled");
 else if (result == MessageComposeResultSent)
 NSLog(@"Message sent");
 else
 NSLog(@"Message failed");
 }

#pragma mark-DrawerDelegate
-(void)revealController:(SWRevealViewController *)revealController drawerStatus:(DRAWERSTATUS)status
{
    
    switch (status) {
        case OPEN:
            
        {
            self.view.userInteractionEnabled = NO;
            
        }
            break;
        case CLOSE:
            
        {
            self.view.userInteractionEnabled = YES;
            
        }
            break;
            
        default:
            break;
    }
}

@end
