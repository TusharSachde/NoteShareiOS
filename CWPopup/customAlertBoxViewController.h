//
//  customAlertBoxViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 21/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    colorBtn,
    selectBrushColor,
    
} OPTIONSELECTED;


@protocol PopUpViewDelegate <NSObject>

//-(void)dismissViewWithTag:(NSInteger)selectedOption;
//-(void)dismissView:(OPTIONSELECTED)selectedOption;
-(void)dismissView:(OPTIONSELECTED)selectedOption   WithTag:(NSInteger)selectedOption;
-(void)dismissColor:(OPTIONSELECTED)selectedOption   WithTag:(NSInteger)selectedOption;
- (void)selectcolor:(id)sender;

@end



@interface customAlertBoxViewController : UIViewController

@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;

-(IBAction)colorBtn:(id)sender;

-(IBAction)selectBrushColor:(id)sender;


@property(nonatomic,strong)NSString *stringAlertTitle;



@property(nonatomic,weak)id <PopUpViewDelegate> delegate;


@end
