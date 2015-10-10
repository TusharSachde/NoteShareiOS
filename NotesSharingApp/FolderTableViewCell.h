//
//  FolderTableViewCell.h
//  NotesSharingApp
//
//  Created by Heba khan on 20/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface FolderTableViewCell : SWTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameOfFolder;
@property (strong, nonatomic) IBOutlet UILabel *notesDesc;
@property (strong, nonatomic) IBOutlet UILabel *timeStamp;



//buttons
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@property (strong, nonatomic) IBOutlet UIImageView *bombImage;
@property (strong, nonatomic) IBOutlet UIImageView *lockImage;


@end
