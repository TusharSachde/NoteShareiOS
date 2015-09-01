//
//  FontPopupViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 07/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    sizeTable,
    fontTable,
    ok,
    
} selectFontSize;

@protocol PopUpViewDelegate <NSObject>


-(void)dismissFontTable:(selectFontSize)selectedOption;
-(void)fonts:(id)sender;
-(void)didFontClick:(id)data;

-(void)dismissSizeTable:(selectFontSize)selectedOption;
-(void)sizes:(id)sender;
-(void)didSizeClick:(id)data;

@end



@interface FontPopupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//arrays
@property (nonatomic,strong)NSMutableArray *arrFont;
@property (nonatomic,strong)NSMutableArray *arrSize;
//strings
@property (nonatomic,strong)NSString *strFont;
@property (nonatomic,strong)NSString *strSize;


//title buttons
@property (strong, nonatomic) IBOutlet UIButton *fontButtonPressed;
- (IBAction)fontButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sizeButtonPressed;
- (IBAction)sizeButtonPressed:(id)sender;


//tbl view outlet
@property (strong, nonatomic) IBOutlet UITableView *tbl;


//delegate method
@property(nonatomic,weak)id <PopUpViewDelegate> delegate;


@end
