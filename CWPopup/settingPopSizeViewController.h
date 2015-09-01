//
//  settingPopSizeViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 11/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    settingSizeTable,
    done,
    
} selectSize;

@protocol PopUpViewDelegate <NSObject>

-(void)dismissSizeTable:(selectSize)selectedOption;// WithTag:(NSInteger)selectedOption;
-(void)sizeOnLabel:(id)sender;

-(void)didSizeItemClick:(selectSize)data;

@end



@interface settingPopSizeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSString *sizeStr;
//strings
@property (nonatomic,strong)NSArray *arrSize;
@property(nonatomic,strong)NSString *stringAlertTitle;

//table
@property (strong, nonatomic) IBOutlet UITableView *tbl;


//delegate method
@property(nonatomic,weak)id <PopUpViewDelegate> delegate;

@end
