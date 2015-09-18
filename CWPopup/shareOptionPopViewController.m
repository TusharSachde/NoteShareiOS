//
//  shareOptionPopViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 03/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "shareOptionPopViewController.h"
#import "UIViewController+CWPopup.h"
#import "sharePopupCell.h"


@interface SharingOptions ()

@end
@implementation SharingOptions



@end


@interface shareOptionPopViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *lblAlertTitle;
@property(nonatomic,strong)NSMutableArray  *arrShare;
@property(nonatomic,strong)NSArray *arrShareIcon;
@end

@implementation shareOptionPopViewController

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
    
    NSString *strPath=[[NSBundle mainBundle] pathForResource:@"sharingOptions" ofType:@"txt"];
    
    NSData *dateJson=[NSData dataWithContentsOfFile:strPath];
    
    _arrShare =[[NSMutableArray alloc]init];
    
    if (dateJson)
    {
        id response=[NSJSONSerialization JSONObjectWithData:dateJson options:NSJSONReadingMutableContainers error:nil];
        NSArray *arrData=[response valueForKey:@"sharingList"];
        
        for (NSDictionary *dict in arrData)
        {
            SharingOptions *options=[[SharingOptions alloc]init];
            options.strId=[dict valueForKey:@"Id"];
            options.strName=[dict valueForKey:@"name"];
            options.strImageName=[dict valueForKey:@"imageName"];
            
            [_arrShare addObject:options];
            
        }
        
        
    }

    

    
    
    
    _lblAlertTitle.title=_stringAlertTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)btnCancelClick:(id)sender
{
    
    if ([_delegate respondsToSelector:@selector(dismissSharePopAlert:)])
    {
        [_delegate dismissSharePopAlert:cancel];
    }
    
    
}
-(void)btnOkClick:(id)sender
{
    
    if ([_delegate respondsToSelector:@selector(dismissSharePopAlert:)])
    {
        [_delegate dismissSharePopAlert:done];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _arrShare.count;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    sharePopupCell *cell=(sharePopupCell*)cell1;
    
    if (cell == nil) {
        cell = [[sharePopupCell alloc] init];
    }
    
    SharingOptions *options= [_arrShare objectAtIndex:indexPath.row];
     cell.nameLbl.text =options.strName ;
   
     cell.imageIcon.image=[UIImage imageNamed:options.strImageName];
    
    
    /*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text = [_arrShare objectAtIndex:indexPath.row];
    
    return cell;
    */
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharingOptions *options= [_arrShare objectAtIndex:indexPath.row];
    if ([_delegate respondsToSelector:@selector(dismissSharePopAlert:withSharingOption:)])
    {
        [_delegate dismissSharePopAlert:done withSharingOption:options];
    }
}


@end
