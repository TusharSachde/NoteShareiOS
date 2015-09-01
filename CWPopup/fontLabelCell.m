//
//  fontLabelCell.m
//  NotesSharingApp
//
//  Created by Heba khan on 07/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "fontLabelCell.h"

@implementation fontLabelCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUPUI];
    }
    return self;
}

-(void)setUPUI{
    
    _fontLbl=[[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0,self.frame.size.width-20,30)];
    
    _fontLbl.textAlignment=NSTextAlignmentCenter;
    _fontLbl.backgroundColor=[UIColor clearColor];
    _fontLbl.font=[UIFont systemFontOfSize:15.0 weight:0.1];
    _fontLbl.textColor=[UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1.0];
    
    
    
    _viewSep=[[UIView alloc]initWithFrame:CGRectMake(0.0,self.frame.size.height-0.5,self.frame.size.width,0.5)];
    
    

    [self addSubview:_fontLbl];
    [self addSubview:_viewSep];
    
    
    
}

@end
