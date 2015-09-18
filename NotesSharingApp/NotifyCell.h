//
//  NotifyCell.h
//  NotesSharingApp
//
//  Created by Heba khan on 22/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *notifyLbl;

@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *img;

@end
