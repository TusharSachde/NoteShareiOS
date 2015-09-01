//
//  settingPopupScreenViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 10/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "settingPopupScreenViewController.h"
#import "UIViewController+CWPopup.h"

@interface settingPopupScreenViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *lblAlertTitle;

@end

@implementation settingPopupScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setStringAlertTitle:(NSString *)stringAlertTitle{
    
    _stringAlertTitle=stringAlertTitle;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _arrScreen=[[NSArray alloc]initWithObjects:@"List",@"Detail",@"Grid",@"Puzzle",nil];
     _lblAlertTitle.title=_stringAlertTitle;
    
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)screenTable:(id)sender{
    
    
    if ([_delegate respondsToSelector:@selector(dismissScreenTable:)])
    {
        
        [_delegate dismissScreenTable:screenTable];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
         return _arrScreen.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    

        
       cell.textLabel.text=[_arrScreen objectAtIndex:indexPath.row];
       cell.textLabel.font=[UIFont systemFontOfSize:15 weight:0];
       cell.textLabel.textColor=[UIColor darkGrayColor];
     
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _screenStr=[_arrScreen objectAtIndex:indexPath.row];
    
    if ([_delegate respondsToSelector:@selector(didScreenItemClick:)])
    {
        [_delegate didScreenItemClick:ok];
        
        
    }
    
    [_delegate dismissScreenTable:screenTable];
    [self.delegate screenOnLabel:self];
}


@end
