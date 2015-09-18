//
//  pushElementNotesViewController.m
//  NoteShare
//
//  Created by Heba khan on 16/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "pushElementNotesViewController.h"
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

#define isPause [UIImage imageNamed:@"recording_status.png"]//isRecording=yes
#define isNotPaused [UIImage imageNamed:@"pause_audio.png"]//isRecording=no


@interface pushElementNotesViewController ()<PopUpViewDelegate,OptionsSlidePopUpViewDelegate,audioCellDelegate>
@property (nonatomic,strong)NSMutableArray *photoArr;
@property(nonatomic,strong)UIActionSheet *actionSheet1;
@property(nonatomic,strong)UIActionSheet *actionSheet2;
@property(nonatomic,assign)NSInteger temp;
@property(nonatomic,strong)OptionsSlidePopUpView *optionsPopup;

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


-(void)addOrRemoveFontTraitWithName:(NSString *)traitName andValue:(uint32_t)traitValue;
-(void)setParagraphAlignment:(NSTextAlignment)newAlignment;
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


@property(nonatomic,strong)UIImageView *BigimgView;
@property(nonatomic,assign)NSInteger action;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UIView *viewBg;

@end

@implementation pushElementNotesViewController

@synthesize stopButton, playButton, recordPauseButton,BigimgView,action,indexPath,viewBg;




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //    self.textField.delegate=self;
    
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
    
    _optionsPopup=[[OptionsSlidePopUpView alloc]initWithFrame:CGRectMake(0.0,self.view.frame.size.height,self.view.frame.size.width, 300)];
    _optionsPopup.delegate=self;
    
    [self.view addSubview:_optionsPopup];
    
    
    [self getRecordingFileName ];
    
    _dictAllnoteElement=[[NSMutableDictionary alloc]init];
    
    
    [self updateInitiDictFormDb];
    
    
}


-(void)updateInitiDictFormDb{
    
    
    
    NSLog(@"%@ array notes",_arrNotes);
    
    
    [_arrNotes removeAllObjects ];
    
    NSArray *arrItems=[_dbManager getRecordsWithNote_Id:[_dbManager getDbFilePath] where:_dbnotelistItem.note_Id];
    
    _updatedItems=[arrItems si_objectOrNilAtIndex:0];
    
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
    
    
    if ( _updatedItems.note_Element.length>0)
    {
        
        NSData *data=[_updatedItems.note_Element dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        _dictAllnoteElement=[NSMutableDictionary  dictionaryWithDictionary:dict];
        
        NSArray *arrItems=[_dictAllnoteElement valueForKey:@"note_element"];
        
        for (NSDictionary* dictItem in arrItems)
        {
            
            NoteListItem *items=[[NoteListItem alloc]init];
            
            
            NSString *strnoteTyp=[dictItem valueForKey:@"note_type"];
            
            if ([strnoteTyp isEqualToString:@"IMAGE"])//look in return reponse
            {
                
                NSString *strpath=[dictItem valueForKey:@"note_content"];
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library assetForURL:[NSURL URLWithString:strpath] resultBlock:^(ALAsset *asset)
                 {
                     UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:1.0 orientation:UIImageOrientationUp];
                     
                     items.noteElementID=[dictItem valueForKey:@"note_postion"];
                     items.notetype=IMAGES;
                     items.noteimage=copyOfOriginalImage;
                     
                     [_arrNotes addObject:items];
                     
                     [self getSortedData];
                     
                     [_tableview reloadData];
                     
                 }
                        failureBlock:^(NSError *error)
                 {
                     // error handling
                     NSLog(@"failure-----");
                 }];
            }
            
            
            
            else   if ([strnoteTyp isEqualToString:@"AUDIO"])//audio
            {
                
                
                NSString *strpath=[dictItem valueForKey:@"note_content"];
                
                NSString* theFileName = [strpath lastPathComponent];
                
                items.notetype=AUDIO;
                items.strAudioPlayPath=strpath;
                items.noteElementID=[dictItem valueForKey:@"note_postion"];
                items.strAudioTotalTime=[dictItem valueForKey:@"media_total_time"];
                items.audioPlayPath=[self getAudioUrlFormFileName:theFileName];
                [_arrNotes addObject:items];
                [self getSortedData];
                [_tableview reloadData];
                
                
            }
            
            else  if ([strnoteTyp isEqualToString:@"TEXT"])//text
                
            {
                items.noteElementID=[dictItem valueForKey:@"note_postion"];
                
                items.notetype=TEXT;
                // NSAttributedString *strtext=[dictItem valueForKey:@"note_content"];
                items.textString=[dictItem valueForKey:@"note_content"];
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
    // NSError *err;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
    
    return url;
    
}

-(void)hideSheet{
    
    [UIView animateWithDuration:0.2 animations:^{
        _optionsPopup.frame=CGRectMake(0.0,self.view.frame.size.height,self.view.frame.size.width,300);
        _optionsPopup.backgroundColor=[UIColor clearColor];
        [_optionsPopup layoutSubviews];
    }];
}

-(void)showSheeet{
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        _optionsPopup.frame=CGRectMake(0.0,self.self.view.frame.size.height-300,self.view.frame.size.width, 300);
        _optionsPopup.backgroundColor=[UIColor clearColor];
        [_optionsPopup layoutSubviews];
    }];
    
    
}

-(void)didItemClick:(optionsButtonSelect)dismiss{
    
    [self hideSheet];
    
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
    
    
    UIButton *BtnColor=[[UIButton alloc]initWithFrame:CGRectMake(32.0, 5.0, 30, 30)];
    [BtnColor setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"color_sort_view.png"]]  forState:UIControlStateNormal];
    [BtnColor addTarget:self action:@selector(TextButtonNavBar:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:BtnColor];
    
    
    UIButton *Btn2=[[UIButton alloc]initWithFrame:CGRectMake(68.0, 5.0, 28, 28)];
    [Btn2 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"save.png"]]  forState:UIControlStateNormal];
    [Btn2 addTarget:self action:@selector(TextbackBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:Btn2];
    
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:viewLeftnavBar];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    
    
}

-(IBAction)TextButtonNavBar:(id)sender{
    
    FontPopupViewController *samplePopupViewController = [[FontPopupViewController alloc] initWithNibName:@"FontPopupViewController" bundle:nil];
    samplePopupViewController.delegate=self;
    
    [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
        NSLog(@"popup view presented");
    }];
    
    
}

-(IBAction)TextbackBtnPress:(id)sender{
    
    
    //
    if (_isText)
    {
        NoteListItem *currentItem=[_arrNotes si_objectOrNilAtIndex:_currentEditedIndexPath];
        if (currentItem&&_editedTextString.length>0)
        {
            currentItem.textString=_editedTextString;
            currentItem.isEdited=NO;
            
            
            [self upadteNote:_arrNotes];
        }
        [_tableview reloadData];
    }
    
    [self.view endEditing:YES];
    
    
    
    
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
    
    if ([_dictAllnoteElement valueForKey:@"note_element"]==nil)
    {
        [_dictAllnoteElement setObject:[[NSMutableArray alloc]init] forKey:@"note_element"];
    }
    
    
    NSMutableArray *arrData= [_dictAllnoteElement valueForKey:@"note_element"];
    
    int i=(int)arrNotes.count;
    NoteListItem *item = [arrNotes lastObject];
    
    
    
    
    
    //    if (_isText)
    //    {
    //
    //        i=(int)_currentEditedIndexPath;
    //
    //        item=[arrNotes si_objectOrNilAtIndex:i];
    //
    //        [dict setObject:[NSString stringWithFormat:@"%i",i] forKey:@"note_postion"];
    //
    //        _isText=NO;
    //
    //
    //    }
    //    else
    //
    //    {
    
    
    //    }
    
    
    {
        NSMutableDictionary *dict=[NSMutableDictionary new];
        [dict setObject:[NSString stringWithFormat:@"%i",i] forKey:@"note_postion"];
        
        switch (item.notetype)
        {
            case IMAGES:
            {
                [dict setObject:@"IMAGE" forKey:@"note_type"];
                [dict setObject:[NSString stringWithFormat:@"%@",item.imagePath] forKey:@"note_content"];
            }
                break;
            case AUDIO:
            {
                [dict setObject:@"AUDIO" forKey:@"note_type"];
                [dict setObject:[NSString stringWithFormat:@"%@",item.strAudioPlayPath] forKey:@"note_content"];
                [dict setObject:[NSString stringWithFormat:@"%@",item.strAudioTotalTime] forKey:@"media_total_time"];
                
            }
                break;
            case TEXT:
            {
                
                //[dict setObject:[NSString stringWithFormat:@"%i",item.noteElementID.intValue] forKey:@"note_postion"];
                [dict setObject:@"TEXT" forKey:@"note_type"];
                [dict setObject:[NSString stringWithFormat:@"%@",item.textString] forKey:@"note_content"];
                
            }
                break;
                
            default:
                break;
        }
        
        [arrData addObject:dict];
        
    }
    
    /*
     switch (item.notetype)
     {
     case IMAGES:
     {
     [dict setObject:@"IMAGE" forKey:@"note_type"];
     [dict setObject:[NSString stringWithFormat:@"%@",item.imagePath] forKey:@"note_content"];
     [arrData addObject:dict];
     }
     break;
     case AUDIO:
     {
     [dict setObject:@"AUDIO" forKey:@"note_type"];
     [dict setObject:[NSString stringWithFormat:@"%@",item.strAudioPlayPath] forKey:@"note_content"];
     [dict setObject:[NSString stringWithFormat:@"%@",item.strAudioTotalTime] forKey:@"media_total_time"];
     [arrData addObject:dict];
     }
     break;
     case TEXT:
     {
     
     [dict setObject:[NSString stringWithFormat:@"%i",item.noteElementID.intValue] forKey:@"note_postion"];
     [dict setObject:@"TEXT" forKey:@"note_type"];
     [dict setObject:[NSString stringWithFormat:@"%@",item.textString] forKey:@"note_content"];
     [arrData addObject:dict];
     
     }
     break;
     
     default:
     break;
     }
     
     
     
     //    if (arrData.count<=0)
     //    {
     //        if (item.notetype==TEXT)
     //        {
     //            [dict setObject:[NSString stringWithFormat:@"%i",item.noteElementID.intValue] forKey:@"note_postion"];
     //            [dict setObject:@"TEXT" forKey:@"note_type"];
     //            [dict setObject:[NSString stringWithFormat:@"%@",item.textString] forKey:@"note_content"];
     //            [arrData addObject:dict];
     //
     //        }
     //    }
     
     //    for (NSMutableDictionary *dict in arrData)
     //    {
     //         NSString *stringType=[dict valueForKey:@"note_type"];
     //
     //        if ([stringType isEqualToString:@"TEXT"])
     //        {
     //            if ([dict valueForKey:@"note_postion"]!=nil)
     //            {
     //
     //                int position=[[dict valueForKey:@"note_postion"] intValue];
     //
     //
     //
     //
     //                if (position==item.noteElementID.intValue)
     //                {
     //                    [dict setObject:[NSString stringWithFormat:@"%i",item.noteElementID.intValue] forKey:@"note_postion"];
     //                    [dict setObject:@"TEXT" forKey:@"note_type"];
     //                    [dict setObject:[NSString stringWithFormat:@"%@",item.textString] forKey:@"note_content"];
     //
     //                }
     //                else
     //                {
     //                    [dict setObject:[NSString stringWithFormat:@"%i",item.noteElementID.intValue] forKey:@"note_postion"];
     //                    [dict setObject:@"TEXT" forKey:@"note_type"];
     //                    [dict setObject:[NSString stringWithFormat:@"%@",item.textString] forKey:@"note_content"];
     //                    [arrData addObject:dict];
     //
     //                }
     //
     //            }
     //        }
     //
     //    }
     
     */
    
    NSData  *data=[NSJSONSerialization dataWithJSONObject:_dictAllnoteElement options:NSJSONWritingPrettyPrinted error:nil];
    NSString *srtin=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"hello json string is:%@",srtin);
    
    
    
    NSString *modifiedTime=[self date2str:[NSDate date] onlyDate:NO];
    _updatedItems.note_Element=srtin;
    _updatedItems.note_Modified_Time=modifiedTime;
    _updatedItems.note_Color=_bgColor.description;
    
    if ([_updatedItems.note_Color containsString:@".png"]) {
        NSLog(@"string contains .png");
        [_tableview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:_updatedItems.note_Color]]];
    } else {
        _tableview.backgroundColor = [UIColor si_getColorWithHexString:_updatedItems.note_Color];
    }
    
    [self updateinDb:_updatedItems];
    
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
   
    _textViewOption.hidden=YES;
    
}



#pragma hideKeyboard

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    
    NSInteger currentEditTag=textView.tag;
    _currentEditedIndexPath=currentEditTag;
    
    
    _editedTextString=textView.text;
    NSLog(@"_editedTextString:%@",_editedTextString);
    if ([text isEqualToString:@"\n"]) {
        
        //[textView setReturnKeyType:UIReturnKeyDone];
        
        
        return YES;
    }
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textView{
    
    
    
    
    return NO;
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
    
   
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _arrNotes.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
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
        cell.delegate=self;
        cell.audiocellView.layer.borderWidth = 1.0f;
        cell.audiocellView.layer.borderColor = [[UIColor colorWithRed:(255/255) green:(90/255) blue:(96/255) alpha:1.0] CGColor];
        
        return cell;
        
    }
    
    else if (item.notetype==TEXT)
    {
        
        //static NSString *CellIdentifier = @"cell";
        
        UITableViewCell *celltext = [self.tableview dequeueReusableCellWithIdentifier:@"textCell"];
        
        
        
        textCell *cell=(textCell*)celltext;
        if (!cell)
        {
            cell=[[textCell alloc]init];
            //CGSize size=[self calculateSize:item.textString];
            
            //cell.textView.frame=CGRectMake(cell.textView.frame.origin.x, cell.textView.frame.origin.x, size.width, size.height);
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NoteListItem *items=[_arrNotes objectAtIndex:indexPath.row];
        cell.textLabel.numberOfLines = 0;
        cell.textView.hidden=YES;
        cell.displayLabel.hidden=YES;
        cell.displayLabel.font=[UIFont systemFontOfSize:16.0f];
        cell.textView.font=[UIFont systemFontOfSize:16.0f];
        if (items.isEdited)
        {
            cell.textView.text=items.textString;
            cell.textView.hidden=NO;
            
        }else{
            cell.displayLabel.hidden=NO;
            cell.displayLabel.text=items.textString;
        }
        
        
        
        cell.textView.tag=indexPath.row
        ;
        cell.textView.delegate=self;
        cell.textView.backgroundColor=[UIColor clearColor];
        cell.contentView.layer.borderColor=[UIColor colorWithWhite:0 alpha:0.4].CGColor;
        cell.textView.layer.borderWidth=0.5f;
        
        
        return cell;
        
    }
    
    return [[UITableViewCell alloc]init];
}

- (CGFloat)x: (NSIndexPath*)indexPath {
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NoteListItem *item=[_arrNotes objectAtIndex:indexPath.row];
    
    
    if (item.notetype==TEXT)
    {
        
        if (!item.isEdited)
        {
            NoteListItem* calculationView = [_arrNotes objectAtIndex:indexPath.row];
            
            CGSize size=[self calculateSize:calculationView.textString];
            
            if (size.height<20)
            {
                return 44;
            }
            return size.height;
            
        }
        return 200;
        
    }
    
    
    else if (item.notetype==IMAGES)
    {
        return 568;
    }
    
    
    else if (item.notetype==AUDIO)
    {
        return 67;
    }
    
    
    else return 44;
}

-(CGSize)calculateSize:(NSString*)string{
    
    
    CGSize constraint = CGSizeMake(210, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [string boundingRectWithSize:constraint
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]}
                                              context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    
    return boundingBox;
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    // [textView setReturnKeyType:UIReturnKeyDone];
    
    NSInteger currentEditTag=textView.tag;
    _currentEditedIndexPath=currentEditTag;
    
    
    //    if (textView.tag!=0)
    //    {
    //         [self scrollToCursorForTextView:textView];
    //    }
    //
    
    _editedTextString=textView.text;
    
    NSLog(@"Current index:%li  text typed:%@",(long)currentEditTag,_editedTextString);
    
    
    
    //[textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSInteger currentEditTag=textView.tag;
    // [textView setReturnKeyType:UIReturnKeyDone];
    
    ;
    
    _editedTextString=textView.text;
    
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
        cursorRect.size.height += 8; // To add some space underneath the cursor
        [self.tableview scrollRectToVisible:cursorRect animated:YES];
    }
    
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    /* NSDictionary* info = [aNotification userInfo];
     CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
     
     
     //
     UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableview.contentInset.top, 0.0, kbSize.height, 0.0);
     self.tableview.contentInset = contentInsets;
     self.tableview.scrollIndicatorInsets = contentInsets;//saf
     //
     
     float newVerticalPosition = -kbSize.height+65.0;
     
     if (_arrNotes.count>2)
     {
     [self moveFrameToVerticalPosition:newVerticalPosition forDuration:0.3f];
     }*/
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    
    
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        
        UIEdgeInsets contentInsets;
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
        } else {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
        }
        
        _tableview.contentInset = contentInsets;
        _tableview.scrollIndicatorInsets = contentInsets;
        [_tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    
    
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    /*[UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:0.35];
     UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableview.contentInset.top, 0.0,0.0,0.0);
     self.tableview.contentInset = contentInsets;
     self.tableview.scrollIndicatorInsets = contentInsets;
     
     [self moveFrameToVerticalPosition:+64.0f forDuration:0.3f];
     
     
     
     
     [UIView commitAnimations];
     */
    
    
    
    
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
    
    listItem=[_arrNotes objectAtIndex:indexPath.row];
    image=listItem.noteimage;
    
    NSLog(@"image  %@",image);
    
    
    UIView *viewBg=[[UIView alloc]initWithFrame:rect];
    viewBg.tag=3000;
    viewBg.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    viewBg.clipsToBounds=YES;
    
    
    BigimgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0, viewBg.frame.size.width, viewBg.frame.size.height)];
    BigimgView.image =image;
    BigimgView.contentMode=UIViewContentModeScaleAspectFit;
    
    [viewBg addSubview:BigimgView];
    [self.view addSubview:viewBg];
    [self addInvisibleButtons];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}

- (void)imageTapped:(UITapGestureRecognizer *)gesture{
    
    CGRect  rect=[[UIScreen mainScreen]bounds];
    
    
    CGPoint point=[gesture locationInView:self.tableview];
    
    indexPath=[self.tableview indexPathForRowAtPoint:point];
    
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
    
    NoteListItem *items=[_arrNotes objectAtIndex:indexPath.row];
    
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
    
    
    NoteListItem *items=[_arrNotes objectAtIndex:indexPath.row];
    
    
    if (items.notetype==AUDIO)
    {
        
        NSLog(@"output for audio tapped items = %@",items.audioPlayPath);
        
        
    }
    else if (items.notetype==IMAGES)
    {
        
        
        [self geTappedimage:nil indexpath:indexPath];
        NSLog(@"output for image tapped items = %@",items);
        
    }
    else if (items.notetype==TEXT)
    {
        
        
        // [self geTappedimage:nil indexpath:indexPath];
        NSLog(@"output for image tapped items = %@",items);
        //        _currentEditedIndexPath=indexPath.row;
        //        [self textNavBar];
        //        items.isEdited=YES;
        //        _isText=YES;
        //        [_tableview reloadData];
        //
    }
    
    
    
}

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

-(NSString*)getRecordingFileName{
    
    NSDate *now = [NSDate date];  //  gets current date
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyy_HH_mm_ss"];
    NSString *str=[formatter stringFromDate:now];
    
    NSLog(@"file name:%@",str);
    str=[NSString stringWithFormat:@"recording_%@.m4a",str];
    
    return str;
    
    
}

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
    
    if (!_recorder.recording){
        
        
        if (_isPlayingPaused) {
            
            [_player pause];
        }
        else
        {
            
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:nil];
            [_player setDelegate:self];
            
            
            _currentTimeSlider.hidden=NO;
            
            
            
            [_player play];
            
            
            _currentTimeSlider.maximumValue=_player.duration;
            
            
            _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
            [_myTimer fire];
        }
        
    }
    
    
}

- (IBAction)pauseTapped:(id)sender {
    
    
    _isPlayingPaused=!_isPlayingPaused;
    
    if (_isPlayingPaused) {
        [_player pause];
        _isPlayingPaused=0;
    }
    
    else{
        [_player play];
        _isPlayingPaused=1;
    }
    
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





-(void)didPlaycontrolTapped:(NoteListItem*)item isPlay:(BOOL)isPlay isPaused:(BOOL)isPaused inView:(audioCell *)cell{
    
    if (isPlay)
    {
        _currentCell=cell;
        
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

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}



@end
