//
//  masterCodeViewController.h
//  NoteShare
//
//  Created by Heba khan on 19/09/15.
//  Copyright © 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"



@protocol masterCodeViewControllerDelagte <NSObject>

-(void)didNoteUnlock:(BOOL)isunlock;
-(void)openNote:(BOOL)isunlock;

@end

@interface masterCodeViewController : UIViewController



@property(nonatomic,strong)DBNoteItems *noteItems;
@property(nonatomic,assign)BOOL isCommingFrom;
@property(nonatomic,weak)id<masterCodeViewControllerDelagte> delegate;

@property (strong, nonatomic) IBOutlet UILabel *screen;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *done;

@property (strong, nonatomic) IBOutlet UITextField *txtDigit1;
@property (strong, nonatomic) IBOutlet UITextField *txtDigit2;
@property (strong, nonatomic) IBOutlet UITextField *txtDigit3;
@property (strong, nonatomic) IBOutlet UITextField *txtDigit4;


- (IBAction)btn1:(id)sender;
- (IBAction)btn2:(id)sender;

- (IBAction)btn3:(id)sender;
- (IBAction)btn4:(id)sender;
- (IBAction)btn5:(id)sender;

- (IBAction)btn6:(id)sender;
- (IBAction)btn7:(id)sender;
- (IBAction)btn8:(id)sender;
- (IBAction)btn9:(id)sender;
- (IBAction)btn0:(id)sender;

- (IBAction)clear:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)close:(id)sender;

@end
