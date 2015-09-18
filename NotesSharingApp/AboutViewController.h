//
//  AboutViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 26/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController<UITextFieldDelegate>


//nav bar buttons
- (IBAction)sideBar:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sidebar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@property (strong, nonatomic) IBOutlet UILabel *lbl;
@property (nonatomic, strong) NSString *lblString;



//text view

@property (strong, nonatomic) IBOutlet UITextView *aboutTextView;



@end
