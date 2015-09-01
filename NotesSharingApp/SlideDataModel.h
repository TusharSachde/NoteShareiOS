//
//  SlideDataModel.h
//  NotesSharingApp
//
//  Created by Heba khan on 19/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideDataModel : NSObject

@property(nonatomic,strong)NSString *strTitle;
@property(nonatomic,strong)NSString *strIconName;
@property(nonatomic,assign)NSInteger itemId;


@property(nonatomic,strong)NSString *cellName;
@property(nonatomic,strong)NSString *cellDetail;
@property(nonatomic,strong)NSString *cellTime;
@property(nonatomic,assign)NSInteger cellId;
@property(nonatomic,strong)NSString *colours;
@property(nonatomic,strong)NSString *modifiedtime;
@property(nonatomic,strong)NSString *createdtime;
@property(nonatomic,strong)NSString *timebomb;







@end
