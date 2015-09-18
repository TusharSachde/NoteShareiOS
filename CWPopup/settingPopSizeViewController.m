//
//  settingPopSizeViewController.m
//  NotesSharingApp
//  Created by Heba khan on 11/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.


#import "settingPopSizeViewController.h"
#import "UIViewController+CWPopup.h"

@interface settingPopSizeViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *lblAlertTitle;
@end

@implementation settingPopSizeViewController

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
    
    
    _arrSize=[[NSArray alloc]initWithObjects:@"6 px",@"7 px",@"8 px",@"9 px",@"10 px",@"11px",@"12px",@"13px",@"14px",@"15px",@"16px",@"17px",@"18px",@"19px",@"20px",@"21px",@"22px",@"23px",@"24px",@"25px", nil];
    _lblAlertTitle.title=_stringAlertTitle;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)settingSizeTable:(id)sender{
    
   // UIButton * PressedButton = (UIButton*)sender;
    
    if ([_delegate respondsToSelector:@selector(dismissSizeTable:)])
    {
        
        [_delegate dismissSizeTable:settingSizeTable]; //WithTag:PressedButton.tag];
    }
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrSize.count;
    
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text=[_arrSize objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:15 weight:0];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    _sizeStr=[_arrSize objectAtIndex:indexPath.row];
    
    if ([_delegate respondsToSelector:@selector(didSizeItemClick:)])
    {
        [_delegate didSizeItemClick:done];
        
    }
    
 [_delegate dismissSizeTable:settingSizeTable];   
[self.delegate sizeOnLabel:self];

}



@end
