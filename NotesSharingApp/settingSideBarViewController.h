//
//  settingSideBarViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 21/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingSideBarViewController : UIViewController

//nav bar buttons
- (IBAction)sideBar:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sidebar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;



//buttons
@property (strong, nonatomic) IBOutlet UIButton *defaultScreen;
- (IBAction)defaultScreen:(id)sender;




@property (strong, nonatomic) IBOutlet UIButton *defaultColour;
- (IBAction)defaultColour:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *defaultFontSize;
- (IBAction)defaultFontSize:(id)sender;



@property (strong, nonatomic) IBOutlet UIButton *masterPassword;
- (IBAction)masterPassword:(id)sender;




@property (strong, nonatomic) IBOutlet UIButton *individualPassword;

- (IBAction)individualPassword:(id)sender;




@property (strong, nonatomic) IBOutlet UIButton *backUp;

- (IBAction)backUp:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *checkboxButton;

- (IBAction)checkboxButton:(id)sender;



//Labels
@property (strong, nonatomic) IBOutlet UILabel *fontLabel;
@property (strong, nonatomic) IBOutlet UILabel *screenLabel;








@end
