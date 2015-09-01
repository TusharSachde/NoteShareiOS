//
//  settingPopupScreenViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 10/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    screenTable,
    ok,
    
} selectScreen;

@protocol PopUpViewDelegate <NSObject>


-(void)dismissScreenTable:(selectScreen)selectedOption;// WithTag:(NSInteger)selectedOption;
-(void)screenOnLabel:(id)sender;
-(void)didScreenItemClick:(selectScreen)data;

@end


@interface settingPopupScreenViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


//strings
@property(nonatomic,strong)NSString *screenStr;
@property (nonatomic,strong)NSArray *arrScreen;
@property(nonatomic,strong)NSString *stringAlertTitle;

//table
@property (strong, nonatomic) IBOutlet UITableView *tbl;


//delegate method
@property(nonatomic,weak)id <PopUpViewDelegate> delegate;


@end
