//
//  FontPopupViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 07/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "FontPopupViewController.h"
#import "UIViewController+CWPopup.h"
#import "fontLabelCell.h"
#import "fontsSizes.h"

@interface FontPopupViewController ()
@property BOOL toggle;
@end

@implementation FontPopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrFont=[[NSMutableArray alloc]init];
    _arrSize=[[NSMutableArray alloc]init];
    
    
    [self fontarr];
    
    _fontButtonPressed.backgroundColor=[UIColor whiteColor];
    [_fontButtonPressed setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_sizeButtonPressed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sizeButtonPressed.backgroundColor=[UIColor clearColor];
    
    
}


- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)fontTable:(id)sender

{
    
    
    if ([_delegate respondsToSelector:@selector(dismissFontTable:)])
    {
        
    [_delegate dismissFontTable:fontTable];
    }
    
}

-(void)sizeTable:(id)sender{
    
    
    if ([_delegate respondsToSelector:@selector(dismissSizeTable:)])
    {
        
        [_delegate dismissSizeTable:sizeTable];
    }
    
}

#pragma mark-font name detail

-(void)fontarr{

self.toggle=YES;

    
    NSString *strPath=[[NSBundle mainBundle]pathForResource:@"fonts" ofType:@"txt"];
    NSData *data=[NSData dataWithContentsOfFile:strPath];
    
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    NSArray *arr=[response valueForKey:@"fontType"];
    
    for (NSDictionary *dict in arr)
    {
        fontsSizes *model=[[fontsSizes alloc]init];
        model.fontDisplayName=[dict valueForKey:@"displayname"];
        model.fontName=[dict valueForKey:@"fontName"];
       
        
        [_arrFont addObject:model];
    }


}


-(void)sizearr{
    
    self.toggle=NO;
    
    
    NSString *strPath=[[NSBundle mainBundle]pathForResource:@"sizes" ofType:@"txt"];
    NSData *data=[NSData dataWithContentsOfFile:strPath];
    
    
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    NSArray *arr=[response valueForKey:@"sizeType"];
    
    for (NSDictionary *dict in arr)
    {
        fontsSizes *model=[[fontsSizes alloc]init];
        model.sizeDisplayName=[[dict valueForKey:@"sizeDisplay"]integerValue];
        model.sizeName=[dict valueForKey:@"sizeName"];
        
        
        [self.arrSize addObject:model];
    }
    
    
}


//buttons title

- (IBAction)fontButtonPressed:(id)sender {
    
    //self.toggle=YES;
    [self fontarr];
    [_tbl reloadData];
    
    _fontButtonPressed.backgroundColor=[UIColor whiteColor];
    _sizeButtonPressed.backgroundColor=[UIColor clearColor];
    
    [_fontButtonPressed setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_sizeButtonPressed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
}

- (IBAction)sizeButtonPressed:(id)sender {
    
    //self.toggle=NO;
    [self sizearr];
    [_tbl reloadData];
    [_fontButtonPressed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sizeButtonPressed setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _fontButtonPressed.backgroundColor=[UIColor clearColor];
    _sizeButtonPressed.backgroundColor=[UIColor whiteColor];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.toggle==NO) {
        return _arrSize.count;
    }
    else return _arrFont.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    fontLabelCell *cell=(fontLabelCell*)cell1;
    
    if (cell == nil) {
        cell = [[fontLabelCell alloc] init];
    }
    
    if (self.toggle==NO) {
        
        
        fontsSizes *model=[_arrSize objectAtIndex:indexPath.row];
        
         cell.fontLbl.text=[NSString stringWithFormat:@"%@ px",model.sizeName];
       // cell.fontLbl.text=[model.sizeName valueForKey:@"sizeName"];
        
        
    }
    else if (self.toggle == YES)
    {
      
        fontsSizes *model=[_arrFont objectAtIndex:indexPath.row];
        cell.fontLbl.text=model.fontDisplayName;
        //cell.fontLbl.text=[model.fontDisplayName valueForKey:@"displayname"];
        
    
    }
    
    
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (self.toggle==NO) {
        
       
        fontsSizes *model=[_arrSize objectAtIndex:indexPath.row];
        _strSize=model.sizeName;
    
        
       
        
        if ([_delegate respondsToSelector:@selector(didSizeClick:)])
        {
            [_delegate didSizeClick:model];
            
            
        }
        
        [_delegate dismissSizeTable:sizeTable];
        [self.delegate sizes:self];
        
    }
    else if (self.toggle == YES)
    {
        
        
        fontsSizes *model=[_arrFont objectAtIndex:indexPath.row];
        _strFont=model.fontDisplayName;
    
        
        if ([_delegate respondsToSelector:@selector(didFontClick:)])
        {
            [_delegate didFontClick:model];
            
            
        }
        
        [_delegate dismissFontTable:fontTable];
        [self.delegate fonts:self];
        
    }
    
    
}


@end
