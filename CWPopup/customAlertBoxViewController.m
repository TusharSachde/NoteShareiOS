//
//  customAlertBoxViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 21/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "customAlertBoxViewController.h"
#import "UIViewController+CWPopup.h"

@interface customAlertBoxViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *lblAlertTitle;

@end

@implementation customAlertBoxViewController

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
    
    _red = 0.0/255.0;
    _green = 0.0/255.0;
    _blue = 0.0/255.0;
    
    
    _lblAlertTitle.title=_stringAlertTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)colorBtn:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    
    if ([_delegate respondsToSelector:@selector(dismissView: WithTag:)])
    {
        [_delegate dismissView:colorBtn WithTag:btn.tag];
    }
}

-(void)selectBrushColor:(id)sender{
    
    UIButton * PressedButton = (UIButton*)sender;
    
    if ([_delegate respondsToSelector:@selector(dismissColor: WithTag:)])
    {
        
        switch(PressedButton.tag)
        {
            case 0:
                _red = 255.0/255.0;
                _green = 255.0/255.0;
                _blue = 255.0/255.0;
                break;
            case 1:
                _red = 255.0/255.0;
                _green = 44.0/255.0;
                _blue = 8.0/255.0;
                break;
            case 2:
                _red = 255.0/255.0;
                _green = 255.0/255.0;
                _blue = 0.0/255.0;
                break;
            case 3:
                _red = 44.0/255.0;
                _green = 0.0/255.0;
                _blue = 230.0/255.0;
                break;
            case 4:
                _red = 255.0/255.0;
                _green = 198.0/255.0;
                _blue = 230.0/255.0;
                break;
            case 5:
                _red = 192.0/255.0;
                _green = 48.0/255.0;
                _blue = 103.0/255.0;
                break;
            case 6:
                _red = 153.0/255.0;
                _green = 102.0/255.0;
                _blue = 51.0/255.0;
                break;
            case 7:
                _red = 0.0/255.0;
                _green = 255.0/255.0;
                _blue = 255.0/255.0;
                break;
            case 8:
                _red = 255.0/255.0;
                _green = 0.0/255.0;
                _blue = 255.0/255.0;
                break;
            case 9:
                _red = 127.0/255.0;
                _green = 0.0/255.0;
                _blue = 127.0/255.0;
                break;
            case 10:
                _red = 1.0/255.0;
                _green = 162.0/255.0;
                _blue = 255.0/255.0;
                break;
            case 11:
                _red = 0.0/255.0;
                _green = 255.0/255.0;
                _blue = 0.0/255.0;
                break;
            case 12:
                _red = 228.0/255.0;
                _green = 235.0/255.0;
                _blue = 173.0/255.0;
                break;
            case 13:
                _red = 216.0/255.0;
                _green = 169.0/255.0;
                _blue = 232.0/255.0;
                break;

        }
       
        [self.delegate selectcolor:self];
        [_delegate dismissColor:selectBrushColor WithTag:PressedButton.tag];
    }

}





@end
