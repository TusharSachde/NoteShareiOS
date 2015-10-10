//
//  settingSideBarViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 21/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "settingSideBarViewController.h"
#import "SWRevealViewController.h"
#import "UIViewController+CWPopup.h"

#import "settingPopupScreenViewController.h"
#import "settingPopSizeViewController.h"

@interface settingSideBarViewController ()<PopUpViewDelegate,SWRevealViewControllerDelegate>
{

BOOL checkboxSelected;
}
@end

@implementation settingSideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    checkboxSelected = 0;
    // Do any additional setup after loading the view.
    [self getLeftBtn];
    self.title=@"SETTINGS";
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
  //default
    _defaultScreen.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _defaultScreen.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    
    //color
    _defaultColour.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _defaultColour.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    
    //font size
    
    _defaultFontSize.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _defaultFontSize.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    
    
    //master password
    _masterPassword.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _masterPassword.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    
    
    //individual password
    _individualPassword.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _individualPassword.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    
    
    //backUp
    _backUp.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _backUp.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    
    
    
}

- (IBAction)checkboxButton:(id)sender{
    if (checkboxSelected == 0){
        [_checkboxButton setSelected:YES];
        checkboxSelected = 1;
    } else {
        [_checkboxButton setSelected:NO];
        checkboxSelected = 0;
    }
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
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:viewLeftnavBar];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
}

-(IBAction)sideBarBtn:(id)sender{
    
    [[self revealViewController ]revealToggleAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sideBar:(id)sender{
}

- (IBAction)defaultScreen:(id)sender {
    
    settingPopupScreenViewController *samplePopupViewController = [[settingPopupScreenViewController alloc] initWithNibName:@"settingPopupScreenViewController" bundle:nil];
    
    samplePopupViewController.delegate=self;
    
    [samplePopupViewController setStringAlertTitle:@"Default Screen"];
    
    [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
        NSLog(@"popup view presented");
    }];
    
}


- (IBAction)defaultColour:(id)sender {
}



//font size
- (IBAction)defaultFontSize:(id)sender {
    
    settingPopSizeViewController *samplePopupViewController = [[settingPopSizeViewController alloc] initWithNibName:@"settingPopSizeViewController" bundle:nil];
    
    samplePopupViewController.delegate=self;
    
    [samplePopupViewController setStringAlertTitle:@"Default Font Size"];
    
    [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
        NSLog(@"popup view presented");
    }];
    
}

-(void)sizeOnLabel:(id)sender{

_fontLabel.text=((settingPopSizeViewController*)sender).sizeStr;


}

-(void)dismissSizeTable:(selectSize)selectedOption{  // WithTag:(NSInteger)selectedOption{
    
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
    }];
    
}


-(void)screenOnLabel:(id)sender{
    
    _screenLabel.text=((settingPopupScreenViewController*)sender).screenStr;
    
}

-(void)dismissScreenTable:(selectScreen)selectedOption{
    
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
    }];
    
}



- (IBAction)masterPassword:(id)sender {
}

- (IBAction)individualPassword:(id)sender {
}

- (IBAction)backUp:(id)sender {
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
