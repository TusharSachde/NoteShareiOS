//
//  AddProjectViewController.m
//  NotesSharingApp
//  Created by Heba khan on 24/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.


#import "AddProjectViewController.h"
#import "ImageCell.h"
#import "audioCell.h"
#import "brushAlertViewController.h"
#import "UIViewController+CWPopup.h"
#import "FontPopupViewController.h"
#import "colorPaperPopupViewController.h"
#import "UIColor+SIAdditions.h"
#import "SWRevealViewController.h"
#import "SMCThemesSupport.h"
#import "DBManager.h"
#import "NSArray+SIAdditions.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "NoteColorViewController.h"
#import "textCell.h"
#import <EventKit/EventKit.h>
#import "AudioFullViewController.h"



#define isPause [UIImage imageNamed:@"recording_status.png"]//isRecording=yes
#define isNotPaused [UIImage imageNamed:@"pause_audio.png"]//isRecording=no



@interface AddProjectViewController ()<PopUpViewDelegate,audioCellDelegate,UITextViewDelegate>

{
    
   //  EKEventStore *store;
    UIImageView *BigimgView;
    NSInteger action;
    NSIndexPath *pathIndex;
    UIView *viewBg;
    NSString *newTitle;
      BOOL  _isFound;
}

@property (nonatomic,strong)NSMutableArray *photoArr;
@property(nonatomic,strong)UIActionSheet *actionSheet1;
@property(nonatomic,strong)UIActionSheet *actionSheet2;
@property(nonatomic,assign)NSInteger temp;
@property(nonatomic,assign)NSInteger audioIndexPath;

@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) AVAudioPlayer *player;

@property (nonatomic,strong)NSTimer *myTimer;
@property (nonatomic,strong)NSMutableAttributedString *attFinalString;
@property (nonatomic,strong)NSString *strFontValue;
@property (nonatomic,strong)NSString *strSizeValue;
@property (nonatomic,strong) UIFont *currentSelectedFont;

@property (nonatomic,strong) NSURL *outputFileURL;
@property (nonatomic,strong) NSMutableArray *arrayListOfRecordSound;
@property(nonatomic,assign)NSInteger sizeValue;
@property(nonatomic,strong)NSString *strCurrentFilename;

@property(nonatomic,strong)NSMutableArray *arrNotes;
@property(nonatomic,strong)audioCell *currentCell;
@property(nonatomic,strong)NSURL *audio;

@property(nonatomic,strong)textCell *currentTextCell;

@property(nonatomic,strong)UIImageView *tempImageView;//to display page image


@property(nonatomic,assign) Boolean isBold;
@property(nonatomic,assign) Boolean isItalic;
@property(nonatomic,assign) Boolean isUnderline;
@property(nonatomic,assign) Boolean isRecording;
@property(nonatomic,assign) BOOL isPlayingPaused;


@property(nonatomic)NSInteger selectedIndexPath;
@property(nonatomic,strong)NSString *totalTime;

@property(nonatomic,strong)DBManager *dbManager;
@property(nonatomic,strong)NSArray *arrAll1;

@property(nonatomic,strong)NSMutableDictionary *dictAllnoteElement;
@property(nonatomic,strong)DBNoteItems *updatedItems;

@property(nonatomic,strong)NSURL *strigImgaeUrl;
@property(nonatomic,strong)NSURL *strigScribleUrl;
@property(nonatomic,strong)NSAttributedString *strtext;

@property(nonatomic,strong)NSString *bgColor;
@property(nonatomic,assign)BOOL isText;
@property(nonatomic)NSInteger currentEditedIndexPath;
@property(nonatomic,strong)NSString *editedTextString;



@property(nonatomic,weak)IBOutlet UIView *viewPickerContainer;
@property(nonatomic,weak)IBOutlet UIDatePicker *datePicker;
@property(nonatomic,weak)IBOutlet UIButton *btnDone;
@property(nonatomic,weak)IBOutlet UIButton *btnCancel;
-(IBAction)btnPickerSelcted:(id)sender;
-(IBAction)btnCancelClick:(id)sender;
-(IBAction)btnDoneClick:(id)sender;
@property (nonatomic, strong)DBNoteItems *noteItems1;
@property(nonatomic,assign)float height;

@property (nonatomic, strong) NSMutableDictionary *dictData;


@end




@implementation AddProjectViewController


//float audioDurationSeconds;

@synthesize stopButton, playButton, recordPauseButton;




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

    _currentEditedIndexPath=-1;
    _dbManager=[[DBManager alloc]init];
    _arrNotes=[[NSMutableArray alloc]init];
    
    _tableview.dataSource=self;
    _tableview.delegate=self;
    
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    _sizeValue=20;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
    //hide icon views
    _defaultView.hidden=NO;
    _defaultTableView.hidden=NO;
    _textIconView.hidden=YES;
    _scribbleIconView.hidden=YES;
    self.mainImage.hidden=YES;
    self.tempDrawImage.hidden=YES;
    //_audioIconView.hidden=YES;
    _textViewOption.hidden=YES;
    
      _height=0.0;
    //hide content views
    
    _scribleView.hidden=YES;
    
    _audioView.hidden=YES;
    
    [self getRecordingFileName ];
    
    _dictAllnoteElement=[[NSMutableDictionary alloc]init];
    
    
    [self updateInitiDictFormDb];
    [self showAndHidePickerView:NO];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //second
    lpgr.delegate = self;
    [self.tableview addGestureRecognizer:lpgr];
    
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint p = [gestureRecognizer locationInView:self.tableview];
    CGPoint location = [gestureRecognizer locationInView:self.view];
    
    pathIndex = [self.tableview indexPathForRowAtPoint:p];
    
    if (pathIndex == nil)
    {
        NSLog(@"long press on table view but not on a row");
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        
        _selectedIndexPath=pathIndex.row;
    
        CGRect targetRectangle = CGRectMake(location.x,location.y,50,50);
        
        [[UIMenuController sharedMenuController]setTargetRect:targetRectangle inView:self.view];
        
        [[UIMenuController sharedMenuController]setMenuVisible:YES animated:YES];
        
    }
    else {
        
        
    }
}

-(BOOL)canBecomeFirstResponder{
    
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    BOOL result = NO;
    
    if ( @selector(delete:) == action) {
        
        result=YES;
    }
    
    
    return result;
}


-(void)delete:(id)sender{
    
    NSLog(@"Delete");
    
    
     NoteListItem *items=[_arrNotes objectAtIndex:_selectedIndexPath];
    
    [_dbManager deleteNoteElement:[_dbManager getDbFilePath] withNoteItem:items.noteElementID];
    [self updateInitiDictFormDb];
    

}


-(void)updateInitiDictFormDb{
    
    [_arrNotes removeAllObjects];
    
    NSArray *arrItems=[_dbManager getRecordsWithNote_Id:[_dbManager getDbFilePath] where:_dbnotelistItem.note_Id];
    
    
    [_noteTitleBtn setTitle:_dbnotelistItem.note_Title forState:UIControlStateNormal];
    
    _updatedItems=[arrItems si_objectOrNilAtIndex:0];
    
    //_updatedItems.note_Reminder;
    
    if ([_updatedItems.note_Color isEqualToString:@"(null)"]) {
        _updatedItems.note_Color=@"#ffffff";
    }
    
    if ([_updatedItems.note_Color containsString:@".png"]) {
        NSLog(@"string contains .png");
        [_tableview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:_updatedItems.note_Color]]];
    }
    
    else {
        
        
        _tableview.backgroundColor = [UIColor si_getColorWithHexString:_updatedItems.note_Color];
    }
    

    NSArray *arrNoteElement=[_dbManager getAllNoteElementWithNote_Id:[_dbManager getDbFilePath] where:_updatedItems.note_Id];
    
    
    if (arrNoteElement.count>0)
    {
        

        for (DBNoteItems* dictItem in arrNoteElement)
        {
            
            NoteListItem *items=[[NoteListItem alloc]init];
            
            
            NSString *strnoteTyp=dictItem.NOTE_ELEMENT_TYPE;
            
            if ([strnoteTyp isEqualToString:@"IMAGE"])//look in return reponse
            {
                
                NSString *strpath=dictItem.NOTE_ELEMENT_CONTENT;
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library assetForURL:[NSURL URLWithString:strpath] resultBlock:^(ALAsset *asset)
                 {
                     
                     
                     if (asset) {
                         
                         UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:1.0 orientation:UIImageOrientationUp];
                         
                         items.noteElementID=dictItem.NOTE_ELEMENT_ID;
                         items.notetype=IMAGES;
                         items.noteimage=copyOfOriginalImage;
                         
                         [_arrNotes addObject:items];
                         
                         [self getSortedData];
                         
                         [_tableview reloadData];
                         
                     }
                     else
                     {
                         [_arrNotes removeObject:items];
                         [self getSortedData];
                         [_tableview reloadData];
                     
                     }
                    
                     
                 }
                        failureBlock:^(NSError *error)
                 {
                     // error handling
                     NSLog(@"failure-----");
                     
                 }];
            }
            
            
            
            else   if ([strnoteTyp isEqualToString:@"AUDIO"])//audio
            {
                
                
                NSString *strpath=dictItem.NOTE_ELEMENT_CONTENT;
                
                NSString* theFileName = [strpath lastPathComponent];
                
                items.notetype=AUDIO;
                items.strAudioPlayPath=strpath;
                items.noteElementID=dictItem.NOTE_ELEMENT_ID;
                items.strAudioTotalTime=dictItem.NOTE_ELEMENT_MEDIA_TIME;
                items.audioPlayPath=[self getAudioUrlFormFileName:theFileName];
                [_arrNotes addObject:items];
                [self getSortedData];
                [_tableview reloadData];
                
                
            }
            
            else  if ([strnoteTyp isEqualToString:@"TEXT"])//text
                
            {
                items.noteElementID=dictItem.NOTE_ELEMENT_ID;
                
                items.notetype=TEXT;
                
                if (![dictItem.NOTE_ELEMENT_CONTENT isEqualToString:@"(null)"])
                {
                     items.textString=dictItem.NOTE_ELEMENT_CONTENT;
                }
                items.height=dictItem.NOTE_ELEMENT_TEXT_HEIGHT.intValue;
               
                [self getSortedData];
                [_arrNotes addObject:items];
                
            }
            
        }
        
    }

    NSLog(@"%@",[UIColor si_getColorWithHexString:_updatedItems.note_Color]);
    

    
   

}


-(void)getSortedData{
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"noteElementID.intValue"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [_arrNotes sortedArrayUsingDescriptors:sortDescriptors];
    
    _arrNotes=[NSMutableArray arrayWithArray:sortedArray];
    
    
    
}

-(NSURL*)getAudioUrlFormFileName:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
    
    return url;
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{



    if (alertView.tag==4000)
    {
        
        switch (buttonIndex) {
            case 0:
            {
                
                NSLog(@"OK");
            }
                break;
            case 1:
            {
                NSLog(@"Edit");
                
                [self showAndHidePickerView:YES];
            }
                break;
                
            default:
                break;
        }
        
    }
    
    if (alertView.tag==2000)
    {
        
        
        
        switch (buttonIndex) {
            case 0:
            {
                
                NSLog(@"OK");
                
                NSString *strTitle=[alertView textFieldAtIndex:0].text;
                NSLog(@"ADDED TITILE:%@",strTitle);
                [_dbManager UpdateNoteTitle:[_dbManager getDbFilePath] withNoteItem:strTitle note_id:_dbnotelistItem.note_Id];
                [_noteTitleBtn setTitle:strTitle forState:UIControlStateNormal];
                [_tableview reloadData];
                
            }
                break;
            case 1:
            {
                NSLog(@"Cancel");
            
            }
                break;
                
            default:
                break;
        }
        
    }



}

-(void)getSaveBtn{
    
    
    UIView *viewLeftnavBar=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0,100, 44)];
    viewLeftnavBar.backgroundColor=[UIColor clearColor];
    
    
    
    UIButton *Btn=[[UIButton alloc]initWithFrame:CGRectMake(32.0, 7.0, 30, 30)];
    
    
    [Btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@""]]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:Btn];
    
    
    UIButton *BtnColor=[[UIButton alloc]initWithFrame:CGRectMake(28.0, 5.0, 30, 30)];
    [BtnColor setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"colorPlate.png"]]  forState:UIControlStateNormal];
    [BtnColor addTarget:self action:@selector(ButtonColor:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:BtnColor];
    
    
    UIButton *Btn2=[[UIButton alloc]initWithFrame:CGRectMake(68.0, 5.0, 28, 28)];
    [Btn2 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"save.png"]]  forState:UIControlStateNormal];
    [Btn2 addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:Btn2];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:viewLeftnavBar];
    [self.navigationItem setRightBarButtonItem:addButton];
    
}

-(void)scribbleNavBar{
    
    
    UIView *viewLeftnavBar=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0,100, 44)];
    viewLeftnavBar.backgroundColor=[UIColor clearColor];
    
    
    UIButton *Btn=[[UIButton alloc]initWithFrame:CGRectMake(32.0, 5.0, 30, 30)];
    
    
    [Btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@""]]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:Btn];
    
    
    
    UIButton *Btn2=[[UIButton alloc]initWithFrame:CGRectMake(68.0, 5.0, 28, 28)];
    [Btn2 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"save.png"]]  forState:UIControlStateNormal];
    [Btn2 addTarget:self action:@selector(ScribblebackBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:Btn2];
    
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:viewLeftnavBar];
    [self.navigationItem setRightBarButtonItem:addButton];
    
}

-(void)audioNavBar{
    
    
    UIView *viewLeftnavBar=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0,100, 44)];
    viewLeftnavBar.backgroundColor=[UIColor clearColor];
    
    
    UIButton *Btn=[[UIButton alloc]initWithFrame:CGRectMake(32.0, 5.0, 30, 30)];
    
    
    [Btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@""]]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:Btn];
    
    
    UIButton *BtnColor=[[UIButton alloc]initWithFrame:CGRectMake(32.0, 5.0, 30, 30)];
    [BtnColor setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"share.png"]]  forState:UIControlStateNormal];
    [BtnColor addTarget:self action:@selector(shareButtonNavBar:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:BtnColor];
    
    
    
    
    
    UIButton *Btn2=[[UIButton alloc]initWithFrame:CGRectMake(68.0, 5.0, 28, 28)];
    [Btn2 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"save.png"]]  forState:UIControlStateNormal];
    [Btn2 addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:Btn2];
    
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:viewLeftnavBar];
    [self.navigationItem setRightBarButtonItem:addButton];
    
}

-(IBAction)backBtnPress:(id)sender{
    
}

-(IBAction)shareButtonNavBar:(id)sender{
    
    
}

-(void)textNavBar{
    
    
    UIView *viewLeftnavBar=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0,100, 44)];
    viewLeftnavBar.backgroundColor=[UIColor clearColor];
    
    
    
    UIButton *Btn=[[UIButton alloc]initWithFrame:CGRectMake(32.0, 5.0, 30, 30)];
    
    
    [Btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@""]]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:Btn];
    
    
//    UIButton *BtnColor=[[UIButton alloc]initWithFrame:CGRectMake(32.0, 5.0, 30, 30)];
//    [BtnColor setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"color_sort_view.png"]]  forState:UIControlStateNormal];
//    [BtnColor addTarget:self action:@selector(TextButtonNavBar:) forControlEvents:UIControlEventTouchUpInside];
//    [viewLeftnavBar addSubview:BtnColor];
    
    
    UIButton *Btn2=[[UIButton alloc]initWithFrame:CGRectMake(68.0, 5.0, 28, 28)];
    [Btn2 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"save.png"]]  forState:UIControlStateNormal];
    [Btn2 addTarget:self action:@selector(TextbackBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:Btn2];
    
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:viewLeftnavBar];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    
    
}

//-(IBAction)TextButtonNavBar:(id)sender{
//    
//    FontPopupViewController *samplePopupViewController = [[FontPopupViewController alloc] initWithNibName:@"FontPopupViewController" bundle:nil];
//    samplePopupViewController.delegate=self;
//    
//    [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
//        NSLog(@"popup view presented");
//    }];
//    
//    
//}

-(IBAction)TextbackBtnPress:(id)sender{
    
        
       // dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if (_isText)
            {
                NoteListItem *currentItem=[_arrNotes si_objectOrNilAtIndex:_currentEditedIndexPath];
                if (currentItem&&_editedTextString.length>0&&![_editedTextString isEqualToString:defaultText])
                {
                    currentItem.textString=_editedTextString;
                    currentItem.isEdited=NO;
                    
                    
                    //[self upadteNote:_arrNotes];
                    
                    [_dbManager UpdateTextNoteElementContent:[_dbManager getDbFilePath] withNoteItem:_editedTextString note_Element_id:currentItem.noteElementID note_Element_height:[NSString stringWithFormat:@"%f",_height+44]];
                    
                    [self updateInitiDictFormDb];
                    
                    
                }
                
            }
            
            
            [self.view endEditing:YES];
    
            //[self.tableview reloadData];
            
            
       // });

    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
     
        
        [_tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentEditedIndexPath inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
        [_tableview beginUpdates];
        [_tableview endUpdates];
        
           _currentEditedIndexPath=-1;
        _height=0.0;
    });

    _isText=NO;
    
    _textButton.userInteractionEnabled=YES;
    
    [self getSaveBtn];
    
 

    
}

-(IBAction)ScribblebackBtnPress:(id)sender{
    
    _temp=100;
    _actionSheet1 = [[UIActionSheet alloc] initWithTitle:@""
                                                delegate:self
                                       cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:@"Save to View", @"Cancel", nil];
    [_actionSheet1 showInView:self.view];
    
    
}

-(IBAction)ButtonColor:(id)sender{
    
    colorPaperPopupViewController *samplePopupViewController = [[colorPaperPopupViewController alloc] initWithNibName:@"colorPaperPopupViewController" bundle:nil];
    samplePopupViewController.delegate=self;
    
    [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
        NSLog(@"popup view presented");
    }];
    
}

-(IBAction)TBtnPressed:(id)sender{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraButton:(id)sender {
    
    _temp=200;
    _isText=NO;
    
    _actionSheet2 = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
    _actionSheet2.actionSheetStyle = UIActionSheetStyleDefault;
    [_actionSheet2 showInView:self.view];
    
    _moreButton.backgroundColor=[UIColor clearColor];
    _shareButton.backgroundColor=[UIColor clearColor];
    _audioNotesButton.backgroundColor=[UIColor clearColor];
    _cameraButton.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _textButton.backgroundColor=[UIColor clearColor];
    _scribbleNotesButton.backgroundColor=[UIColor clearColor];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    
    if (_temp==200) {
        
        
        
        switch (buttonIndex) {
            case 0:
            //camera clicked
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
            
            break;
            case 1:
            //gallery clicked
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
            break;
            case 2:
            //Cancel Button Clicked"
            break;
        }
        
    }
    
    if (_temp==100)
    {
        
        switch (buttonIndex)
        
        {
            
            case 0:
            
            
            UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO, 0.0);
            [self.mainImage.image drawInRect:CGRectMake(0,0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
            
            UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
            
            
            UIImage *viewImage = SaveImage;
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            // Request to save the image to camera roll
            [library writeImageToSavedPhotosAlbum:[viewImage CGImage] orientation:(ALAssetOrientation)[viewImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
                if (error) {
                    NSLog(@"error");
                } else {
                    
                    
                    NoteListItem *items=[[NoteListItem alloc]init];
                    items.notetype=IMAGES;
                    items.noteimage=SaveImage;
                    items.imagePath=assetURL.description;
                    
                    [_arrNotes addObject:items];
                    [self upadteNote:_arrNotes];
                    [_tableview reloadData];
                    
                }
            }];
            
            
            UIGraphicsEndImageContext();
            
            _defaultView.hidden=NO;
            _defaultTableView.hidden=NO;
            _textIconView.hidden=YES;
            _scribbleIconView.hidden=YES;
            self.mainImage.hidden=YES;
            self.tempDrawImage.hidden=YES;
           // _audioIconView.hidden=YES;
            _textViewOption.hidden=YES;
            
            //hide content view
            
            _scribleView.hidden=YES;
            
            [self getSaveBtn];
            
            break;
        }
        
        
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image;
    image = (UIImage *)
    [info valueForKey:UIImagePickerControllerEditedImage];
    CGRect cropRect = CGRectMake(0.0, 0.0, 0.0, 0.0);
    CGImageRef croppedImage = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:cropRect];
    [myImageView setImage:[UIImage imageWithCGImage:croppedImage]];
    myImageView.contentMode=UIViewContentModeScaleAspectFit;
    
    self.photoImage = image;
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        
    }];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:image.CGImage
                                     metadata:[info objectForKey:UIImagePickerControllerMediaMetadata]
                              completionBlock:^(NSURL *assetURL, NSError *error) {
                                  
                                  if (error) {
                                      
                                      NSLog(@"error");
                                      
                                      
                                      
                                  } else {
                                      
                                      NoteListItem *items=[[NoteListItem alloc]init];
                                      //items.noteElementID=@"";
                                      items.notetype=IMAGES;
                                      items.noteimage=self.photoImage;
                                      items.imagePath=assetURL.description;
                                      [_arrNotes addObject:items];
                                      [self upadteNote:_arrNotes];
                                      [self.tableview reloadData];
                                  }
                                  
                              }];
        
        
    }
    
    else if (picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary)
    {
        
        NoteListItem *items=[[NoteListItem alloc]init];
        items.noteElementID=@"";
        items.notetype=IMAGES;
        items.noteimage=self.photoImage;
        items.imagePath=[info valueForKey:UIImagePickerControllerReferenceURL];
        [_arrNotes addObject:items];
        [self upadteNote:_arrNotes];
        [self.tableview reloadData];
        
        
    }
    
}


-(void)setDbnotelistItem:(DBNoteItems*)dbnotelistItem{
    
    _dbnotelistItem=dbnotelistItem;
}

-(NSString*)date2str:(NSDate*)myNSDateInstance onlyDate:(BOOL)onlyDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (onlyDate) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss z"];
    }
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSString *stringFromDate = [formatter stringFromDate:myNSDateInstance];
    return stringFromDate;
}


-(void)upadteNote:(NSArray*)arrNotes{
    

    NoteListItem *item = [arrNotes lastObject];
    
    [self updateNoteInNoteElementDB:item];
    
}


-(void)updateNoteInNoteElementDB:(NoteListItem*)item
{
    switch (item.notetype)
    {
        case IMAGES:
        {
            
            [_dbManager insert:[_dbManager getDbFilePath] withName:_updatedItems.note_Id note_element_content:item.imagePath note_element_type:@"IMAGE" note_element_media_time:@""];
        }
            break;
        case AUDIO:
        {
            
            
            
            [_dbManager insert:[_dbManager getDbFilePath] withName:_updatedItems.note_Id note_element_content:item.strAudioPlayPath note_element_type:@"AUDIO" note_element_media_time:item.strAudioTotalTime];
            
        }
            break;
        case TEXT:
        {
            
            
            [_dbManager insert:[_dbManager getDbFilePath] withName:_updatedItems.note_Id note_element_content:item.textString note_element_type:@"TEXT" note_element_media_time:item.strAudioTotalTime];
            
        }
            break;
            
        default:
            break;
    }
    
    
    [self updateInitiDictFormDb];
}

-(void)updateOnlyColor:(DBNoteItems*)notes{
    
    NSString *modifiedTime=[self date2str:[NSDate date] onlyDate:NO];
    _updatedItems.note_Modified_Time=modifiedTime;
    _updatedItems.note_Color=_bgColor.description;
    
    
    if ([_updatedItems.note_Color containsString:@".png"]) {
        NSLog(@"string contains .png");
        [_tableview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:_updatedItems.note_Color]]];
    } else {
        _tableview.backgroundColor = [UIColor si_getColorWithHexString:_updatedItems.note_Color];
    }
    [_dbManager UpdateNoteElements:[_dbManager getDbFilePath] withNoteItem:notes];
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    [textView scrollRangeToVisible:textView.selectedRange];
    //[_tableview scrollRectToVisible:textView.frame animated:NO];
}


-(void)updateinDb:(DBNoteItems*)notes{
    
    [_dbManager UpdateNoteElements:[_dbManager getDbFilePath] withNoteItem:notes];
    
}


- (void)videoPlayBackDidFinish:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    // Stop the video player and remove it from view
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
    self.videoController = nil;
    
    // Display a message
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Video Playback" message:@"Just finished the video playback. The video is now removed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)scribbleNotesButton:(id)sender {
    
      _isText=NO;
    
    [self scribbleNavBar];
    
    _defaultView.hidden=YES;
    _defaultTableView.hidden=YES;
    _textIconView.hidden=YES;
    _scribbleIconView.hidden=NO;
    self.mainImage.hidden=NO;
    self.tempDrawImage.hidden=NO;
    _textViewOption.hidden=YES;
    
    //views
    
    _scribleView.hidden=NO;
    
    
    _moreButton.backgroundColor=[UIColor clearColor];
    _shareButton.backgroundColor=[UIColor clearColor];
    _audioNotesButton.backgroundColor=[UIColor clearColor];
    _cameraButton.backgroundColor=[UIColor clearColor];
    _textButton.backgroundColor=[UIColor clearColor];
    _scribbleNotesButton.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
}

- (IBAction)audioNotesButton:(id)sender {
    
    [self getSaveBtn];
    
    //hide icon views
    _defaultView.hidden=NO;
    _defaultTableView.hidden=NO;
    _textIconView.hidden=YES;
    _scribbleIconView.hidden=YES;
    self.mainImage.hidden=YES;
    self.tempDrawImage.hidden=YES;
    //_audioIconView.hidden=YES;
    _textViewOption.hidden=YES;
    
    //hide content views
    _scribleView.hidden=YES;
    
    
    _moreButton.backgroundColor=[UIColor clearColor];
    _shareButton.backgroundColor=[UIColor clearColor];
    _audioNotesButton.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _cameraButton.backgroundColor=[UIColor clearColor];
    _textButton.backgroundColor=[UIColor clearColor];
    _scribbleNotesButton.backgroundColor=[UIColor clearColor];
    
    
    //visible audio
    
    [recordPauseButton setImage:isPause forState:UIControlStateNormal];
    _audioView.hidden=NO;
    _audioView.layer.borderWidth = 1.0f;
    _audioView.layer.borderColor = [[UIColor colorWithRed:(255/255) green:(90/255) blue:(96/255) alpha:1.0] CGColor];
    
    _currentTimeSlider.hidden=YES;
    
    //recording settings
    recordPauseButton.hidden=NO;
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    playButton.hidden=YES;
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],[self getRecordingFileName],
                               nil];
    
    
    _outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    
    
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    _recorder = [[AVAudioRecorder alloc] initWithURL:_outputFileURL settings:recordSetting error:nil];
    
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
}

- (IBAction)textButton:(id)sender
{
    
    
    if (!_isText)
    {
        
        _isText=YES;
        _textButton.userInteractionEnabled=NO;
        
        _editedTextString=@"";
        //_isText=YES;
        
        
        NoteListItem *items=[[NoteListItem alloc]init];
        items.notetype=TEXT;
        items.isEdited=YES;
        
        
        [_arrNotes addObject:items];
          [self upadteNote:_arrNotes];
  
        [_tableview reloadData];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self tableViewScrollToTopAnimated:YES];
            
            if (_arrNotes.count>0)
            {
                NSInteger cellIndex=_arrNotes.count-1;
                NSLog(@"The Edited Index:%li",(long)cellIndex);
                
                UITableViewCell *currentEditedCell=[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0 ]];
                
                if ([currentEditedCell isKindOfClass:[textCell class]])
                {
                    textCell *textCell1=(textCell*)currentEditedCell;
                    
                    [textCell1.textView becomeFirstResponder];
                    
                    
                }
                
            }
            
        });
        
        
        _moreButton.backgroundColor=[UIColor clearColor];
        _shareButton.backgroundColor=[UIColor clearColor];
        _audioNotesButton.backgroundColor=[UIColor clearColor];
        _cameraButton.backgroundColor=[UIColor clearColor];
        _textButton.backgroundColor=[UIColor colorWithRed:(168.0/255.0) green:(68.0/255.0) blue:(67.0/255.0) alpha:(1.0)];
        _scribbleNotesButton.backgroundColor=[UIColor clearColor];
        
        
        
       
        
        
        
    }


    
}

#pragma mark - inside notes buttons

- (IBAction)shareButton:(id)sender {
    
    _moreButton.backgroundColor=[UIColor clearColor];
    _shareButton.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _audioNotesButton.backgroundColor=[UIColor clearColor];
    _cameraButton.backgroundColor=[UIColor clearColor];
    _textButton.backgroundColor=[UIColor clearColor];
    _scribbleNotesButton.backgroundColor=[UIColor clearColor];
}

- (IBAction)moreButton:(id)sender {
    
    _moreButton.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _shareButton.backgroundColor=[UIColor clearColor];
    _audioNotesButton.backgroundColor=[UIColor clearColor];
    _cameraButton.backgroundColor=[UIColor clearColor];
    _textButton.backgroundColor=[UIColor clearColor];
    _scribbleNotesButton.backgroundColor=[UIColor clearColor];
    
    if (![_updatedItems.note_Reminder isEqualToString:@""]&&_updatedItems.note_Reminder)
    {
        
        NSDate *dateGmt=[self str2date:_updatedItems.note_Reminder onlyDate:NO];
        
        NSString *strDate=[self date2strLocal:dateGmt onlyDate:NO];
        
        
        //cell.timeStamp.text = [strDate uppercaseString];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Reminder already set for  this note,It is on :%@",[strDate uppercaseString]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"EDIT",nil];
        
        
        [alert show];
        alert.tag=4000;
        
    }
    
    else
    {
        [self showAndHidePickerView:YES];
    }
    
}

-(NSDate*)str2date:(NSString*)myNSDateInstance onlyDate:(BOOL)onlyDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (onlyDate) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss z"];
    }
    
    //Optionally for time zone conversions
    // [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate *stringFromDate = [formatter dateFromString:myNSDateInstance];
    return stringFromDate;
}

-(NSString*)date2strLocal:(NSDate*)myNSDateInstance onlyDate:(BOOL)onlyDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (onlyDate)
    {
        [formatter setDateFormat:@"dd MMM yyyy"];
    }
    else
    {
        [formatter setDateFormat: @"dd MMM yyyy hh:mm a"];
    }
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:myNSDateInstance];
    return stringFromDate;
}


-(IBAction)back:(id)sender{
    
    
    [self getSaveBtn];
    //views footer
    _defaultView.hidden=NO;
    _defaultTableView.hidden=NO;
    _textIconView.hidden=YES;
    _scribbleIconView.hidden=YES;
    self.mainImage.hidden=YES;
    self.tempDrawImage.hidden=YES;
    _textViewOption.hidden=YES;
    
    //hide content view
    
    _scribleView.hidden=YES;
    
    
    //buttons bg color
    _back.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _text1.backgroundColor=[UIColor clearColor];
    _text2.backgroundColor=[UIColor clearColor];
    _boldBtn.backgroundColor=[UIColor clearColor];
    _italicBtn.backgroundColor=[UIColor clearColor];
    _underlineBtn.backgroundColor=[UIColor clearColor];
    _optionsTxtBtn.backgroundColor=[UIColor clearColor];
    
    
    
}

-(IBAction)text1:(id)sender{
    
    _back.backgroundColor=[UIColor clearColor];
    _text1.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _text2.backgroundColor=[UIColor clearColor];
    _boldBtn.backgroundColor=[UIColor clearColor];
    _italicBtn.backgroundColor=[UIColor clearColor];
    _underlineBtn.backgroundColor=[UIColor clearColor];
    _optionsTxtBtn.backgroundColor=[UIColor clearColor];
    
    
}

-(IBAction)text2:(id)sender{
    
    _back.backgroundColor=[UIColor clearColor];
    _text1.backgroundColor=[UIColor clearColor];
    _text2.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _boldBtn.backgroundColor=[UIColor clearColor];
    _italicBtn.backgroundColor=[UIColor clearColor];
    _underlineBtn.backgroundColor=[UIColor clearColor];
    _optionsTxtBtn.backgroundColor=[UIColor clearColor];
    
}

-(IBAction)boldBtn:(id)sender{
    
    _isItalic=NO;
    _isUnderline=NO;
    _isBold = !_isBold;
    
    if(_isBold){
        _back.backgroundColor=[UIColor clearColor];
        _text1.backgroundColor=[UIColor clearColor];
        _text2.backgroundColor=[UIColor clearColor];
        _boldBtn.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
        _italicBtn.backgroundColor=[UIColor clearColor];
        _underlineBtn.backgroundColor=[UIColor clearColor];
        _optionsTxtBtn.backgroundColor=[UIColor clearColor];
    }
    else {
        _back.backgroundColor=[UIColor clearColor];
        _text1.backgroundColor=[UIColor clearColor];
        _text2.backgroundColor=[UIColor clearColor];
        _boldBtn.backgroundColor=[UIColor clearColor];
        _italicBtn.backgroundColor=[UIColor clearColor];
        _underlineBtn.backgroundColor=[UIColor clearColor];
        _optionsTxtBtn.backgroundColor=[UIColor clearColor];
    }
}

-(IBAction)italicBtn:(id)sender{
    
    _isBold=NO;
    _isUnderline=NO;
    _isItalic = !_isItalic;
    
    if(_isItalic){
        _back.backgroundColor=[UIColor clearColor];
        _text1.backgroundColor=[UIColor clearColor];
        _text2.backgroundColor=[UIColor clearColor];
        _boldBtn.backgroundColor=[UIColor clearColor];
        _italicBtn.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
        _underlineBtn.backgroundColor=[UIColor clearColor];
        _optionsTxtBtn.backgroundColor=[UIColor clearColor];
    }
    else {
        _back.backgroundColor=[UIColor clearColor];
        _text1.backgroundColor=[UIColor clearColor];
        _text2.backgroundColor=[UIColor clearColor];
        _boldBtn.backgroundColor=[UIColor clearColor];
        _italicBtn.backgroundColor=[UIColor clearColor];
        _underlineBtn.backgroundColor=[UIColor clearColor];
        _optionsTxtBtn.backgroundColor=[UIColor clearColor];
    }
    
    
}

-(IBAction)underlineBtn:(id)sender{
    
    
    _isBold=NO;
    _isItalic=NO;
    _isUnderline = !_isUnderline;
    
    if(_isUnderline){
        _back.backgroundColor=[UIColor clearColor];
        _text1.backgroundColor=[UIColor clearColor];
        _text2.backgroundColor=[UIColor clearColor];
        _boldBtn.backgroundColor=[UIColor clearColor];
        _italicBtn.backgroundColor=[UIColor clearColor];
        _underlineBtn.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
        _optionsTxtBtn.backgroundColor=[UIColor clearColor];
    }
    else {
        _back.backgroundColor=[UIColor clearColor];
        _text1.backgroundColor=[UIColor clearColor];
        _text2.backgroundColor=[UIColor clearColor];
        _boldBtn.backgroundColor=[UIColor clearColor];
        _italicBtn.backgroundColor=[UIColor clearColor];
        _underlineBtn.backgroundColor=[UIColor clearColor];
        _optionsTxtBtn.backgroundColor=[UIColor clearColor];
    }
}


#pragma hideKeyboard

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSInteger currentEditTag=textView.tag;
    _currentEditedIndexPath=currentEditTag;
    
    
    _editedTextString=textView.text;
    NSLog(@"_editedTextString:%@",_editedTextString);
    
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textView{
    
    return YES;
}

-(IBAction)optionsTxtBtn:(id)sender{
    
    _back.backgroundColor=[UIColor clearColor];
    _text1.backgroundColor=[UIColor clearColor];
    _text2.backgroundColor=[UIColor clearColor];
    _boldBtn.backgroundColor=[UIColor clearColor];
    _italicBtn.backgroundColor=[UIColor clearColor];
    _underlineBtn.backgroundColor=[UIColor clearColor];
    _optionsTxtBtn.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    
}

- (IBAction)scribleBckBtn:(id)sender {
    
    //views footer
    _defaultView.hidden=NO;
    _defaultTableView.hidden=NO;
    _textIconView.hidden=YES;
    _scribbleIconView.hidden=YES;
    self.mainImage.hidden=YES;
    self.tempDrawImage.hidden=YES;
    //_audioIconView.hidden=YES;
    _textViewOption.hidden=YES;
    
    //hide content view
    
    _scribleView.hidden=YES;
    
    
    
    _scribleBckBtn.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _sqBrushbtn.backgroundColor=[UIColor clearColor];
    _scribleBrushBtn.backgroundColor=[UIColor clearColor];
    _undoBtn.backgroundColor=[UIColor clearColor];
    _highlighterBtn.backgroundColor=[UIColor clearColor];
    _eraserBtn.backgroundColor=[UIColor clearColor];
    _scribleOptionsBtn.backgroundColor=[UIColor clearColor];
    
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in photoalbum"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

- (IBAction)sqBrushbtn:(id)sender {
    
    
    _scribleBckBtn.backgroundColor=[UIColor clearColor];
    _sqBrushbtn.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _scribleBrushBtn.backgroundColor=[UIColor clearColor];
    _undoBtn.backgroundColor=[UIColor clearColor];
    _highlighterBtn.backgroundColor=[UIColor clearColor];
    _eraserBtn.backgroundColor=[UIColor clearColor];
    _scribleOptionsBtn.backgroundColor=[UIColor clearColor];
    
    
    self.mainImage.image = nil;
    
    
}

- (IBAction)scribleBrushBtn:(id)sender {
    
    _scribleBckBtn.backgroundColor=[UIColor clearColor];
    _sqBrushbtn.backgroundColor=[UIColor clearColor];
    _scribleBrushBtn.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _undoBtn.backgroundColor=[UIColor clearColor];
    _highlighterBtn.backgroundColor=[UIColor clearColor];
    _eraserBtn.backgroundColor=[UIColor clearColor];
    _scribleOptionsBtn.backgroundColor=[UIColor clearColor];
}

- (IBAction)undoBtn:(id)sender {
    
    _scribleBckBtn.backgroundColor=[UIColor clearColor];
    _sqBrushbtn.backgroundColor=[UIColor clearColor];
    _scribleBrushBtn.backgroundColor=[UIColor clearColor];
    _undoBtn.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _highlighterBtn.backgroundColor=[UIColor clearColor];
    _eraserBtn.backgroundColor=[UIColor clearColor];
    _scribleOptionsBtn.backgroundColor=[UIColor clearColor];
    
    
    
    customAlertBoxViewController *samplePopupViewController = [[customAlertBoxViewController alloc] initWithNibName:@"customAlertBoxViewController" bundle:nil];
    [samplePopupViewController setStringAlertTitle:@"Select Color"];
    samplePopupViewController.delegate=self;
    
    [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
        NSLog(@"popup view presented");
    }];
    
    
}

- (IBAction)highlighterBtn:(id)sender {
    
    _scribleBckBtn.backgroundColor=[UIColor clearColor];
    _sqBrushbtn.backgroundColor=[UIColor clearColor];
    _scribleBrushBtn.backgroundColor=[UIColor clearColor];
    _undoBtn.backgroundColor=[UIColor clearColor];
    _highlighterBtn.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _eraserBtn.backgroundColor=[UIColor clearColor];
    _scribleOptionsBtn.backgroundColor=[UIColor clearColor];
    
    
    brushAlertViewController *samplePopupViewController = [[brushAlertViewController alloc] initWithNibName:@"brushAlertViewController" bundle:nil];
    [samplePopupViewController setStringAlertTitle:@"Select Brush Size"];
    samplePopupViewController.delegate=self;
    
    [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
        NSLog(@"popup view presented");
    }];
}

- (IBAction)eraserBtn:(id)sender {
    
    
    _scribleBckBtn.backgroundColor=[UIColor clearColor];
    _sqBrushbtn.backgroundColor=[UIColor clearColor];
    _scribleBrushBtn.backgroundColor=[UIColor clearColor];
    _undoBtn.backgroundColor=[UIColor clearColor];
    _highlighterBtn.backgroundColor=[UIColor clearColor];
    _eraserBtn.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _scribleOptionsBtn.backgroundColor=[UIColor clearColor];
    
    
    brushAlertViewController *samplePopupViewController = [[brushAlertViewController alloc] initWithNibName:@"brushAlertViewController" bundle:nil];
    [samplePopupViewController setStringAlertTitle:@"Select Eraser Size"];
    samplePopupViewController.delegate=self;
    
    red = 255.0/255.0;
    green = 255.0/255.0;
    blue = 255.0/255.0;
    opacity = 1.0;
    
    [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
        NSLog(@"popup view presented");
    }];
    
}

- (IBAction)scribleOptionsBtn:(id)sender {
    
    
    _scribleBckBtn.backgroundColor=[UIColor clearColor];
    _sqBrushbtn.backgroundColor=[UIColor clearColor];
    _scribleBrushBtn.backgroundColor=[UIColor clearColor];
    _undoBtn.backgroundColor=[UIColor clearColor];
    _highlighterBtn.backgroundColor=[UIColor clearColor];
    _eraserBtn.backgroundColor=[UIColor clearColor];
    _scribleOptionsBtn.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
}

-(void)dismissColor:(OPTIONSELECTED)selectedOption WithTag:(NSInteger)selectedOption{
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
        
    }];
    
}

-(void)dismissBrushView:(brushSelected)selectedOption WithTag:(NSInteger)selectedOption{
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)dismissEraserView:(brushSelected)selectedOption WithTag:(NSInteger)selectedOption{
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)brushSize:(id)sender{
    
    brush = ((brushAlertViewController*)sender).brush;
    
}

- (void)selectcolor:(id)sender{
    
    red=((customAlertBoxViewController*)sender).red;
    green=((customAlertBoxViewController*)sender).green;
    blue=((customAlertBoxViewController*)sender).blue;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(void)backgroundColor:(id)sender{
    
    [self.tableview setBackgroundColor: [UIColor si_getColorWithHexString:((colorPaperPopupViewController*)sender).colorString]];
    
    _bgColor=((colorPaperPopupViewController*)sender).colorString;
    
    _updatedItems.note_Color=_bgColor;

    [self updateOnlyColor:_updatedItems];
    NSLog(@"BGCOLOR IS %%%%%%%%%%%% = %@",_bgColor);
    
}

-(void)backgroundPage:(id)sender{
    
    
    _tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:((colorPaperPopupViewController*)sender).pageString]];
    [_tempImageView setFrame:self.tableview.frame];
    
    
    self.tableview.backgroundView =_tempImageView;
    
    
    _bgColor=((colorPaperPopupViewController*)sender).pageString;
    
    _updatedItems.note_Color=_bgColor;
    
    
    [self updateOnlyColor:_updatedItems];
    NSLog(@"BGCOLOR IS %%%%%%%%%%%% = %@",_bgColor);
    
    
}

-(void)dismissColorTable:(selectColorPaper)selectedOption WithTag:(NSInteger)selectedOption{
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
    }];
    
    
}

-(void)dismissPageTable:(selectColorPaper)selectedOption WithTag:(NSInteger)selectedOption{
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
        
        
    }];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[_textPreview endEditing:YES];
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
    
    [[self view] endEditing:YES];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
    
}

- (IBAction)audioBkbtn:(id)sender {
    
    [self getSaveBtn];
    
    //hide icon views
    _defaultView.hidden=NO;
    _defaultTableView.hidden=NO;
    _textIconView.hidden=YES;
    _scribbleIconView.hidden=YES;
    self.mainImage.hidden=YES;
    self.tempDrawImage.hidden=YES;
    //_audioIconView.hidden=YES;
    _textViewOption.hidden=YES;
    
    //hide content views
    _scribleView.hidden=YES;
    
}

- (IBAction)audioStrtBtn:(id)sender {
      _isText=NO;
}

- (IBAction)audioOptionsBtn:(id)sender {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_arrNotes.count>0) {
        
        return _arrNotes.count+1;
    }
    
    else return 0;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return [[UIView alloc]init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    
    
    if (indexPath.row!=_arrNotes.count)
    {
        NoteListItem *item=[_arrNotes objectAtIndex:indexPath.row];
        
        
        if (item.notetype==IMAGES )
        {
            UITableViewCell *cellImage = [self.tableview dequeueReusableCellWithIdentifier:@"ImageCell"];
            
            
            
            ImageCell *cell=(ImageCell*)cellImage;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (cell == nil) {
                cell = [[ImageCell alloc] init];
            }
            
            
            UIImage *image=item.noteimage;
            cell.addImage.layer.masksToBounds = YES;
            cell.addImage.clipsToBounds=YES;
            
            cell.addImage.contentMode=UIViewContentModeScaleAspectFit;
            cell.addImage.image = image;
            
            
            isFullScreen = FALSE;
            UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
            tapped.delegate = self;
            tapped.numberOfTapsRequired = 1;
            [cell.addImage setUserInteractionEnabled:YES];
            cell.addImage.tag = indexPath.row;
            [cell.addImage addGestureRecognizer:tapped];
            
            [cell.contentView addSubview:cell.addImage];
            
            cell.addImage.userInteractionEnabled = YES;
            
            cell.addImage.backgroundColor=[UIColor clearColor];
            
            return cell;
        }
        
        else if (item.notetype==AUDIO)
        {
            
            UITableViewCell *cellImage = [self.tableview dequeueReusableCellWithIdentifier:@"audioCell"];
            
            
            audioCell *cell=(audioCell*)cellImage;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            if (cell == nil) {
                cell = [[audioCell alloc] init];
            }
            
            
            _audio=item.audioPlayPath;
            cell.noteitemList=item;
            cell.IndexOfCell=indexPath.row;
            cell.delegate=self;
            cell.recordingLbl.text=item.strAudioTotalTime;
            cell.audiocellView.layer.borderWidth = 1.0f;
            cell.audiocellView.layer.borderColor = [[UIColor colorWithRed:(255/255) green:(90/255) blue:(96/255) alpha:1.0] CGColor];
            
            return cell;
            
        }
        
        else if (item.notetype==TEXT)
        {
            
            NoteListItem *items=[_arrNotes objectAtIndex:indexPath.row];
            
            UITableViewCell *celltext = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
            
            /* if (!celltext)
             {
             celltext=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textCell1"];
             
             UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(0.0,0.0, celltext.frame.size.width,celltext.frame.size.height)];
             
             textView.tag=30000;
             
             [celltext.contentView addSubview:textView];
             }
             
             
             
             if ([[celltext.contentView viewWithTag:30000]isKindOfClass:[UITextView class]])
             {
             UITextView *textView=(UITextView*)[celltext.contentView viewWithTag:30000];
             
             textView.autoresizesSubviews=YES;
             textView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
             
             textView.delegate=self;
             textView.tag=indexPath.row;
             textView.text=items.textString;
             textView.font=[UIFont systemFontOfSize:16.0f];
             textView.backgroundColor=[UIColor greenColor];
             
             }*/
            
            
            
            textCell *cell=(textCell*)celltext;
            if (!cell)
            {
                cell=[[textCell alloc]init];
                
            }
            
            cell.clipsToBounds=YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // NoteListItem *items=[_arrNotes objectAtIndex:indexPath.row];
            cell.textLabel.numberOfLines = 0;
            cell.textView.hidden=YES;
            cell.displayLabel.hidden=YES;
            cell.displayLabel.font=[UIFont systemFontOfSize:16.0f];
            cell.textView.font=[UIFont systemFontOfSize:16.0f];
            items.isEdited=YES;
            
            
            
            if (items.isEdited)
            {
                cell.textView.text=items.textString;
                cell.textView.hidden=NO;
                
            }else{
                cell.displayLabel.hidden=YES;
                cell.displayLabel.text=items.textString;
            }
            
            
            
            cell.textView.tag=indexPath.row;
            
            if (items.textString.length<=0)
            {
                cell.textView.text=defaultText;
                //cell.textView.textColor = [UIColor blackColor];
            }
            
            
            cell.textView.delegate=self;
            cell.textView.backgroundColor=[UIColor clearColor];
            cell.contentView.layer.borderColor=[UIColor colorWithWhite:0 alpha:0.4].CGColor;
            cell.textView.layer.borderWidth=0.0f;
            
            [cell.textView setContentOffset:CGPointMake(0, 0) animated:NO];
            
            cell.textView.scrollEnabled=NO;
            
            
      
            
            
            return cell;
            
        }

    }
    else
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tilak"];
        if (!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tilak"];
        }
        
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)didCellTapped:(NoteListItem *)item atIndex:(NSInteger)indexOfCell
{
    
    if (item.notetype==AUDIO)
        
    {
        
        NSLog(@"output for audio tapped items = %@",item.audioPlayPath);
        
        
        // Push audio VC here
        
        AudioFullViewController *VC=[[AudioFullViewController alloc]initWithNibName:@"AudioFullViewController" bundle:nil];
        
        [VC setNoteListItem:item];
        
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }
    
}

- (CGFloat)x: (NSIndexPath*)indexPath {
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.row!=_arrNotes.count)
    {
        
    NoteListItem *item=[_arrNotes objectAtIndex:indexPath.row];
    
    textCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"textCell"];
        
        switch (item.notetype)
        {
            case TEXT:
                
            {
                
                NoteListItem* calculationView = [_arrNotes objectAtIndex:indexPath.row];
                
                float size=[self calculateSize:calculationView.textString withIndexpath:indexPath];
                
                if (size<=44)
                {
                    return 44;
                }
                return size ;
                
                
                
                return 0;

            }
                break;
            case AUDIO:
                
            {
                return 67;
            }
                break;
            case IMAGES:
                
            {
                return 568;
            }
                break;
                
            default:
                break;
        }
    

    }
    
    else return 500;
}

-(float)calculateSize:(NSString*)string withIndexpath:(NSIndexPath*)indexpath
{
    
    NSLog(@" tableView width:%f",_tableview.frame.size.width);
    
    if (_currentEditedIndexPath!=indexpath.row)
    {
         NoteListItem* calculationView = [_arrNotes objectAtIndex:indexpath.row];
        
       // NSLog(@"Going in Normal height");
        
       /* UIFont *font = [UIFont systemFontOfSize:17.0f];
        UIColor *color = [UIColor blackColor];
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                                              color, NSForegroundColorAttributeName,
                                              nil];
        NSAttributedString *strign;
        
        if (string>0)
        {
            strign=[[NSAttributedString alloc]initWithString:string attributes:attributesDictionary];
            
            CGRect paragraphRect =[strign boundingRectWithSize:CGSizeMake(_tableview.frame.size.width, CGFLOAT_MAX)
                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                       context:nil];
            
            if (paragraphRect.size.height>44)
            {
                return paragraphRect.size.height+10;
            }
        
            return 44;*/
        NSLog(@"calculationView:%ld",(long)calculationView.height);
        
        return calculationView.height>0?calculationView.height+20:0.0;
            
        //}
    }
    else if(_currentEditedIndexPath==indexpath.row)
    {
        
       // NSLog(@"Going in Edited height");
        if (_height>44.0)
        {
            return _height + 44.0;
        }
        else
        {
            return 44;
        }
       
        
    }
   
    
    return 0;

}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    if ([textView.text isEqualToString:defaultText])
    {
        textView.text=@"";
    }
    
    _isText=YES;
    [self textNavBar];
    
    NSInteger currentEditTag=textView.tag;
    _currentEditedIndexPath=currentEditTag;
    
    
    
    _editedTextString=textView.text;
    
    NSLog(@"Current index:%li  text typed:%@",(long)currentEditTag,_editedTextString);

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //[self tableViewScrollToBottomAnimated:NO];
        //changes made now
        [self scrollToCursorForTextView:textView];
        
        for ( NSIndexPath *ip in [self.tableview indexPathsForVisibleRows] ){
            UITableViewCell * cell = [self.tableview cellForRowAtIndexPath:ip];
            if  ( [cell isKindOfClass:[textCell class]]){
                
                if ( [textView isEqual:((textCell *)cell).textView] ){
                    [self.tableview selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionTop];
                    //[self setContinueButtonEnabled:YES];
                }
            }
        }
        
    });
    
      [self scrollToCursorForTextView:textView];
    
    [textView scrollRangeToVisible:textView.selectedRange];
    
    
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    
    NSInteger currentEditTag=textView.tag;
    
    _editedTextString=textView.text;
    //_isText=YES;
    
    NSLog(@"Current index:%li  text typed:%@",(long)currentEditTag,_editedTextString);
    
}

- (BOOL)rectVisible: (CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.tableview.contentOffset;
    visibleRect.origin.y += self.tableview.contentInset.top;
    visibleRect.size = self.tableview.bounds.size;
    visibleRect.size.height -= self.tableview.contentInset.top + self.tableview.contentInset.bottom;
    
    return CGRectContainsRect(visibleRect, rect);
}

- (void)scrollToCursorForTextView: (UITextView*)textView {
    
    CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
    
    cursorRect = [self.tableview convertRect:cursorRect fromView:textView];
    
    if (![self rectVisible:cursorRect]) {
        cursorRect.size.height += 40; // To add some space underneath the cursor
        [self.tableview scrollRectToVisible:cursorRect animated:YES];
    }
    
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        
        UIEdgeInsets contentInsets;
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
        } else
        {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
        }
        
        _tableview.contentInset = contentInsets;
        _tableview.scrollIndicatorInsets = contentInsets;
     
   
    }];
    

    
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    
    
    
    
    
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        
        self.tableview.contentInset = UIEdgeInsetsZero;
        self.tableview.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

-(void)geTappedimage:(NSString*)url  indexpath:(NSIndexPath*)indexpath{
    
    
    CGRect  rect=[[UIScreen mainScreen]bounds];
    
    UIImage *image;
    
    NoteListItem *listItem=nil;
    
    listItem=[_arrNotes objectAtIndex:pathIndex.row];
    image=listItem.noteimage;
    
    NSLog(@"image  %@",image);
    
    
    UIView *bgView=[[UIView alloc]initWithFrame:rect];
    bgView.tag=3000;
    bgView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    bgView.clipsToBounds=YES;
    
    
    BigimgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0, bgView.frame.size.width, bgView.frame.size.height)];
    BigimgView.image =image;
    BigimgView.contentMode=UIViewContentModeScaleAspectFit;
    
    [bgView addSubview:BigimgView];
    [self.view addSubview:bgView];
    [self addInvisibleButtons];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}

- (void)imageTapped:(UITapGestureRecognizer *)gesture{
    
    CGRect  rect=[[UIScreen mainScreen]bounds];
    
    
    CGPoint point=[gesture locationInView:self.tableview];
    
    pathIndex=[self.tableview indexPathForRowAtPoint:point];
    
    NSInteger tag=0;
    
    id view=gesture.view;
    
    if (![view isKindOfClass:[UIImageView class]])
    {
        return;
    }
    else
    {
        UIImageView *imageview=(UIImageView*)view;
        tag=imageview.tag;
    }
    
    viewBg=[[UIView alloc]initWithFrame:rect];
    viewBg.tag=3000;
    viewBg.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    viewBg.clipsToBounds=YES;
    
    
    UIView *viewBgWhite=[[UIView alloc]initWithFrame:rect];
    viewBgWhite.tag=3000;
    viewBgWhite.backgroundColor=[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0];
    viewBgWhite.clipsToBounds=YES;
    
    
    BigimgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0, viewBg.frame.size.width, viewBg.frame.size.height)];
    
    NSLog(@"arr notes = %@",_arrNotes);
    
    NoteListItem *items=[_arrNotes objectAtIndex:pathIndex.row];
    
    [BigimgView setImage:items.noteimage];//new add
    
    
    BigimgView.contentMode=UIViewContentModeScaleAspectFit;
    
    [viewBg addSubview:viewBgWhite];
    [viewBgWhite addSubview:BigimgView];
    [self.view addSubview:viewBgWhite];
    [self addInvisibleButtons];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}

-(void)addInvisibleButtons{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    BigimgView.userInteractionEnabled = YES;
    [button addTarget:self action:@selector(buttonHandler) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0.0, viewBg.frame.size.width, viewBg.frame.size.height);
    [BigimgView addSubview:button];
}

-(void)buttonHandler{
    
    if ([[self.view viewWithTag:3000] isKindOfClass:[UIView class]])
    {
        UIView *view=(UIView*)[self.view viewWithTag:3000];
        [view removeFromSuperview];
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
    
}




 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
 
     
     
     
     if (indexPath.row!=_arrNotes.count)
     {
         _audioIndexPath=indexPath.row;
         NoteListItem *items=[_arrNotes objectAtIndex:indexPath.row];
         
         
         
         if (items.notetype==AUDIO)
             
         {
             
             NSLog(@"output for audio tapped items = %@",items.audioPlayPath);
             
             
             // Push audio VC here
             
             AudioFullViewController *VC=[[AudioFullViewController alloc]initWithNibName:@"AudioFullViewController" bundle:nil];
             
             [VC setNoteListItem:items];
             
             [self.navigationController pushViewController:VC animated:YES];
             
             
         }
         
         else if (items.notetype==IMAGES)
             
         {
             
             [self geTappedimage:nil indexpath:indexPath];
             
             NSLog(@"output for image tapped items = %@",items);
             
         }
         
         else if (items.notetype==TEXT)
             
         {
             
             // NSLog(@"output for image tapped items = %@",items);
             // 
             // _currentEditedIndexPath=indexPath.row;
             // 
             // [self textNavBar];
             // 
             // items.isEdited=YES;
             // 
             // _isText=YES;
             // 
             //[_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_currentEditedIndexPath inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
             
             
             
         }
     }

 }
 

/*
-(void)visibleAudioView{
    
    [recordPauseButton setImage:isPause forState:UIControlStateNormal];
    _audioView.hidden=NO;
    _audioView.layer.borderWidth = 1.0f;
    _audioView.layer.borderColor = [[UIColor colorWithRed:(255/255) green:(90/255) blue:(96/255) alpha:1.0] CGColor];
    
    _currentTimeSlider.hidden=YES;
    
    //recording settings
    recordPauseButton.hidden=NO;
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    playButton.hidden=YES;
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],[self getRecordingFileName],
                               nil];
    
    
    _outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    
    
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    _recorder = [[AVAudioRecorder alloc] initWithURL:_outputFileURL settings:recordSetting error:nil];
    
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    
}
*/

-(NSString*)getRecordingFileName{
    
    NSDate *now = [NSDate date];  //  gets current date
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyy_HH_mm_ss"];
    NSString *str=[formatter stringFromDate:now];
    
    NSLog(@"file name:%@",str);
    str=[NSString stringWithFormat:@"recording_%@.m4a",str];
    
    return str;
    
    
}


/*
-(void)PLAYWITHURL:(NSURL*)URL{
    
    //Start playback
    NSError *err;
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&err];
    _player.delegate = self;
    
    if (!_player)
    {
        NSLog(@"Error establishing player for %@  %@", URL,err.description);
        return;
    }
    
    
    
    // Change audio session for playback
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil])
    {
        
        return;
    }
    
    
    NSLog(@"%@ ",URL);
    
    [_player prepareToPlay];
    [_player play];
    
    
}
*/
#pragma audioRecording

- (IBAction)recordPauseTapped:(id)sender {
    // Stop the audio player before recording
    _currentTimeSlider.hidden=YES;
    
    if (_player.playing) {
        [_player pause];
    }
    
    
    
    if (!_recorder.recording) {
        
        _isRecording=YES;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [_recorder record];
        [recordPauseButton setImage:isNotPaused forState:UIControlStateNormal];
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRecordingTime) userInfo:nil repeats:YES];
        [_myTimer fire];
        
        _recordingLbl.text = @"Recording Started...";
        
    }
    
    
    
    else  {
        
        _isRecording=NO;
        // Pause recording
        [_recorder pause];
        [recordPauseButton setImage:isPause forState:UIControlStateNormal];
        _recordingLbl.text = @"Recording Paused...";
        
    }
    
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
    playButton.hidden=YES;
    recordPauseButton.hidden=NO;
}

- (void)updateRecordingTime {
    
    float minutes = floor(_recorder.currentTime/60);
    float seconds = _recorder.currentTime - (minutes * 60);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%0.0f.%0.0f",
                      minutes, seconds];
    
    _recordTimeDisplay.text = time;
    _totalTime=time;
    
    
}

- (void)updateSlider {
    
    float minutes = floor(_player.currentTime/60);
    float seconds = _player.currentTime - (minutes * 60);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%0.0f.%0.0f",
                      minutes, seconds];
    
    
    //_currentCell.recordingLbl.text = [NSString stringWithFormat:@"%@/%@",time,_currentCell.noteitemList.strAudioTotalTime];
    
    _currentCell.recordingLbl.text = [NSString stringWithFormat:@"%@/%@",time,_currentCell.noteitemList.strAudioTotalTime];
    _currentCell.currentTimeSlider.value=_player.currentTime;
    
}

- (IBAction)stopTapped:(id)sender {
    
    [_recorder stop];
    _audioView.hidden=YES;
    _currentTimeSlider.hidden=NO;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    
    NoteListItem *items=[[NoteListItem alloc]init];
    items.notetype=AUDIO;
    items.audioPlayPath=_outputFileURL;
    items.strAudioPlayPath=[NSString stringWithFormat:@"%@",_outputFileURL];
    
    
    
    
    items.strAudioTotalTime=_totalTime;
    
    
    [_arrNotes addObject:items];
    [self upadteNote:_arrNotes];
    [_tableview reloadData];
    
}

- (IBAction)playTapped:(id)sender {
    

//    if (!_recorder.recording){
//        
//        
//        if (_isPlayingPaused) {
//            
//            [_player pause];
//        }
//        else
//        {
//            
//            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:nil];
//            [_player setDelegate:self];
//            
//            
//            _currentTimeSlider.hidden=NO;
//            
//            
//            
//            [_player play];
//            
//            
//            _currentTimeSlider.maximumValue=_player.duration;
//            
//            
//            _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
//            [_myTimer fire];
//        }
//        
//    }
    
    
}

- (IBAction)pauseTapped:(id)sender {
    
//    _isPlayingPaused=!_isPlayingPaused;
//    
//    if (_isPlayingPaused) {
//        [_player pause];
//        _isPlayingPaused=0;
//    }
//    
//    else{
//        [_player play];
//        _isPlayingPaused=1;
//    }
    
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    
    [recordPauseButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
    playButton.hidden=NO;
    recordPauseButton.hidden=YES;
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [_player stop];
    [_myTimer invalidate];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getSaveBtn];
    _defaultView.hidden=NO;
    _defaultTableView.hidden=NO;
    
    
    [_tableview reloadData];
    
    
    NSLog(@"%f-%f",_tableview.contentSize.height ,_tableview.frame.size.height);

    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self tableViewScrollToBottomAnimated:NO];
    });
    
}
- (void)tableViewScrollToBottomAnimated:(BOOL)animated {
    NSInteger numberOfRows = [_tableview numberOfRowsInSection:0];
    if (numberOfRows)
    {
        [_tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_arrNotes.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}
- (void)tableViewScrollToTopAnimated:(BOOL)animated {
    NSInteger numberOfRows = [_tableview numberOfRowsInSection:0];
    if (numberOfRows)
    {
        [_tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_arrNotes.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)moveFrameToVerticalPosition:(float)position forDuration:(float)duration {
    CGRect frame = self.view.frame;
    frame.origin.y = position;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = frame;
    }];
}

-(void)dismissSizeTable:(selectFontSize)selectedOption{
    
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)dismissFontTable:(selectFontSize)selectedOption{
    
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)fonts:(id)sender{
    
    _strFontValue=((FontPopupViewController*)sender).strFont;
    
}

-(void)sizes:(id)sender{
    
    _strSizeValue=((FontPopupViewController*)sender).strSize;
    _sizeValue=[_strSizeValue intValue];
    NSLog(@"output is %@",_strSizeValue);
    
}

/*
-(void)didPlaycontrolTapped:(NoteListItem*)item isPlay:(BOOL)isPlay isPaused:(BOOL)isPaused inView:(audioCell *)cell atIndex:(NSInteger)indexOfCell
{
    
    if (isPlay)
    {
        _currentCell=[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexOfCell inSection:0]];
        
        [self PLAYWITHURL:item.audioPlayPath];
        cell.currentTimeSlider.maximumValue=_player.duration;
        
        
        
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
        [_myTimer fire];
        
        
    }
    else if(!isPlay) {
        
        _isPlayingPaused=0;
        [_player pause];
        
    }
}
*/

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}
#pragma mark- Reminder

-(void)showAndHidePickerView:(BOOL)visibile
{
    
    if (visibile)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            
            
            _viewPickerContainer.frame=CGRectMake(self.view.frame.origin.x+5, 108,self.view.frame.size.width-10,200);
            [_viewPickerContainer setCenter:CGPointMake(self.view.frame.size.width/2.0f,self.view.frame.size.height/2.0f)];
        }];
    }
    else
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            _viewPickerContainer.frame=CGRectMake(self.view.frame.origin.x+5, self.view.frame.size.height,self.view.frame.size.width-10,200);
        }];
    }
}


-(IBAction)btnPickerSelcted:(id)sender
{
    //[self showAndHidePickerView:NO];
}
-(IBAction)btnCancelClick:(id)sender
{
    [self showAndHidePickerView:NO];
}


-(IBAction)btnDoneClick:(id)sender
{
    
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    
    NSString *dateString = [formatter stringFromDate:_datePicker.date];
    NSLog(@"Selected Date:%@",dateString);
    
    [self AddToGoogleCaledar:_datePicker.date];
    
    
    
    /*EKReminder *reminder = [EKReminder reminderWithEventStore:store];
    [reminder setTitle:_updatedItems.note_Title];
    reminder setDueDateComponents:<#(NSDateComponents * _Nullable)#>
    EKCalendar *defaultReminderList = [store defaultCalendarForNewReminders];
    
    [reminder setCalendar:defaultReminderList];
    
    NSError *error = nil;
    BOOL success = [store saveReminder:reminder
                                commit:YES
                                 error:&error];
    if (!success) {
        NSLog(@"Error saving reminder: %@", [error localizedDescription]);
    }
    */
    
    
    
  //  _noteItems1=[[DBNoteItems alloc]init];
    
    
    
    
    _updatedItems.note_Reminder=dateString;
    
    if (_updatedItems)
    {
        
        [_dbManager UpdateNoteReminder:[_dbManager getDbFilePath] withNoteItem:_updatedItems];
        
        [[[UIAlertView alloc]initWithTitle:@"Reminder" message:@"Reminder has been set." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
    }
    
    
    else
    
    {
        [[[UIAlertView alloc]initWithTitle:@"Reminder" message:@"Reminder has not been set." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
    
    [self showAndHidePickerView:NO];
    
}

-(void) AddToGoogleCaledar:(NSDate*)match
{
    NSLog(@"Added to Google Calendar Button");
    
  
    
    EKEventStore *store = [EKEventStore new];
    
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //[[[UIAlertView alloc] initWithTitle:@"" message:LocalizedString(@"text_calendarnot_access_msg") delegate:self cancelButtonTitle:LocalizedString(@"text_ok") otherButtonTitles: nil] show];
            });
            
            
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            EKEvent *event1 = [EKEvent eventWithEventStore:store];
            event1.title = _updatedItems.note_Title.length>0?[NSString stringWithFormat:@"NoteShare: %@", _updatedItems.note_Title]:@"";
            
            event1.startDate = match;;
            event1.endDate = match;
            event1.calendar = [store defaultCalendarForNewEvents];
            // NSError *err = nil;
            _isFound=NO;
            
            
            
            NSPredicate *predicate = [store predicateForEventsWithStartDate:event1.startDate endDate:event1.endDate calendars:[NSArray arrayWithObject:event1.calendar]];
            
            [store enumerateEventsMatchingPredicate:predicate
                                         usingBlock:^(EKEvent *event, BOOL *stop)
             {
                 if (event.startDate==event1.startDate&&event.endDate==event1.endDate)
                 {
                     //already saved
                     
                     NSLog(@"Event Id:%@",event.eventIdentifier);
                     NSLog(@"Event startDate:%@",event.startDate);
                     NSLog(@"Event endDate:%@",event.endDate);
                     
                     _isFound=YES;
                 }
                 else{
                     //not saved
                     
                 }
             }];
            
            if (!_isFound)
            {
                [store saveEvent:event1 span:EKSpanThisEvent commit:YES error:nil];
               // [[[UIAlertView alloc] initWithTitle:LocalizedString(@"text_eventsave") message:@"" delegate:self cancelButtonTitle:LocalizedString(@"text_ok") otherButtonTitles: nil] show];
                
                EKReminder *reminder = [EKReminder reminderWithEventStore:store];
                [reminder setTitle:_updatedItems.note_Title];
             
                EKCalendar *defaultReminderList = [store defaultCalendarForNewReminders];
                
                [reminder setCalendar:defaultReminderList];
                
                NSError *error = nil;
                BOOL success = [store saveReminder:reminder
                                            commit:YES
                                             error:&error];
                if (!success) {
                    NSLog(@"Error saving reminder: %@", [error localizedDescription]);
                }
                
                
            }else
            {
               // [[[UIAlertView alloc] initWithTitle:LocalizedString(@"text_eventerror") message:@"" delegate:self cancelButtonTitle:LocalizedString(@"text_ok") otherButtonTitles: nil] show];
            }
        });
    }];
    
}



- (IBAction)noteTitleBtn:(id)sender {
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Note title" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Cancel",nil];
    alert.delegate=self;
    alert.tag=2000;
    
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"";
    alertTextField.text=_dbnotelistItem.note_Title;
    
    [alert show];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    _editedTextString=textView.text;
   
    [_tableview beginUpdates];
   // _height = textView.contentSize.height;
     [self textViewFitToContent:textView];
    [_tableview endUpdates];
    
    
}

- (void)textViewFitToContent:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    textView.scrollEnabled = NO;
    _height=newFrame.size.height;
}



@end
