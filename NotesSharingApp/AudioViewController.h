//
//  AudioViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 24/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



@interface AudioViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>



@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;
- (IBAction)playTapped:(id)sender;




@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;


@end
