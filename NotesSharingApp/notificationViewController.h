//
//  notificationViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 21/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationViewController : UIViewController

//nav bar buttons
- (IBAction)sideBar:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sidebar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


//tbl
@property (strong, nonatomic) IBOutlet UITableView *tbl;




@end
