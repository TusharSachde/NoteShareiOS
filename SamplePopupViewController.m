//
//  SamplePopupViewController.m
//  CWPopupDemo
//
//  Created by Cezary Wojcik on 8/21/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import "SamplePopupViewController.h"
#import "UIViewController+CWPopup.h"

@interface SamplePopupViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *lblAlertTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAlertDetail;

@end

@implementation SamplePopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setStringAlertDetail:(NSString *)stringAlertDetail{
    
    
    _stringAlertDetail=stringAlertDetail;
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
    
    
    
    _lblAlertDetail.text=_stringAlertDetail;
    _lblAlertTitle.title=_stringAlertTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)btnCancelClick:(id)sender
{
    
    if ([_delegate respondsToSelector:@selector(dismissAlert:)])
    {
        [_delegate dismissAlert:CANCEL];
    }
    
    
}
-(void)btnOkClick:(id)sender
{
    
    if ([_delegate respondsToSelector:@selector(dismissAlert:)])
    {
        [_delegate dismissAlert:OK];
    }
}

@end
