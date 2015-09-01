//
//  FolderGridCell.h
//  NotesSharingApp
//
//  Created by tilak raj verma on 16/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderGridCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail1;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl1;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail2;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl2;



//buttons
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn1;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn1;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn2;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn2;

@end