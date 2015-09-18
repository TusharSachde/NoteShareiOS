//
//  audioCell.m
//  NotesSharingApp
//
//  Created by Heba khan on 23/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "audioCell.h"

@implementation audioCell

bool isPauseButton;

- (void)awakeFromNib {
    // Initialization code
    _playButton.hidden=NO;
    _pauseButton.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)pauseTapped:(id)sender

{
    
    _playButton.hidden=NO;
    _pauseButton.hidden=YES;
    
        if ([_delegate respondsToSelector:@selector(didPlaycontrolTapped:isPlay:isPaused:inView:)])
        {
            [_delegate didPlaycontrolTapped:_noteitemList isPlay:NO isPaused:YES inView:self];
        }
    
}
- (IBAction)playTapped:(id)sender
{
    
    _playButton.hidden=YES;
    _pauseButton.hidden=NO;
    
    if ([_delegate respondsToSelector:@selector(didPlaycontrolTapped:isPlay:isPaused:inView:)])
    {
        [_delegate didPlaycontrolTapped:_noteitemList isPlay:YES isPaused:NO inView:self];
    }
}

@end
