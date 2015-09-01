//
//  shareOptionPopViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 03/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    OK,
    CANCEL,
    
} selectOption;


@protocol PopUpViewDelegate <NSObject>

-(void)dismissSharePopAlert:(selectOption)selectedOption;


@end

@interface shareOptionPopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tbl;
-(IBAction)btnCancelClick:(id)sender;
-(IBAction)btnOkClick:(id)sender;
@property(nonatomic,strong)NSString *stringAlertTitle;
@property(nonatomic,weak)id <PopUpViewDelegate> delegate;

@end
