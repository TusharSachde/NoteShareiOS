//
//  AddProjectViewController.m
//  NotesSharingApp
//  Created by Heba khan on 24/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.


#import "AddProjectViewController.h"
#import "ImageCell.h"
#import "audioCell.h"

#import "brushAlertViewController.h"
#import "customAlertBoxViewController.h"
#import "UIViewController+CWPopup.h"
#import "FontPopupViewController.h"
#import "colorPaperPopupViewController.h"
#import "UIColor+SIAdditions.h"
#import "SWRevealViewController.h"


#import "SMCThemesSupport.h"


#define isPause [UIImage imageNamed:@"recording_status.png"]//isRecording=yes
#define isNotPaused [UIImage imageNamed:@"pause_audio.png"]//isRecording=no

@implementation NoteListItem



@end

@interface AddProjectViewController ()<PopUpViewDelegate,OptionsSlidePopUpViewDelegate,audioCellDelegate>
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


-(void)addOrRemoveFontTraitWithName:(NSString *)traitName andValue:(uint32_t)traitValue;
-(void)setParagraphAlignment:(NSTextAlignment)newAlignment;
@property(nonatomic,assign) Boolean isBold;
@property(nonatomic,assign) Boolean isItalic;
@property(nonatomic,assign) Boolean isUnderline;
@property(nonatomic,assign) Boolean isRecording;
@property(nonatomic,assign) Boolean isPlayingPaused;


@property(nonatomic)NSInteger selectedIndexPath;

@property(nonatomic,strong)NSString *totalTime;


@end




@implementation AddProjectViewController


float audioDurationSeconds;

@synthesize stopButton, playButton, recordPauseButton;

UIImageView *BigimgView;
NSInteger action;
NSIndexPath *indexPath;
UIView *viewBg;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _attFinalString = [[NSMutableAttributedString alloc] init];
    _arrNotes=[[NSMutableArray alloc]init];
    _currentSelectedFont=SMCFONT(SMCFONT_ArialMTRegular, 22);//By default
    _strFontValue=@"arial";
    _strSizeValue=@"22";
    
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.textField.delegate=self;
    
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
    _audioIconView.hidden=YES;
    _textViewOption.hidden=YES;
    
    
    //hide content views
    
    _scribleView.hidden=YES;
    
    
    _optionsPopup=[[OptionsSlidePopUpView alloc]initWithFrame:CGRectMake(0.0,self.view.frame.size.height,self.view.frame.size.width, 300)];
    _optionsPopup.delegate=self;
    
    [self.view addSubview:_optionsPopup];
    
    _audioView.hidden=YES;
    
    [self getRecordingFileName ];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
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
    [BtnColor setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"save.png"]]  forState:UIControlStateNormal];
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

    NoteListItem *items=[[NoteListItem alloc]init];
    items.notetype=TEXT;
    items.textString=_textPreview.attributedText;
    [_arrNotes addObject:items];
    
    [self performSelector: @selector(back:) withObject:self afterDelay: 0.0];
    [_tableview reloadData];
    
    

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
                //[self.mainImage.image drawInRect:CGRectMake(0, 0, cell.addImage.frame.size.width, cell.addImage.frame.size.height)];
                
                
                UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
                
                
                UIGraphicsEndImageContext();
                
               
                
                NoteListItem *items=[[NoteListItem alloc]init];
                items.notetype=IMAGES;
                items.noteimage=SaveImage;
                
                [_arrNotes addObject:items];
                
                
                
                _defaultView.hidden=NO;
                _defaultTableView.hidden=NO;
                _textIconView.hidden=YES;
                _scribbleIconView.hidden=YES;
                self.mainImage.hidden=YES;
                self.tempDrawImage.hidden=YES;
                _audioIconView.hidden=YES;
                _textViewOption.hidden=YES;
                
                //hide content view
                
                _scribleView.hidden=YES;
                
                [self getSaveBtn];
                
                
                [_tableview reloadData];
                
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
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NoteListItem *items=[[NoteListItem alloc]init];
    items.notetype=IMAGES;
    items.noteimage=self.photoImage;
    [_arrNotes addObject:items];
    
    [self.tableview reloadData];
    
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
    
    [self scribbleNavBar];
    
    _defaultView.hidden=YES;
    _defaultTableView.hidden=YES;
    _textIconView.hidden=YES;
    _scribbleIconView.hidden=NO;
    self.mainImage.hidden=NO;
    self.tempDrawImage.hidden=NO;
    _audioIconView.hidden=YES;
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
    
    [self audioNavBar];
    //hide icon views
    _defaultView.hidden=YES;
    _defaultTableView.hidden=NO;
    _textIconView.hidden=YES;
    _scribbleIconView.hidden=YES;
    self.mainImage.hidden=YES;
    self.tempDrawImage.hidden=YES;
    _audioIconView.hidden=NO;
    _textViewOption.hidden=YES;
    
    //hide content views
    _scribleView.hidden=YES;
    
    _moreButton.backgroundColor=[UIColor clearColor];
    _shareButton.backgroundColor=[UIColor clearColor];
    _audioNotesButton.backgroundColor=[UIColor colorWithRed:(168.0/255) green:(68.0/255) blue:(67.0/255) alpha:(1.0)];
    _cameraButton.backgroundColor=[UIColor clearColor];
    _textButton.backgroundColor=[UIColor clearColor];
    _scribbleNotesButton.backgroundColor=[UIColor clearColor];
}

- (IBAction)textButton:(id)sender {

    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [_textPreview addGestureRecognizer: tapRec];
    
    
    self.textField.layer.borderWidth = 1.0f;
    self.textField.layer.borderColor = [[UIColor colorWithRed:(255/255) green:(90/255) blue:(96/255) alpha:1.0] CGColor];
    
    _textField.text = @"Type Text Here...";
    _textField.textColor = [UIColor lightGrayColor];
    
    
    [self textNavBar];
    _defaultView.hidden=YES;
    _defaultTableView.hidden=YES;
    _textIconView.hidden=NO;
    _scribbleIconView.hidden=YES;
    self.mainImage.hidden=YES;
    self.tempDrawImage.hidden=YES;
    _audioIconView.hidden=YES;
    _textViewOption.hidden=NO;
    //hide content view
    _scribleView.hidden=YES;
    
    _moreButton.backgroundColor=[UIColor clearColor];
    _shareButton.backgroundColor=[UIColor clearColor];
    _audioNotesButton.backgroundColor=[UIColor clearColor];
    _cameraButton.backgroundColor=[UIColor clearColor];
    _textButton.backgroundColor=[UIColor colorWithRed:(168.0/255.0) green:(68.0/255.0) blue:(67.0/255.0) alpha:(1.0)];
    _scribbleNotesButton.backgroundColor=[UIColor clearColor];
    
    _isBold=NO;
    _isItalic=NO;
    _isUnderline=NO;
    
}

-(void)tap:(UITapGestureRecognizer *)tapRec{
    [_textPreview endEditing: YES];
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
    
    [self showSheeet];
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
    _audioIconView.hidden=YES;
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

-(IBAction)previewBtn:(id)sender{
    
#pragma Font-arial
    
    if([_strFontValue.lowercaseString isEqualToString:@"arial"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_ArialBoldMT, _strSizeValue.intValue);
            
        _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
                                        
        }
        
        
        else if (_isItalic)
            {
                _currentSelectedFont=SMCFONT(SMCFONT_ArialItalicMT, _strSizeValue.intValue);
                
                 _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            }
        
        else if (_isUnderline)
        {
           _currentSelectedFont=SMCFONT(SMCFONT_ArialMTRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_ArialMTRegular, _strSizeValue.intValue);
        
        _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }
    
    #pragma Font-times new roman
    
    else if([_strFontValue.lowercaseString isEqualToString:@"times new roman"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_TimesNewRomanPSBoldMT, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_TimesNewRomanPSItalicMT, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        else if (_isUnderline)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_TimesNewRomanPSMTRegular, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_TimesNewRomanPSMTRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }
    
    
#pragma font-helvetica
    
    
    
    else if([_strFontValue.lowercaseString isEqualToString:@"helvetica"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_HelveticaNeueBold, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_HelveticaNeueRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        
        else if (_isUnderline)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_HelveticaNeueItalic, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_HelveticaNeueItalic, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }

    
    
    
#pragma font-Monotype corsiva
    
    else if([_strFontValue.lowercaseString isEqualToString:@"monotype corsiva"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_MonotypeCorsivaRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_MonotypeCorsivaRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        
        else if (_isUnderline)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_MonotypeCorsivaRegular, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_MonotypeCorsivaRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }

    
#pragma font-Edwardian
    
    else if([_strFontValue.lowercaseString isEqualToString:@"edwardian"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_EdwardianScriptITCRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_EdwardianScriptITCRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        
        else if (_isUnderline)
        {
             _currentSelectedFont=SMCFONT(SMCFONT_EdwardianScriptITCRegular, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_EdwardianScriptITCRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }

    
#pragma font-Mongolian baiti
    
    else if([_strFontValue.lowercaseString isEqualToString:@"mongolian baiti"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_MongolianBaitiRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_MongolianBaitiRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        
        else if (_isUnderline)
        {
             _currentSelectedFont=SMCFONT(SMCFONT_MongolianBaitiRegular, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_MongolianBaitiRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }

    
#pragma font-Sakkal majalla
    
    else if([_strFontValue.lowercaseString isEqualToString:@"sakkal majalla"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_SakkalMajallaRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_SakkalMajallaRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        
        else if (_isUnderline)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_SakkalMajallaRegular, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_SakkalMajallaRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }

    
    
#pragma font-DOSIS BOOK
    
    else if([_strFontValue.lowercaseString isEqualToString:@"dosis book"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_DosisBold, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_DosisBold, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        else if (_isUnderline)
        {
            
             _currentSelectedFont=SMCFONT(SMCFONT_DosisBold, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_DosisBold, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }

    
    
#pragma font-DANCING SCRIPT
    
    else if([_strFontValue.lowercaseString isEqualToString:@"dancing script"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_DancingScriptRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_DancingScriptRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        
        else if (_isUnderline)
        {
            
            _currentSelectedFont=SMCFONT(SMCFONT_DancingScriptRegular, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_DancingScriptRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }

    
#pragma font-Eras medium ITC
    
    else if([_strFontValue.lowercaseString isEqualToString:@"Eras medium itc"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_ErasITCMediumRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_ErasITCMediumRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        
        else if (_isUnderline)
        {
            
            _currentSelectedFont=SMCFONT(SMCFONT_ErasITCMediumRegular, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_ErasITCMediumRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }

    
#pragma font-CINZEL DECORATIVE
    
    else if([_strFontValue.lowercaseString isEqualToString:@"cinzel decorative"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_CinzelDecorativeRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_CinzelDecorativeRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        
        else if (_isUnderline)
        {
            
            _currentSelectedFont=SMCFONT(SMCFONT_CinzelDecorativeRegular, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_CinzelDecorativeRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }

    
#pragma font-UNCTION
    
    else if([_strFontValue.lowercaseString isEqualToString:@"unction"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_junctionRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_junctionRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        
        else if (_isUnderline)
        {
            
            _currentSelectedFont=SMCFONT(SMCFONT_junctionRegular, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_junctionRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }

    
    
#pragma font-LINDEN HILL
    
    else if([_strFontValue.lowercaseString isEqualToString:@"linden hill"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_LindenHillRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_LindenHillRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        
        else if (_isUnderline)
        {
            
             _currentSelectedFont=SMCFONT(SMCFONT_LindenHillRegular, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_LindenHillRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }
    
    
    
    
#pragma font-PACIFICO
    
    else if([_strFontValue.lowercaseString isEqualToString:@"pacifico"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_PacificoRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_PacificoRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        else if (_isUnderline)
        {
            
             _currentSelectedFont=SMCFONT(SMCFONT_PacificoRegular, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_PacificoRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }
    
    
    
    
#pragma font-WINDSONG
    
    else if([_strFontValue.lowercaseString isEqualToString:@"windsong"])
    {
        if (_isBold)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_WINDSONGRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
            
        }
        
        
        else if (_isItalic)
        {
            _currentSelectedFont=SMCFONT(SMCFONT_WINDSONGRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
        else if (_isUnderline)
        {
            
            _currentSelectedFont=SMCFONT(SMCFONT_WINDSONGRegular, _strSizeValue.intValue);
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:YES];
        }
        
        
        else
        {
            _currentSelectedFont=SMCFONT(SMCFONT_WINDSONGRegular, _strSizeValue.intValue);
            
            _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
        }
    }
    
    
    
     else
    {
        _textPreview.attributedText=[self setHeaderTitle:@"" subTitle:[_textField text] textfont:_currentSelectedFont textColor:[UIColor blackColor] isUnderLine:NO];
    }
    
   
_textField.text=@"";

}

#pragma hideKeyboard

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        [_textField resignFirstResponder];
        [_textPreview resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

- (IBAction)tapToDismiss:(id)sender {
    [_textField endEditing:YES];
    [_textPreview endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [_textPreview resignFirstResponder];
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
    _audioIconView.hidden=YES;
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
    
}

-(void)backgroundPage:(id)sender{
    
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:((colorPaperPopupViewController*)sender).pageString]];
    [tempImageView setFrame:self.tableview.frame];
    
    self.tableview.backgroundView = tempImageView;
    
    
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
    [_textPreview endEditing:YES];
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
    _audioIconView.hidden=YES;
    _textViewOption.hidden=YES;
    
    //hide content views
    _scribleView.hidden=YES;
    
}

- (IBAction)audioStrtBtn:(id)sender {
    
    [self visibleAudioView];
}

- (IBAction)audioOptionsBtn:(id)sender {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
        return _arrNotes.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NoteListItem *item=[_arrNotes objectAtIndex:indexPath.row];
    
    
    if (item.notetype==IMAGES)
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
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    NoteListItem *items=[_arrNotes objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.attributedText=items.textString;
    
    return cell;
    }
    
    return [[UITableViewCell alloc]init] ;
    
}

- (CGFloat)textViewHeightForRowAtIndexPath: (NSIndexPath*)indexPath {
    
    UITextView *calculationView = [_textViews objectForKey:indexPath];

    CGFloat textViewWidth = calculationView.frame.size.width;
    if (!calculationView.attributedText) {
        // This will be needed on load, when the text view is not inited yet
        
        calculationView = [[UITextView alloc] init];
        
         NoteListItem *items=[_arrNotes objectAtIndex:indexPath.row];
        
        calculationView.attributedText=items.textString;// get the text from your datasource add attributes and insert here
        
        textViewWidth = 290.0; // Insert the width of your UITextViews or include calculations to set it accordingly
        
    }
    
    CGSize size = [calculationView sizeThatFits:CGSizeMake(textViewWidth, FLT_MAX)];
    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NoteListItem *item=[_arrNotes objectAtIndex:indexPath.row];
    
    
    if (item.notetype==TEXT)
    {
        return [self textViewHeightForRowAtIndexPath:indexPath];
    }
    else if (item.notetype==IMAGES)
    {
    return 220;
    }
    else if (item.notetype==AUDIO)
    {
        return 67;
    }
    else return 44;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_arrNotes removeObjectAtIndex:indexPath.row];
    [self.tableview reloadData];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [self.tableview beginUpdates]; // This will cause an animated update of
    [self.tableview endUpdates];   // the height of your UITableViewCell
    
    [self scrollToCursorForTextView:textView]; // OPTIONAL: Follow cursor
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self scrollToCursorForTextView:textView];
    
//    [_scrollTextPreview setScrollEnabled:(YES)];
//    [_scrollTextPreview setContentSize:CGSizeMake(320,650)];
    
    if ([textView.text isEqualToString:@"Type Text Here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Type Text Here...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
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

- (void)keyboardWillShow:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableview.contentInset.top, 0.0, kbSize.height, 0.0);
//    self.tableview.contentInset = contentInsets;
//    self.tableview.scrollIndicatorInsets = contentInsets;saf
    
    float newVerticalPosition = -kbSize.height+65.0;
    
    [self moveFrameToVerticalPosition:newVerticalPosition forDuration:0.3f];
    
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [_textPreview addGestureRecognizer: tapRec];
    
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableview.contentInset.top, 0.0,0.0,0.0);
//    self.tableview.contentInset = contentInsets;
//    self.tableview.scrollIndicatorInsets = contentInsets;
    
    [self moveFrameToVerticalPosition:+64.0f forDuration:0.3f];
    
    
    [UIView commitAnimations];
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
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
    
    if (!_player)
    {
        NSLog(@"Error establishing player for %@", URL);
        return;
    }
    
    _player.delegate = self;
    
    // Change audio session for playback
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil])
    {
       
        return;
    }
    
   
    NSLog(@"%@ ",URL);
    
   // [_player prepareToPlay];
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
        //items.strAudioPlayPath=_strCurrentFilename;
        items.strAudioTotalTime=_totalTime; //
        
        [_arrNotes addObject:items];
    
    NSLog(@"###############  %@",_arrNotes);
    NSLog(@"notelist items ===== %@",items.audioPlayPath);
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

#pragma mark-textStyle

-(NSAttributedString*)setHeaderTitle:(NSString*)mainTitle subTitle:(NSString*)subTitle textfont:(UIFont*)font textColor:(UIColor *)color  isUnderLine:(BOOL)isUnderLine{
    
    
    NSString *str2=subTitle.length>0?subTitle:@"";
    NSRange range2 = NSMakeRange(0, str2.length);
    
    
    NSMutableAttributedString *att2 = [[NSMutableAttributedString alloc] initWithString:str2];
    
    [att2 addAttribute:NSForegroundColorAttributeName value:color range:range2];
    [att2 addAttribute:NSFontAttributeName value:_currentSelectedFont range:range2];
    
    
    
    if (isUnderLine)
    {
        
        [att2 addAttribute:NSUnderlineColorAttributeName
                     value:[UIColor blackColor]
                     range:range2];
        
        [att2 addAttribute:NSUnderlineStyleAttributeName
                     value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                     range:range2];
        
        
    }
    
    
    [_attFinalString appendAttributedString:att2];
    

    return _attFinalString;
    
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
    
    
#pragma Font-arial
    
    if([_strFontValue.lowercaseString isEqualToString:@"arial"])
    {
        _boldBtn.enabled=YES;
        _italicBtn.enabled=YES;
    }
    
#pragma Font-times new roman
    
    else if([_strFontValue.lowercaseString isEqualToString:@"times new roman"])
    {
        _boldBtn.enabled=YES;
        _italicBtn.enabled=YES;
    }
    
    
#pragma font-helvetica
    
    
    
    else if([_strFontValue.lowercaseString isEqualToString:@"helvetica"])
    {
        _boldBtn.enabled=YES;
        _italicBtn.enabled=YES;
    }
    
    
    
    
#pragma font-Monotype corsiva
    
    else if([_strFontValue.lowercaseString isEqualToString:@"monotype corsiva"])
    {
        _boldBtn.enabled=NO;
        _italicBtn.enabled=NO;
    }
    
    
#pragma font-Edwardian
    
    else if([_strFontValue.lowercaseString isEqualToString:@"edwardian"])
    {
        _boldBtn.enabled=NO;
        _italicBtn.enabled=NO;
    }
    
    
#pragma font-Mongolian baiti
    
    else if([_strFontValue.lowercaseString isEqualToString:@"mongolian baiti"])
    {
        _boldBtn.enabled=NO;
        _italicBtn.enabled=NO;
    }
    
    
#pragma font-Sakkal majalla
    
    else if([_strFontValue.lowercaseString isEqualToString:@"sakkal majalla"])
    {
        _italicBtn.enabled=NO;
        _boldBtn.enabled=NO;
        
    }
    
    
    
#pragma font-DOSIS BOOK
    
    else if([_strFontValue.lowercaseString isEqualToString:@"dosis book"])
    {
        
        _boldBtn.enabled=YES;
        
        _italicBtn.enabled=NO;
        
        
    }
    
    
    
#pragma font-DANCING SCRIPT
    
    else if([_strFontValue.lowercaseString isEqualToString:@"dancing script"])
    {
        
        _boldBtn.enabled=NO;
        _italicBtn.enabled=NO;
        
        
        
    }
    
    
#pragma font-Eras medium ITC
    
    else if([_strFontValue.lowercaseString isEqualToString:@"Eras medium itc"])
    {
        
        _boldBtn.enabled=NO;

        _italicBtn.enabled=NO;
        
        
    }
    
    
#pragma font-CINZEL DECORATIVE
    
    else if([_strFontValue.lowercaseString isEqualToString:@"cinzel decorative"])
    {
        
        
        _boldBtn.enabled=NO;

        _italicBtn.enabled=NO;
        
        
    }
    
    
#pragma font-UNCTION
    
    else if([_strFontValue.lowercaseString isEqualToString:@"unction"])
    {
        
        _boldBtn.enabled=NO;
        
        _italicBtn.enabled=NO;
        
        
        
    }
    
    
    
#pragma font-LINDEN HILL
    
    else if([_strFontValue.lowercaseString isEqualToString:@"linden hill"])
    {
        
        _boldBtn.enabled=NO;
        
        _italicBtn.enabled=NO;
        
        
    }
    
    
    
    
#pragma font-PACIFICO
    
    else if([_strFontValue.lowercaseString isEqualToString:@"pacifico"])
    {
        
        _boldBtn.enabled=NO;
        
        _italicBtn.enabled=NO;
        
    }
    
    
    
    
#pragma font-WINDSONG
    
    else if([_strFontValue.lowercaseString isEqualToString:@"windsong"])
        
    {
        
        _boldBtn.enabled=NO;

        _italicBtn.enabled=NO;
        
        
        
    }
    
}

-(void)sizes:(id)sender{
    
    _strSizeValue=((FontPopupViewController*)sender).strSize;
    _sizeValue=[_strSizeValue intValue];
    NSLog(@"output is %@",_strSizeValue);
 
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
    [_textPreview resignFirstResponder];
    return YES;
}

@end
