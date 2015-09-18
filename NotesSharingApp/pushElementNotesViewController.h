//
//  pushElementNotesViewController.h
//  NoteShare
//
//  Created by Heba khan on 16/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
//#import "SlidePopUpView.h"
#import "customAlertBoxViewController.h"

#import "OptionsSlidePopUpView.h"
#import "DBManager.h"


typedef enum : NSUInteger {
    AUDIO,
    IMAGES,
    TEXT,
} NOTETYPE;



@interface NoteListItem:NSObject
{
    
    
}

@property(nonatomic,strong) UIImage *noteimage;
@property(nonatomic,assign)NOTETYPE notetype;
@property(nonatomic,strong)NSURL *audioPlayPath;
@property(nonatomic,strong)NSString *imagePath;
@property(nonatomic,strong)NSString *noteElementID;
@property(nonatomic,strong)NSString *strAudioPlayPath;
@property(nonatomic,strong)NSString *strAudioTotalTime;
@property(nonatomic,strong)NSString *textString;
@property(nonatomic,assign)BOOL isEdited;
@property(nonatomic,assign)NSInteger positionIn;
@end




@interface pushElementNotesViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate,UITextViewDelegate,UITextFieldDelegate>

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

@property (strong, nonatomic)  OptionsSlidePopUpView *optionsSlidePopupView;
@property (strong, nonatomic)  DBNoteItems *dbnotelistItem;



//mediaplayer
@property (weak,nonatomic) UIActionSheet *sheet;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;


//views
@property (strong, nonatomic) IBOutlet UIView *defaultView;


//contentViews

@property (strong, nonatomic) IBOutlet UIView *defaultTableView;





//adding image to table view

@property(nonatomic, strong) UIImage *photoImage;
@property(nonatomic, strong) IBOutlet UITableView *tableview;

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


@end
