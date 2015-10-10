//
//  masterCodeViewController.m
//  NoteShare
//
//  Created by Heba khan on 19/09/15.
//  Copyright © 2015 Heba khan. All rights reserved.
//

#import "masterCodeViewController.h"
#import "DataManger.h"
@interface masterCodeViewController ()

@end

@implementation masterCodeViewController
int selectNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _done.hidden=YES;
    
    _lblTitle.text=@"Enter Password to unlock note";
    
    
   
    
    
}
-(void)setNoteItems:(DBNoteItems *)noteItems
{
    
    _noteItems=noteItems;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    if ([[[DataManger sharedmanager] getMasterLockCode] length]<=0)
    {
        _lblTitle.text=@"Create Password to secure your note";
        [_done setTitle:@"Done" forState:UIControlStateNormal];
        
    }else
    {
         _lblTitle.text=@"Enter Password to unlock your note";
        [_done setTitle:@"Unlock" forState:UIControlStateNormal];
        _done.hidden=YES;
    }
    _screen.layer.borderColor=[UIColor whiteColor].CGColor;
    _screen.layer.borderWidth=0.5f;
    
    [self clearFeilds];
    
}
-(void)clearFeilds
{
    selectNumber=0;
    
    _txtDigit1.text=@"";
    _txtDigit2.text=@"";
    _txtDigit3.text=@"";
    _txtDigit4.text=@"";
    selectNumber=0;
    _screen.text=[NSString stringWithFormat:@""];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btn1:(id)sender {
    _done.hidden=YES;
    selectNumber=selectNumber*10;
    selectNumber=selectNumber+1;
  
    
    _screen.text=[NSString stringWithFormat:@"%i",selectNumber];
       [self updatetextFiels:[NSString stringWithFormat:@"%i",1]];
    
}

- (IBAction)btn2:(id)sender {
    _done.hidden=YES;
    selectNumber=selectNumber*10;
    selectNumber=selectNumber+2;
    _screen.text=[NSString stringWithFormat:@"%i",selectNumber];
     [self updatetextFiels:[NSString stringWithFormat:@"%i",2]];
    
    
}

- (IBAction)btn3:(id)sender {
    _done.hidden=YES;
    selectNumber=selectNumber*10;
    selectNumber=selectNumber+3;
   
    
    _screen.text=[NSString stringWithFormat:@"%i",selectNumber];
      [self updatetextFiels:[NSString stringWithFormat:@"%i",3]];
}

- (IBAction)btn4:(id)sender {
    _done.hidden=YES;
    
    selectNumber=selectNumber*10;
    selectNumber=selectNumber+4;
   
    
    _screen.text=[NSString stringWithFormat:@"%i",selectNumber];
      [self updatetextFiels:[NSString stringWithFormat:@"%i",4]];
}

- (IBAction)btn5:(id)sender {
    _done.hidden=YES;
    selectNumber=selectNumber*10;
    selectNumber=selectNumber+5;
    
    
    _screen.text=[NSString stringWithFormat:@"%i",selectNumber];
     [self updatetextFiels:[NSString stringWithFormat:@"%i",5]];
}

- (IBAction)btn6:(id)sender {
    _done.hidden=YES;
    selectNumber=selectNumber*10;
    selectNumber=selectNumber+6;
  
    
    _screen.text=[NSString stringWithFormat:@"%i",selectNumber];
       [self updatetextFiels:[NSString stringWithFormat:@"%i",6]];
}

- (IBAction)btn7:(id)sender {
    _done.hidden=YES;
    selectNumber=selectNumber*10;
    selectNumber=selectNumber+7;
    
    
    _screen.text=[NSString stringWithFormat:@"%i",selectNumber];
    [self updatetextFiels:[NSString stringWithFormat:@"%i",7]];
}

- (IBAction)btn8:(id)sender {
    _done.hidden=YES;
    selectNumber=selectNumber*10;
    selectNumber=selectNumber+8;
    
    
    _screen.text=[NSString stringWithFormat:@"%i",selectNumber];
     [self updatetextFiels:[NSString stringWithFormat:@"%i",8]];
}

- (IBAction)btn9:(id)sender {
    _done.hidden=YES;
    selectNumber=selectNumber*10;
    selectNumber=selectNumber+9;
    
    
    _screen.text=[NSString stringWithFormat:@"%i",selectNumber];
    [self updatetextFiels:[NSString stringWithFormat:@"%i",9]];
}

- (IBAction)btn0:(id)sender {
    _done.hidden=YES;
    
    selectNumber=selectNumber*10;
    selectNumber=selectNumber+0;
   
    
    _screen.text=[NSString stringWithFormat:@"%i",selectNumber];
     [self updatetextFiels:[NSString stringWithFormat:@"%i",0]];
}

- (IBAction)clear:(id)sender {
    
    _done.hidden=YES;
    selectNumber=0;
    _screen.text=[NSString stringWithFormat:@""];
   
    _txtDigit1.text=@"";
    _txtDigit2.text=@"";
    _txtDigit3.text=@"";
    _txtDigit4.text=@"";
    
    
}
- (IBAction)done:(id)sender
{
    
    UIButton *btnSender=(UIButton*)sender;
    
    if (_screen.text.length>0)
    {
        
        if ([btnSender.titleLabel.text.lowercaseString isEqualToString:@"unlock"])
        {
            
            NSString *lockCode=[[DataManger sharedmanager] getMasterLockCode] ;
            
            if ([lockCode isEqualToString:_screen.text])
            {
                DBManager *dbmanager=[[DBManager alloc]init];
                _noteItems.note_lock=@"0";
                [dbmanager UpdateNoteLock:[dbmanager getDbFilePath] withNoteItem:_noteItems];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    if ([_delegate respondsToSelector:@selector(didNoteUnlock:)])
                    {
                        [_delegate didNoteUnlock:YES];
                    }
                }];
            }else
            {
                
                  [[[UIAlertView alloc]initWithTitle:@"" message:@"Incorrect master password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }
            
            
        }
        else
        {
            NSLog(@"Lock code:%@",_screen.text);
            [[DataManger sharedmanager]setMasterLockCode:_screen.text];
            
            DBManager *dbmanager=[[DBManager alloc]init];
            _noteItems.note_lock=@"1";
            [dbmanager UpdateNoteLock:[dbmanager getDbFilePath] withNoteItem:_noteItems];
            
            [[[UIAlertView alloc]initWithTitle:@"" message:@"Master lock has been set" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            
            [self dismissViewControllerAnimated:YES completion:^{
                if ([_delegate respondsToSelector:@selector(didNoteUnlock:)])
                {
                    [_delegate didNoteUnlock:NO];
                }
            }];
        }
        
        
       
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (IBAction)close:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)updatetextFiels:(NSString*)string
{
    
    if (_screen.text.length<5)
    {
        if (_txtDigit1.text.length<=0)
        {
            _txtDigit1.text=string;
        }else
            if (_txtDigit2.text.length<=0)
            {
                _txtDigit2.text=string;
            }else
                if (_txtDigit3.text.length<=0)
                {
                    _txtDigit3.text=string;
                }
                else
                    if (_txtDigit4.text.length<=0)
                    {
                        _txtDigit4.text=string;
                    }
        
        if (_screen.text.length==4)
        {
            
            
            if (_isCommingFrom)
            {
                
                NSString *lockCode=[[DataManger sharedmanager] getMasterLockCode] ;
                
                if ([lockCode isEqualToString:_screen.text])
                {
                    [self dismissViewControllerAnimated:YES completion:^{
                        if ([_delegate respondsToSelector:@selector(openNote:)])
                        {
                            [_delegate openNote:YES];
                        }
                    }];
                    
                }else{
                    
                      [self clearFeilds];
                    
                     [[[UIAlertView alloc]initWithTitle:@"" message:@"Incorrect master password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    
                }
                
             
                
            }else{
                
                if ([_done.titleLabel.text.lowercaseString isEqualToString:@"unlock"])
                {
                    
                    NSString *lockCode=[[DataManger sharedmanager] getMasterLockCode] ;
                    
                    if ([lockCode isEqualToString:_screen.text])
                    {
                        DBManager *dbmanager=[[DBManager alloc]init];
                        _noteItems.note_lock=@"0";
                        [dbmanager UpdateNoteLock:[dbmanager getDbFilePath] withNoteItem:_noteItems];
                        
                        
                        
                        [self dismissViewControllerAnimated:YES completion:^{
                            if ([_delegate respondsToSelector:@selector(didNoteUnlock:)])
                            {
                                [_delegate didNoteUnlock:YES];
                            }
                        }];
                    }else
                    {
                          [self clearFeilds];
                        
                        [[[UIAlertView alloc]initWithTitle:@"" message:@"Incorrect master password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    }
                    
                    
                }
                else
                {
                    
                    NSLog(@"Lock code:%@",_screen.text);
                    [[DataManger sharedmanager]setMasterLockCode:_screen.text];
                    
                    DBManager *dbmanager=[[DBManager alloc]init];
                    _noteItems.note_lock=@"1";
                    [dbmanager UpdateNoteLock:[dbmanager getDbFilePath] withNoteItem:_noteItems];
                    
                    
                    [[[UIAlertView alloc]initWithTitle:@"" message:@"Master lock has been set" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        if ([_delegate respondsToSelector:@selector(didNoteUnlock:)])
                        {
                            [_delegate didNoteUnlock:NO];
                        }
                    }];
                }
                
            }
           
        }
       
       
    }
    else
    {

        if ([_done.titleLabel.text.lowercaseString isEqualToString:@"unlock"])
        {
            
            NSString *lockCode=[[DataManger sharedmanager] getMasterLockCode] ;
            
            if ([lockCode isEqualToString:_screen.text])
            {
                DBManager *dbmanager=[[DBManager alloc]init];
                _noteItems.note_lock=@"0";
                [dbmanager UpdateNoteLock:[dbmanager getDbFilePath] withNoteItem:_noteItems];
                
                
                [self dismissViewControllerAnimated:YES completion:^{
                   
                    if ([_delegate respondsToSelector:@selector(didNoteUnlock:)])
                    {
                        [_delegate didNoteUnlock:YES];
                    }
                }];
                
            }else
            {
                  [self clearFeilds];
                
                [[[UIAlertView alloc]initWithTitle:@"" message:@"Incorrect master password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }
            
            
        }
        else
        
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Password not more than 4 digit" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
        
    }
    
    
    
}
@end
