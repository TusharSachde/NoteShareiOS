//
//  ProfileViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 20/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ProfileViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//buttons

- (IBAction)uploadImage:(id)sender;
- (IBAction)next:(id)sender;


//ImageView

@property (weak,nonatomic) UIActionSheet *sheet;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;


@end
