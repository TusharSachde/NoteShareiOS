//
//  AudioCell_1.h
//  NoteShare
//
//  Created by tilak raj verma on 30/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NoteListItem.h"

@interface AudioCell_1 : UIView<AVAudioPlayerDelegate>

@property (strong, nonatomic)  NoteListItem *noteitemList;
@property (weak, nonatomic)IBOutlet  UIButton *btnPlay;
@property (weak, nonatomic)IBOutlet  UIButton *btnpause;
@property (weak, nonatomic)IBOutlet  UISlider *currentSlider;
@property (weak, nonatomic)IBOutlet  UILabel *lblRemainingTime;

@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong)NSTimer *myTimer;
@property(nonatomic,strong)NSURL *audio;

-(IBAction)btnPlayClick:(id)sender;
-(IBAction)btnPauseClick:(id)sender;

@property(nonatomic,assign)BOOL isPaused;

- (IBAction)sliderChanged:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblFinishedTime;


@end
