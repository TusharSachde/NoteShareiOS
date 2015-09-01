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

@interface shareOptionPopViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *lblAlertTitle;
@property(nonatomic,strong)NSArray *arrShare;
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
    _arrShare=[[NSArray alloc]initWithObjects:@"NoteShare",@"Whatsapp",@"Email",@"SMS",@"Facebook Messanger", nil];
    
    _arrShareIcon=[[NSArray alloc]initWithObjects:@"notes2NotesIcon.png",@"socialwhatsapp.png",@"emailNotesShareIcon.png",@"speechBubbleIcon.png",@"socialFB.png", nil];
    
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
        [_delegate dismissSharePopAlert:CANCEL];
    }
    
    
}
-(void)btnOkClick:(id)sender
{
    
    if ([_delegate respondsToSelector:@selector(dismissSharePopAlert:)])
    {
        [_delegate dismissSharePopAlert:OK];
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
    

     cell.nameLbl.text = [_arrShare objectAtIndex:indexPath.row];
   
     cell.imageIcon.image=[UIImage imageNamed:[_arrShareIcon objectAtIndex:indexPath.row]];
    
    
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


@end
