//
//  sharePopupCell.h
//  NotesSharingApp
//
//  Created by Heba khan on 04/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sharePopupCell : UITableViewCell

@property(nonatomic,strong) UIView *viewSep;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *imageIcon;

@end
