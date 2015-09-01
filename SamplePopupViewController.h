//
//  SamplePopupViewController.h
//  CWPopupDemo
//
//  Created by Cezary Wojcik on 8/21/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    OK,
    CANCEL,
    
} selectOption;


@protocol PopUpViewDelegate <NSObject>

-(void)dismissAlert:(selectOption)selectedOption;

@end


@interface SamplePopupViewController : UIViewController

-(IBAction)btnCancelClick:(id)sender;
-(IBAction)btnOkClick:(id)sender;
@property(nonatomic,strong)NSString *stringAlertTitle;
@property(nonatomic,strong)NSString *stringAlertDetail;


@property(nonatomic,weak)id <PopUpViewDelegate> delegate;
@end
