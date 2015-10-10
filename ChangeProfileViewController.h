//
//  ChangeProfileViewController.h
//  NoteShare
//
//  Created by Heba khan on 03/10/15.
//  Copyright © 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ChangeProfileViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@property (strong, nonatomic) IBOutlet UIButton *changeBtn;
- (IBAction)changeBtn:(id)sender;


@property (weak,nonatomic) UIActionSheet *sheet;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (strong, nonatomic) IBOutlet UIButton *choosePicBtn;
- (IBAction)choosePicBtn:(id)sender;

@end
