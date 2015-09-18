//
//  colorPaperPopupViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 03/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "colorPaperPopupViewController.h"
#import "UIViewController+CWPopup.h"

@interface colorPaperPopupViewController ()

@end

@implementation colorPaperPopupViewController

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
    // Do any additional setup after loading the view from its nib.
    // use toolbar as background because its pretty in iOS7
    // UIToolbar *toolbarBackground = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 44, 200, 106)];
    // [self.view addSubview:toolbarBackground];
    //[self.view sendSubviewToBack:toolbarBackground];
    // set size
    
    _colorButtonPressed.backgroundColor=[UIColor whiteColor];
    [_colorButtonPressed setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_papersButtonPressed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _papersButtonPressed.backgroundColor=[UIColor clearColor];
    
    
    _colorView.hidden=NO;
    _paperView.hidden=YES;
    
    
    //border to paper buttons
    [[_paper1 layer] setBorderWidth:1.0f];
    [[_paper1 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_paper2 layer] setBorderWidth:1.0f];
    [[_paper2 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_paper3 layer] setBorderWidth:1.0f];
    [[_paper3 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_paper4 layer] setBorderWidth:1.0f];
    [[_paper4 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_paper5 layer] setBorderWidth:1.0f];
    [[_paper5 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_paper6 layer] setBorderWidth:1.0f];
    [[_paper6 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [[_paper7 layer] setBorderWidth:1.0f];
    [[_paper7 layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
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
    
    if ([_delegate respondsToSelector:@selector(dismissColorTable: WithTag:)])

        
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
        
        [self.delegate backgroundColor:self];
        [_delegate dismissColorTable:colorTable WithTag:btn.tag];
    
}

-(void)pageTable:(id)sender{
    
    UIButton * PressedButton = (UIButton*)sender;
    
    if ([_delegate respondsToSelector:@selector(dismissPageTable: WithTag:)])
    {
        
            
            switch(PressedButton.tag)
            {
                case 0:
                    
                   
                   _pageString=[NSString stringWithFormat:@""];
                    
                    
                    break;
                case 1:
                    
                   _pageString=[NSString stringWithFormat:@"paper1.png"];
                    
                    break;
                case 2:
                    
                    _pageString=[NSString stringWithFormat:@"paper2.png"];
                    
                    break;
                case 3:
                    
                    _pageString=[NSString stringWithFormat:@"paper3.png"];
                    
                    break;
                case 4:
                    
                   _pageString=[NSString stringWithFormat:@"paper4.png"];
                    
                    break;
                case 5:
                    
                    _pageString=[NSString stringWithFormat:@"paper5.png"];
                    
                    break;
                case 6:
                    
                    _pageString=[NSString stringWithFormat:@"paper6.png"];
                    
                    break;
                    /*
                case 7:
                    
                    _pageString=[NSString stringWithFormat:@"screen8.png"];
                    
                    break;
                case 8:
                    
                    _pageString=[NSString stringWithFormat:@"screen9.png"];
                    
                    break;
                case 9:
                    
                    _pageString=[NSString stringWithFormat:@"screen10.png"];
                    
                    break;
                  */              
            }
            
        
        
        [self.delegate backgroundPage:self];
        [_delegate dismissPageTable:pageTable WithTag:PressedButton.tag];
    }
    
}


//buttons title

- (IBAction)colorButtonPressed:(id)sender {
    
    
    _colorButtonPressed.backgroundColor=[UIColor whiteColor];
    _papersButtonPressed.backgroundColor=[UIColor clearColor];
    
    [_colorButtonPressed setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_papersButtonPressed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    _colorView.hidden=NO;
    _paperView.hidden=YES;
}

- (IBAction)papersButtonPressed:(id)sender {
    
    _colorView.hidden=YES;
    _paperView.hidden=NO;
    
    [_colorButtonPressed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_papersButtonPressed setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _colorButtonPressed.backgroundColor=[UIColor clearColor];
    _papersButtonPressed.backgroundColor=[UIColor whiteColor];
}


@end
