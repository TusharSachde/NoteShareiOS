//
//  audioCell.h
//  NotesSharingApp
//
//  Created by Heba khan on 23/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteListItem;

@class  audioCell;
@protocol audioCellDelegate <NSObject>

-(void)didPlaycontrolTapped:(NoteListItem*)item isPlay:(BOOL)isPlay isPaused:(BOOL)isPaused inView:(audioCell*)cell;

@end

@interface audioCell : UITableViewCell

//recording buttons


@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic)  NoteListItem *noteitemList;
@property(weak,nonatomic)id<audioCellDelegate> delegate;

- (IBAction)pauseTapped:(id)sender;
- (IBAction)playTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;

//buttons
@property (strong, nonatomic) IBOutlet UILabel *recordingLbl;


@property (strong, nonatomic) IBOutlet UIView *audiocellView;

@end
