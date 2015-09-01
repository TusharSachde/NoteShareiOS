//
//  brushAlertViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 28/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    brushSize,
    eraserSize,
    
} brushSelected;


@protocol PopUpViewDelegate <NSObject>

-(void)dismissBrushView:(brushSelected)selectedOption WithTag:(NSInteger)selectedOption;
-(void)dismissEraserView:(brushSelected)selectedOption WithTag:(NSInteger)selectedOption;
- (void)brushSize:(id)sender;

@end




@interface brushAlertViewController : UIViewController

@property CGFloat brush;

-(IBAction)brushSize:(id)sender;

-(IBAction)eraserSize:(id)sender;

@property(nonatomic,strong)NSString *stringAlertTitle;

@property(nonatomic,weak)id <PopUpViewDelegate> delegate;


@end
