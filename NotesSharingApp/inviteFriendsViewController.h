//
//  inviteFriendsViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 28/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


@protocol FBSDKAppInviteDialogDelegate;

@interface inviteFriendsViewController : UIViewController<UITextFieldDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,FBSDKAppInviteDialogDelegate>


//nav bar buttons
- (IBAction)sideBar:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sidebar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


//buttons
- (IBAction)email:(id)sender;
- (IBAction)sms:(id)sender;
- (IBAction)whatsapp:(id)sender;
- (IBAction)fbMessanger:(id)sender;

@end
