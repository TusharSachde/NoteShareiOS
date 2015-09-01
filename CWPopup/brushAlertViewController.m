//
//  brushAlertViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 28/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "brushAlertViewController.h"
#import "UIViewController+CWPopup.h"

@interface brushAlertViewController ()

@end

@implementation brushAlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setStringAlertTitle:(NSString *)stringAlertTitle
{
    
    _stringAlertTitle=stringAlertTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // use toolbar as background because its pretty in iOS7
    // UIToolbar *toolbarBackground = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 44, 200, 106)];
    // [self.view addSubview:toolbarBackground];
    //[self.view sendSubviewToBack:toolbarBackground];
    // set size
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)brushSize:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    
    if ([_delegate respondsToSelector:@selector(dismissBrushView: WithTag:)])
    {
        switch(btn.tag)
        {
            case 0:
                
                _brush=1.0;
                
                break;
            case 1:
                
                _brush=2.0;
                
                break;
            case 2:
                
                _brush=3.0;
                
                break;
            case 3:
                
                _brush=4.0;
                
                break;
            case 4:
                
                _brush=5.0;
                
                break;
            case 5:
                
                _brush=6.0;
                
                break;
            case 6:
                
                _brush=7.0;
                
                break;
            case 7:
                
                _brush=8.0;
                
                break;
            case 8:
                
                _brush=9.0;
                
                break;
            case 9:
                
                _brush=10.0;
                
                break;
            case 10:
                
                _brush=11.0;
                
                break;
            case 11:
                
                _brush=12.0;
                
                break;
            case 12:
                
                _brush=13.0;
                
                break;
            case 13:
                
                _brush=14.0;
                
                break;
            case 14:
                
                _brush=15.0;
                
                break;
        }
        
        [self.delegate brushSize:self];
         [_delegate dismissBrushView:brushSize WithTag:btn.tag];
    }
}

-(void)eraserSize:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    
    
    
    if ([_delegate respondsToSelector:@selector(dismissEraserView: WithTag:)])
    {
        
        switch(btn.tag)
        {
            case 0:
                
                _brush=1.0;
                
                break;
            case 1:
                
                _brush=2.0;
                
                break;
            case 2:
                
                _brush=3.0;
                
                break;
            case 3:
                
                _brush=4.0;
                
                break;
            case 4:
                
                _brush=5.0;
                
                break;
            case 5:
                
                _brush=6.0;
                
                break;
            case 6:
                
                _brush=7.0;
                
                break;
            case 7:
                
                _brush=8.0;
                
                break;
            case 8:
                
                _brush=9.0;
                
                break;
            case 9:
                
                _brush=10.0;
                
                break;
            case 10:
                
                _brush=11.0;
                
                break;
            case 11:
                
                _brush=12.0;
                
                break;
            case 12:
                
                _brush=13.0;
                
                break;
            case 13:
                
                _brush=14.0;
                
                break;
            case 14:
                
                _brush=15.0;
                
                break;
                
        }
        
        [self.delegate brushSize:self];
        
        [_delegate dismissEraserView:eraserSize WithTag:btn.tag];
    }
}


@end
