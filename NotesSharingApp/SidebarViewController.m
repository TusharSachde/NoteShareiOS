//
//  SidebarViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 23/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "AboutViewController.h"
#import "rateUsViewController.h"
#import "inviteFriendsViewController.h"
#import "DataManger.h"
#import "ViewController.h"
#import "titleCell.h"
#import "UIImageView+WebCache.h"
#import "ChangeProfileViewController.h"

@interface SidebarViewController ()<DataManageDelegate>

@property(nonatomic,strong)titleCell *customCell;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIImageView *bgimg;
@property(nonatomic,strong)UILabel *lblusename;
@property(nonatomic,strong)UIView *viewUserProfile;
@property(nonatomic,strong)NSData *imagedata;
@end

@implementation SidebarViewController {
    NSArray *menuItems;
    NSInteger selected;
}

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    //hide table lines
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    [[DataManger sharedmanager]setDatamanagerdelegate:self];
    
    menuItems = @[@"title", @"Notes", @"Folder",@"line", @"About NoteShare", @"Terms And Conditions", @"Notification Center", @"Rate Us", @"Like Us On Facebook",@"Send Feedback",@"Invite Friends",@"Settings",@"Logout"];
    

    //Get profile pic of user
    [self addUi];
    
}
-(void)addUi
{
    _viewUserProfile=[[UIView alloc]initWithFrame:CGRectMake(-22, -22,self.view.frame.size.width, 112)];
    
    if (_imagedata==nil) {
        _viewUserProfile .backgroundColor=[UIColor colorWithRed:(246.0/255) green:(65.0/255) blue:(79.0/255) alpha:(1.0)];
    }
    else
    {
        _viewUserProfile .backgroundColor=[UIColor clearColor];
        
    }
    
    
    
    _imageView=[[UIImageView  alloc]initWithFrame:CGRectMake(30, 30,70, 70)];
    _imageView.backgroundColor=[UIColor clearColor];
    _imageView.layer.cornerRadius=35.0f;
    _imageView.layer.borderWidth=2.0f;
    _imageView.layer.borderColor=[UIColor whiteColor].CGColor;
    _imageView.clipsToBounds=YES;
    
    
    UIButton *imgBtn=[[UIButton  alloc]initWithFrame:CGRectMake(30, 30,70, 70)];
    [imgBtn addTarget:self action:@selector(imageBtn:) forControlEvents:UIControlEventTouchUpInside];
    imgBtn.backgroundColor=[UIColor clearColor];
    imgBtn.layer.cornerRadius=35.0f;
    imgBtn.layer.borderWidth=2.0f;
    imgBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    imgBtn.clipsToBounds=YES;
    
    _lblusename=[[UILabel alloc]initWithFrame:CGRectMake(112,30,self.view.frame.size.width-112,70)];
    
    
    _lblusename.textColor=[UIColor whiteColor];
    [_viewUserProfile addSubview:_bgimg];
    [_viewUserProfile addSubview:_lblusename];
    [_viewUserProfile addSubview:imgBtn];
    [_viewUserProfile addSubview:_imageView];
    
    if ([[DataManger sharedmanager] getProfileImageStatus])
    {
      [_imageView setImage:[UIImage imageWithData:[[DataManger sharedmanager] getProfileImage]]];
    }
    else{
        [_imageView setImage:[UIImage imageNamed:@"userdefault_bg.png"]];
    }
    
    UserDetail *detail=[[DataManger sharedmanager]getLoogedInUserdetail];
    NSLog(@"%@",detail.userName);
    
    _lblusename.text=[NSString stringWithFormat:@"%@",detail.userName];
    
    [self.view addSubview:_viewUserProfile];
    
}

-(IBAction)imageBtn:(id)sender{


    ChangeProfileViewController *vc=[[ChangeProfileViewController alloc]initWithNibName:@"ChangeProfileViewController" bundle:nil];
    
    [self presentViewController:vc animated:YES completion:nil];

}

//

- (void)viewWillAppear:(BOOL)animated{
   
    //Get profile pic of user
    [self addUi];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
    alertView.tag = tag;
    [alertView show];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    
    
    selected=indexPath.row;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
     cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = myBackView;
    

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90;
    }
    
    else if (indexPath.row == 3)
    {
        return 2;
    }
    
    else {
        return 40;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==12) {
        
        [self alertStatus:@"Are you sure you want to logout?" :@"LOGOUT" :0];
    }
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    switch (buttonIndex)
    {
        case 0:
        {
            NSLog(@"0");//yes
            
            [[DataManger sharedmanager]logoutUser];
            
            
            NSString * storyboardName = @"Main";
            NSString * viewControllerID = @"signIn";
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            ViewController * controller = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
            [self presentViewController:controller animated:YES completion:nil];
            
        }
            break;
        case 1:
        {
            NSLog(@"1");//no
        }
            break;
            
        default:
            break;
    }
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender{
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] && [segue.identifier isEqualToString:@"notes"])
    {

        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
        };
        
    }
    
    else if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] && [segue.identifier isEqualToString:@"about"])
    {
    
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            AboutViewController *AboutVC = segue.destinationViewController;
            
            AboutVC.lblString=@"About";
            AboutVC.aboutTextView.hidden=NO;
        };
        
        
    }
    
    else if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] && [segue.identifier isEqualToString:@"terms"])
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            AboutViewController *AboutVC = segue.destinationViewController;
            
            AboutVC.lblString=@"Terms and Conditions";
            AboutVC.aboutTextView.hidden=YES;
            
        };
        
        
    }
    
    else if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] && [segue.identifier isEqualToString:@"notification"])
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
        };
        
        
    }
    
    else if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] && [segue.identifier isEqualToString:@"rate"])
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            
            
        };
        
        
    }
    
    else if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] && [segue.identifier isEqualToString:@"like"])
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            
        };
        
        
    }
    
    else if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] && [segue.identifier isEqualToString:@"send"])
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            
        };
        
        
    }
    
    else if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] && [segue.identifier isEqualToString:@"invite"])
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            
        };
        
        
    }
    
    else if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] && [segue.identifier isEqualToString:@"setting"])
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            
        };
        
        
    }
    
    else if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] && [segue.identifier isEqualToString:@"Folder"])
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            
        };
        
        
    }
    
   
}


-(void)updateProfilePic
{
    
    if ([[DataManger sharedmanager] getProfileImageStatus])
    {
        [_imageView setImage:[UIImage imageWithData:[[DataManger sharedmanager] getProfileImage]]];
    }
    else{
        [_imageView setImage:[UIImage imageNamed:@"userdefault_bg.png"]];
    }
    
    
    
}




@end
