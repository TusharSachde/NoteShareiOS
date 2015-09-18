//
//  TutorialViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 05/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIImageView *slowAnimationImageView;

@property (strong, nonatomic) IBOutlet UIButton *next;

- (IBAction)next:(id)sender;

@end
