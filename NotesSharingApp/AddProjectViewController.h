//
//  AddProjectViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 24/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
//#import "SlidePopUpView.h"
#import "customAlertBoxViewController.h"

#define defaultText @""//Start typing here.......

//#import "OptionsSlidePopUpView.h"
#import "DBManager.h"


//typedef enum : NSUInteger {
//    AUDIO,
//    IMAGES,
//    TEXT,
//} NOTETYPE;
//
//
//
//@interface NoteListItem:NSObject
//{
//    
//    
//}
//
//@property(nonatomic,strong) UIImage *noteimage;
//@property(nonatomic,assign)NOTETYPE notetype;
//@property(nonatomic,strong)NSURL *audioPlayPath;
//@property(nonatomic,strong)NSString *imagePath;
//@property(nonatomic,strong)NSString *noteElementID;
//@property(nonatomic,strong)NSString *strAudioPlayPath;
//@property(nonatomic,strong)NSString *strAudioTotalTime;
//@property(nonatomic,strong)NSString *textString;
//@property(nonatomic,assign)BOOL isEdited;
//@property(nonatomic,assign)NSInteger positionIn;
//@property(nonatomic,strong)NSString *reminderTime;
//
//@end

@interface AddProjectViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    
    
        
        BOOL isFullScreen;
        CGRect prevFrame;
        UIGestureRecognizer *tap;
    
    
}

//@property (strong, nonatomic)  OptionsSlidePopUpView *optionsSlidePopupView;
@property (strong, nonatomic)  DBNoteItems *dbnotelistItem;

//buttons
- (IBAction)cameraButton:(id)sender;
- (IBAction)scribbleNotesButton:(id)sender;
- (IBAction)audioNotesButton:(id)sender;
- (IBAction)textButton:(id)sender;
- (IBAction)shareButton:(id)sender;
- (IBAction)moreButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *textButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIButton *scribbleNotesButton;
@property (strong, nonatomic) IBOutlet UIButton *audioNotesButton;

@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;



//mediaplayer
@property (weak,nonatomic) UIActionSheet *sheet;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;


//views
@property (strong, nonatomic) IBOutlet UIView *defaultView;
@property (strong, nonatomic) IBOutlet UIView *textIconView;
@property (strong, nonatomic) IBOutlet UIView *scribbleIconView;
//@property (strong, nonatomic) IBOutlet UIView *audioIconView;


//contentViews
@property (strong, nonatomic) IBOutlet UIView *scribleView;
@property (strong, nonatomic) IBOutlet UIView *defaultTableView;


//textbuttons
@property (strong, nonatomic) IBOutlet UIButton *back;
@property (strong, nonatomic) IBOutlet UIButton *text1;
@property (strong, nonatomic) IBOutlet UIButton *text2;
@property (strong, nonatomic) IBOutlet UIButton *boldBtn;

@property (strong, nonatomic) IBOutlet UIButton *italicBtn;

@property (strong, nonatomic) IBOutlet UIButton *underlineBtn;

@property (strong, nonatomic) IBOutlet UIButton *optionsTxtBtn;


- (IBAction)back:(id)sender;
- (IBAction)text1:(id)sender;
- (IBAction)text2:(id)sender;
- (IBAction)boldBtn:(id)sender;
- (IBAction)italicBtn:(id)sender;
- (IBAction)underlineBtn:(id)sender;
- (IBAction)optionsTxtBtn:(id)sender;




//scribble outlets

//scribblebuttons
@property (strong, nonatomic) IBOutlet UIButton *scribleBckBtn;
- (IBAction)scribleBckBtn:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *sqBrushbtn;
- (IBAction)sqBrushbtn:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *scribleBrushBtn;
- (IBAction)scribleBrushBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *undoBtn;

- (IBAction)undoBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *highlighterBtn;
- (IBAction)highlighterBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *eraserBtn;
- (IBAction)eraserBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *scribleOptionsBtn;
- (IBAction)scribleOptionsBtn:(id)sender;

//scribleimg outlets
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;


//audio outlets

//audio buttons
@property (strong, nonatomic) IBOutlet UIButton *audioBkbtn;
- (IBAction)audioBkbtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *audioStrtBtn;
- (IBAction)audioStrtBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *audioOptionsBtn;
- (IBAction)audioOptionsBtn:(id)sender;


//adding image to table view

@property(nonatomic, strong) UIImage *photoImage;
@property(nonatomic, strong) IBOutlet UITableView *tableview;


@property(strong,nonatomic)NSMutableDictionary *textViews;



//recording buttons

@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;
- (IBAction)playTapped:(id)sender;
- (IBAction)pauseTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (strong, nonatomic) IBOutlet UIView *audioView;

@property (strong, nonatomic) IBOutlet UIView *textViewOption;
@property (strong, nonatomic) IBOutlet UILabel *recordTimeDisplay;



//text options

@property (strong, nonatomic) IBOutlet UITextView *textField;



//buttons
@property (strong, nonatomic) IBOutlet UILabel *recordingLbl;



//long gestur property outlet
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *handleLongPress;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapdismiss;

//title bar note name

@property (strong, nonatomic) IBOutlet UINavigationItem *noteTitle;

@property (strong, nonatomic) IBOutlet UIButton *noteTitleBtn;
- (IBAction)noteTitleBtn:(id)sender;



@end
