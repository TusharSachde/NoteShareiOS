//
//  SlidePopUpView.h
//  NotesSharingApp
//
//  Created by Heba khan on 19/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlideDataModel;


@protocol SlidePopUpViewDelegate <NSObject>

-(void)didItemClick:(SlideDataModel*)dataModel;

@end


@interface SlidePopUpViewCell : UIView
@property(nonatomic,strong)IBOutlet UIImageView *imgCellIcon;
@property(nonatomic,strong)IBOutlet UILabel *lbltitle;
@end



@interface SlidePopUpView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)IBOutlet UITableView *tableViewSlide;
@property(nonatomic,strong) NSArray *arrItems;
@property(nonatomic,strong) SlideDataModel *headerdetail;

@property(nonatomic,weak)id <SlidePopUpViewDelegate> delegate;
@end


