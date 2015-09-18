//
//  notificationViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 21/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "notificationViewController.h"
#import "SWRevealViewController.h"
#import "NotifyCell.h"
#import "NSArray+SIAdditions.h"

@interface notificationViewController ()

@property(nonatomic,strong)NSArray *notifyArr;
@property(nonatomic,strong)NSArray *timeArr;

@end

@implementation notificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timeArr=[[NSArray alloc]initWithObjects:@"Wed 21/2/2015",@"Fri 6/3/2015",@"19/6/2015",nil];
    _notifyArr=[[NSArray alloc]initWithObjects:@"New brushes added",@"New textures added",@"New colours added", nil];
    // Do any additional setup after loading the view.
    [self getLeftBtn];
    self.title=@"NOTIFICATIONS";
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _notifyArr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NotifyCell *cell=(NotifyCell*)cell1;
    
    
    
    if (cell == nil) {
        cell = [[NotifyCell alloc] init];
    }
    
    
    cell.notifyLbl.text=[_notifyArr si_objectOrNilAtIndex:indexPath.row];
    cell.timeLbl.text=[_timeArr si_objectOrNilAtIndex:indexPath.row];

    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 80;
}



@end
