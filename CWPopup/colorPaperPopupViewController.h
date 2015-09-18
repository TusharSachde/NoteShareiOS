//
//  colorPaperPopupViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 03/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    colorTable,
    pageTable,
    
} selectColorPaper;

@protocol PopUpViewDelegate <NSObject>


-(void)dismissColorTable:(selectColorPaper)selectedOption   WithTag:(NSInteger)selectedOption;
-(void)dismissPageTable:(selectColorPaper)selectedOption   WithTag:(NSInteger)selectedOption;
-(void)backgroundColor:(id)sender;
-(void)backgroundPage:(id)sender;
@end


@interface colorPaperPopupViewController : UIViewController



//strings
@property (nonatomic,strong)NSString *pageString;
@property (nonatomic,strong)NSString *colorString;

//title buttons
@property (strong, nonatomic) IBOutlet UIButton *colorButtonPressed;
- (IBAction)colorButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *papersButtonPressed;
- (IBAction)papersButtonPressed:(id)sender;



//connections to page and colors

-(IBAction)colorTable:(id)sender;
-(IBAction)pageTable:(id)sender;

//page button border
@property(nonatomic,strong)IBOutlet UIButton *paper1;
@property(nonatomic,strong)IBOutlet UIButton *paper2;
@property(nonatomic,strong)IBOutlet UIButton *paper3;
@property(nonatomic,strong)IBOutlet UIButton *paper4;
@property(nonatomic,strong)IBOutlet UIButton *paper5;
@property(nonatomic,strong)IBOutlet UIButton *paper6;
@property(nonatomic,strong)IBOutlet UIButton *paper7;

//color button border
@property(nonatomic,strong)IBOutlet UIButton *color1;
@property(nonatomic,strong)IBOutlet UIButton *color2;
@property(nonatomic,strong)IBOutlet UIButton *color3;
@property(nonatomic,strong)IBOutlet UIButton *color4;
@property(nonatomic,strong)IBOutlet UIButton *color5;
@property(nonatomic,strong)IBOutlet UIButton *color6;
@property(nonatomic,strong)IBOutlet UIButton *color7;
@property(nonatomic,strong)IBOutlet UIButton *color8;
@property(nonatomic,strong)IBOutlet UIButton *color9;
@property(nonatomic,strong)IBOutlet UIButton *color10;




//delegate method
@property(nonatomic,weak)id <PopUpViewDelegate> delegate;


//views
@property (strong, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) IBOutlet UIView *paperView;


@end
