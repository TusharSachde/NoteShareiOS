//
//  FolderGridCell.h
//  NotesSharingApp
//
//  Created by tilak raj verma on 16/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"




@protocol FolderGridCellDelegate <NSObject>

-(void)DidTileSelected:(DBNoteItems*)datamodel withTileIndex:(NSInteger)tileIndex;


@end

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

@property (strong, nonatomic)  DBNoteItems *slideDataModel1;
@property (strong, nonatomic)  DBNoteItems *slideDataModel2;

@property(nonatomic,assign)NSInteger tileIndex1;
@property(nonatomic,assign)NSInteger tileIndex2;

-(IBAction)tile1Click:(id)sender;
-(IBAction)tile2Click:(id)sender;

@property(nonatomic,weak)id<FolderGridCellDelegate> tileDelegate;


@end
