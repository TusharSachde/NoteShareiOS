//
//  AddFolderViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 23/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "AddFolderViewController.h"
#import "UIViewController+CWPopup.h"

@interface AddFolderViewController ()

@end

@implementation AddFolderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setStringAlertTitle:(NSString *)stringAlertTitle
{
    
    _stringAlertTitle=stringAlertTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // use toolbar as background because its pretty in iOS7
    // UIToolbar *toolbarBackground = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 44, 200, 106)];
    // [self.view addSubview:toolbarBackground];
    //[self.view sendSubviewToBack:toolbarBackground];
    // set size
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)btnCancelClick:(id)sender
{
    
    if ([_delegate respondsToSelector:@selector(dismissFolderView: WithTag:)])
    {
        [_delegate dismissFolderView:CANCEL];
    }
    
    
}
-(void)btnOkClick:(id)sender
{
    
    if ([_delegate respondsToSelector:@selector(dismissFolderView: WithTag:)])
    {
        [_delegate dismissFolderView:OK];
    }
}


@end
