//
//  OptionsSlidePopUpView.h
//  NotesSharingApp
//
//  Created by Heba khan on 05/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    OK,
    
} optionsButtonSelect;


@protocol OptionsSlidePopUpViewDelegate <NSObject>

-(void)didItemClick:(optionsButtonSelect)dismiss;

@end


@interface OptionsSlidePopUpViewCell : UIView
@property(nonatomic,strong)IBOutlet UIImageView *imgCellIcon;
@property(nonatomic,strong)IBOutlet UILabel *lbltitle;
@end


@interface OptionsSlidePopUpView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)IBOutlet UITableView *tableViewSlide;
@property(nonatomic,strong) NSArray *arrItems;

@property(nonatomic,weak)id <OptionsSlidePopUpViewDelegate> delegate;

@end
