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

@interface SidebarViewController ()
//@property(nonatomic) BOOL clearsSelectionOnViewWillAppear __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_2);
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
    
    menuItems = @[@"title", @"Notes", @"Folder",@"line", @"About NoteShare", @"Terms And Conditions", @"Notification Center", @"Rate Us", @"Like Us On Facebook",@"Send Feedback",@"Invite Friends",@"Settings",@"Logout"];
    
    
    /*
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    if (indexPath) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    */
    
}

- (void)viewWillAppear:(BOOL)animated{
   
  // [ self setClearsSelectionOnViewWillAppear:NO ];
    
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

    //change bg color of selected cell
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
   // myBackView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(119/255.0) blue:(121/255.0) alpha:1];
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


@end
