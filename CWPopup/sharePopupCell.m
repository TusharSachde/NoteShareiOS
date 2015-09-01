//
//  sharePopupCell.m
//  NotesSharingApp
//
//  Created by Heba khan on 04/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "sharePopupCell.h"

@implementation sharePopupCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUPUI];
    }
    return self;
}

-(void)setUPUI{
    
    _nameLbl=[[UILabel alloc]initWithFrame:CGRectMake(40.0, self.frame.size.height-40.0,self.frame.size.width-20,30)];
    
    
    _nameLbl.backgroundColor=[UIColor clearColor];
    _nameLbl.font=[UIFont systemFontOfSize:13.0 weight:0.1];
    _nameLbl.textColor=[UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1.0];
    
    
    
    _viewSep=[[UIView alloc]initWithFrame:CGRectMake(0.0,self.frame.size.height-0.5,self.frame.size.width,0.5)];
    //_viewSep.backgroundColor=[UIColor grayColor];
    
    
    
    //_imgcatagoryTypeImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f-40.0,80.0,80.0)];
    
    
    _imageIcon=[[UIImageView alloc]initWithFrame:CGRectMake(13.0,10.0,15,15)];
    _imageIcon.backgroundColor=[UIColor clearColor];
    
    
    [self addSubview:_nameLbl];
    [self addSubview:_imageIcon];
    [self addSubview:_viewSep];
    
    
    
}


@end
