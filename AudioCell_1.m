//
//  AudioCell_1.m
//  NoteShare
//
//  Created by tilak raj verma on 30/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "AudioCell_1.h"


@implementation AudioCell_1


-(void)setNoteitemList:(NoteListItem *)noteitemList
{
    _noteitemList=noteitemList;
    _lblRemainingTime.text=noteitemList.strAudioTotalTime;
    _btnPlay.hidden=NO;
    _btnpause.hidden=YES;
    
}

-(IBAction)btnPlayClick:(id)sender
{
    if (_isPaused) {
        
        [_player play];
        _isPaused=NO;
    }
    else
    {
    [self performSelectorOnMainThread:@selector(playAudio) withObject:nil waitUntilDone:NO];
    }
    _btnPlay.hidden=YES;
    _btnpause.hidden=NO;
    
}
-(IBAction)btnPauseClick:(id)sender
{
    
    _btnPlay.hidden=NO;
    _btnpause.hidden=YES;
    [_player pause];
    _isPaused=YES;
}

-(void)playAudio
{
    [_myTimer invalidate];
    [self PLAYWITHURL:_noteitemList.audioPlayPath];
    
    _currentSlider.maximumValue=_player.duration;
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    [_myTimer fire];
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
- (void)updateSlider {
    
    float minutes = floor(_player.currentTime/60);
    float seconds = _player.currentTime - (minutes * 60);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%0.0f.%0.0f",
                      minutes, seconds];
    
    
    
    _lblRemainingTime.text = [NSString stringWithFormat:@"%@",_noteitemList.strAudioTotalTime];
    _lblFinishedTime.text=[NSString stringWithFormat:@"%@",time];
    _currentSlider.value=_player.currentTime;

}



- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{

    [_myTimer invalidate];
    NSLog(@"Audio Playing Finish");
    _btnPlay.hidden=NO;
    _btnpause.hidden=YES;
    _currentSlider.value=0;
}

- (IBAction)sliderChanged:(UISlider *)sender {
    // Fast skip the music when user scroll the UISlider
    [_player stop];
    [_player setCurrentTime:_currentSlider.value];
    [_player prepareToPlay];
    [_player play];
}


@end
