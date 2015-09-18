//
//  OptionsSlidePopUpView.m
//  NotesSharingApp
//
//  Created by Heba khan on 05/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "OptionsSlidePopUpView.h"
#import  "QuartzCore/QuartzCore.h"


@implementation OptionsSlidePopUpViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
        
        [self setUI];
        
    }
    return  self;
}

-(void)setUI{
    
    self.autoresizesSubviews=YES;
    self.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    _lbltitle=[[UILabel alloc]initWithFrame:CGRectMake(0.0,3.0,self.frame.size.width-180,self.frame.size.height)];
    [[self lbltitle] setFont:[UIFont fontWithName:@"System" size:12]];
    
    
    [self addSubview:_lbltitle];
    
    
}

@end




@interface OptionsSlidePopUpView ()

@end



@implementation OptionsSlidePopUpView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
    }
    return self;
    
}
-(void)setupUI
{
    
   
    _arrItems=[[NSArray alloc]initWithObjects:@"Lock",@"Delete",@"Remind",@"Time Bomb",@"Attach", nil];
    
    _tableViewSlide=[[UITableView alloc]initWithFrame:CGRectMake(180.0,self.frame.size.height-255,self.frame.size.width-180, 215)];
    _tableViewSlide.layer.borderWidth = 1.0;
    _tableViewSlide.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_tableViewSlide setBounces:NO];
    _tableViewSlide.scrollEnabled = NO;
    //_tableViewSlide.separatorStyle=UITableViewCellSeparatorStyleNone;
   // _tableViewSlide.backgroundColor=[UIColor lightGrayColor];
    _tableViewSlide.autoresizesSubviews=YES;
    _tableViewSlide.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableViewSlide.delegate=self;
    _tableViewSlide.dataSource=self;
    
    [self addSubview:_tableViewSlide];
    
    [_tableViewSlide reloadData];
    
    
}


-(void)setArrItems:(NSArray *)arrItems{
    
    
    _arrItems=arrItems;
    [_tableViewSlide reloadData];
}

-(void)awakeFromNib{
    
    
    [_tableViewSlide reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrItems.count;
   
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *string=@"Cell";
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:string];
    
    
    CGRect screensize=[[UIScreen mainScreen]bounds];
    
    if (!Cell)
    {
        Cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        
        OptionsSlidePopUpViewCell *Cust=[[OptionsSlidePopUpViewCell alloc]initWithFrame:CGRectMake(0.0,0.0,screensize.size.width,44)];
        Cust.lbltitle.text=[_arrItems objectAtIndex:indexPath.row];//
        Cust.lbltitle.textAlignment=NSTextAlignmentCenter;
        Cust.tag=2000;
        Cust.autoresizesSubviews=YES;
        Cust.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        Cell.contentView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [Cell.contentView addSubview:Cust];
    }
    
    if ([[Cell.contentView viewWithTag:2000]isKindOfClass:[OptionsSlidePopUpViewCell class]])
    {
        
    }
    
    return Cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if ([_delegate respondsToSelector:@selector(didItemClick:)])
    {
        [_delegate didItemClick:OK];
    }
    
}

@end

