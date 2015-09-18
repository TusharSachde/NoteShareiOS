//
//  rateUsViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 28/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rateUsViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

//nav bar buttons
- (IBAction)sideBar:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sidebar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;



@end
