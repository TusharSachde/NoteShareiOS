//
//  NoteColorViewController.m
//  NoteShare
//
//  Created by Heba khan on 10/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "NoteColorViewController.h"
#import "UIViewController+CWPopup.h"

@interface NoteColorViewController ()

@end

@implementation NoteColorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _colorButtonPressed.backgroundColor=[UIColor whiteColor];
    [_colorButtonPressed setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
    _colorView.hidden=NO;
    
    
    
    //border to color buttons
    [[_color1 layer] setBorderWidth:1.0f];
    [[_color1 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_color2 layer] setBorderWidth:1.0f];
    [[_color2 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_color3 layer] setBorderWidth:1.0f];
    [[_color3 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_color4 layer] setBorderWidth:1.0f];
    [[_color4 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_color5 layer] setBorderWidth:1.0f];
    [[_color5 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_color6 layer] setBorderWidth:1.0f];
    [[_color6 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_color7 layer] setBorderWidth:1.0f];
    [[_color7 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    
    [[_color8 layer] setBorderWidth:1.0f];
    [[_color8 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_color9 layer] setBorderWidth:1.0f];
    [[_color9 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_color10 layer] setBorderWidth:1.0f];
    [[_color10 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)colorTable:(id)sender
{
    
    
    
    UIButton *btn=(UIButton*)sender;
    
    if ([_delegate respondsToSelector:@selector(dismissNoteColor: WithTag:)])
        
        
        switch(btn.tag)
    {
        case 0:
            
            
            _colorString=[NSString stringWithFormat:@"#ffffff"];
            
            
            break;
        case 1:
            
            _colorString=[NSString stringWithFormat:@"#fae9cf"];
            
            break;
        case 2:
            
            _colorString=[NSString stringWithFormat:@"#98e1cd"];
            
            break;
        case 3:
            
            _colorString=[NSString stringWithFormat:@"#feff7f"];
            
            break;
        case 4:
            
            _colorString=[NSString stringWithFormat:@"#9fda86"];
            
            break;
        case 5:
            
            _colorString=[NSString stringWithFormat:@"#96CFED"];
            
            break;
        case 6:
            
            _colorString=[NSString stringWithFormat:@"#b5e29f"];
            
            break;
        case 7:
            
            _colorString=[NSString stringWithFormat:@"#dba9aa"];
            
            break;
        case 8:
            
            _colorString=[NSString stringWithFormat:@"#f1a5ef"];
            
            break;
        case 9:
            
            _colorString=[NSString stringWithFormat:@"#d0d0d0"];
            
            break;
            
    }
    
    [self.delegate backgroundNoteColor:self];
    [_delegate dismissNoteColor:Notecolor WithTag:btn.tag];
    
}


//buttons title

- (IBAction)colorButtonPressed:(id)sender {
    
    
    _colorButtonPressed.backgroundColor=[UIColor whiteColor];
    [_colorButtonPressed setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _colorView.hidden=NO;
    
}





@end
