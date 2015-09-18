//
//  NoteColorViewController.h
//  NoteShare
//
//  Created by Heba khan on 10/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Notecolor,
    
} selectNoteColor;

@protocol PopUpNoteColorDelegate <NSObject>


-(void)dismissNoteColor:(selectNoteColor)selectedNoteOption   WithTag:(NSInteger)selectedNoteOption;
-(void)backgroundNoteColor:(id)sender;
@end


@interface NoteColorViewController : UIViewController

//strings
@property (nonatomic,strong)NSString *colorString;

//title buttons
@property (strong, nonatomic) IBOutlet UIButton *colorButtonPressed;
- (IBAction)colorButtonPressed:(id)sender;



//connections to page and colors

-(IBAction)colorTable:(id)sender;


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
@property(nonatomic,weak)id <PopUpNoteColorDelegate> delegate;


//views
@property (strong, nonatomic) IBOutlet UIView *colorView;



@end
