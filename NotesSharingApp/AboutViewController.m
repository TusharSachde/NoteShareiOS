//
//  AboutViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 26/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"

@interface AboutViewController ()<SWRevealViewControllerDelegate>

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//textview noneditable
    
    _aboutTextView.editable = NO;
    
    [_lbl setLineBreakMode:NSLineBreakByWordWrapping];
    [_lbl setTextColor:[UIColor redColor]];
    [_lbl setBackgroundColor:[UIColor clearColor]];
    _lbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    _lbl.text=_lblString;
    
    [self getLeftBtn];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

-(void)getLeftBtn{
    
    UIView *viewLeftnavBar=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0,40.0, 40)];
    viewLeftnavBar.backgroundColor=[UIColor clearColor];
    
    UIButton *Btn=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 5.0, 30, 30)];
    
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


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sideBar:(id)sender{

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
