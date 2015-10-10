//
//  SlidePopUpView.m
//  NotesSharingApp
//
//  Created by Heba khan on 19/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "SlidePopUpView.h"
#import "SlideDataModel.h"
#import  "QuartzCore/QuartzCore.h"


@implementation SlidePopUpViewCell

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
    
    
    _imgCellIcon=[[UIImageView alloc]initWithFrame:CGRectMake(20.0,15.0,20,20)];
    _lbltitle=[[UILabel alloc]initWithFrame:CGRectMake(67,3.0,self.frame.size.width,self.frame.size.height)];
    [[self lbltitle] setFont:[UIFont fontWithName:@"System" size:12]];
    [_imgCellIcon setContentMode:UIViewContentModeScaleAspectFit];
   
    
    
    [self addSubview:_imgCellIcon];
    [self addSubview:_lbltitle];
    
    
}

@end


@implementation SlidePopUpView

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
    
    _tableViewSlide=[[UITableView alloc]initWithFrame:CGRectMake(20.0, 0.0,self.frame.size.width-40.0,300)];
    _tableViewSlide.layer.borderWidth = 1.0;
    _tableViewSlide.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_tableViewSlide setBounces:NO];
    _tableViewSlide.scrollEnabled = NO;
    _tableViewSlide.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableViewSlide.autoresizesSubviews=YES;
    _tableViewSlide.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableViewSlide.delegate=self;
    _tableViewSlide.dataSource=self;
    
    [self addSubview:_tableViewSlide];
    
    [_tableViewSlide reloadData];
    
    
}

-(void)setHeaderdetail:(SlideDataModel *)headerdetail{
    
    _headerdetail=headerdetail;
    
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *viewHeader=[[UIImageView alloc]initWithFrame:CGRectMake(0.0,0.0,self.frame.size.width,44)];
    
    UIView *viewContainer=[[UIView alloc]initWithFrame:CGRectMake(0.0,0.0,150,44)];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(24.0,10.0, 25, 25)];
    
//    UIButton *slideBtn=[[UIButton alloc]initWithFrame:CGRectMake(184.0,10.0, 25, 25)];
//    [slideBtn setTitle:@"OK" forState:UIControlStateNormal];
//    [slideBtn addTarget:self action:@selector(slideBtn:) forControlEvents:UIControlEventTouchUpInside];
  //  [viewContainer addSubview:slideBtn];
    
    
  
    [viewContainer addSubview:imageView];
    
    
    UILabel *lblHeadrTitle=[[UILabel alloc]initWithFrame:CGRectMake(58.0,12.0, viewContainer.frame.size.width, 20.0)];
    
    [viewContainer addSubview:lblHeadrTitle];
    lblHeadrTitle.textColor=[UIColor whiteColor];
    lblHeadrTitle.text=_headerdetail.strTitle;
    
    //lblHeadrTitle.textAlignment=NSTextAlignmentCenter;
    [imageView setImage:[UIImage imageNamed:_headerdetail.strIconName]];
    
    imageView .contentMode=UIViewContentModeScaleAspectFit;
    
    
    viewContainer.center=CGPointMake(viewHeader.frame.size.width/2.0-18.0, viewHeader.frame.size.height/2.0);
    
    //viewContainer.backgroundColor=[UIColor blackColor];
    
    
    [viewHeader addSubview:viewContainer];
    
    viewHeader.backgroundColor=[UIColor redColor];
    
    return viewHeader;
}

-(IBAction)slideBtn:(id)sender{
    NSLog(@"button clicked");

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
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
        
        SlidePopUpViewCell *Cust=[[SlidePopUpViewCell alloc]initWithFrame:CGRectMake(0.0,0.0,screensize.size.width,44)];
        Cust.tag=2000;
        Cust.autoresizesSubviews=YES;
        Cust.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        Cell.contentView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [Cell.contentView addSubview:Cust];
    }
    
    if ([[Cell.contentView viewWithTag:2000]isKindOfClass:[SlidePopUpViewCell class]])
    {
        SlidePopUpViewCell *Cust=(SlidePopUpViewCell*)[Cell.contentView viewWithTag:2000];
        SlideDataModel *model = [_arrItems objectAtIndex:indexPath.row];
        
        Cust.lbltitle.text=model.strTitle;
        [Cust.imgCellIcon setImage:[UIImage imageNamed:model.strIconName]];
        
    }
    
    return Cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SlideDataModel *model = [_arrItems objectAtIndex:indexPath.row];
    if ([_delegate respondsToSelector:@selector(didItemClick:)])
    {
        [_delegate didItemClick:model];
    }
}

@end
