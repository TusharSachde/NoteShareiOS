//
//  textCell.h
//  NoteShare
//
//  Created by Heba khan on 11/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface textCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *displayLabel;
@end
