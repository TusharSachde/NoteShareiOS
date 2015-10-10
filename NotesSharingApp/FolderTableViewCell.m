//
//  FolderTableViewCell.m
//  NotesSharingApp
//
//  Created by Heba khan on 20/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "FolderTableViewCell.h"

@implementation FolderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)share:(id)sender {
}

- (IBAction)delete:(id)sender {
    
}
@end


