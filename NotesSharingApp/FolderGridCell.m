//
//  FolderGridCell.m
//  NotesSharingApp
//
//  Created by tilak raj verma on 16/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "FolderGridCell.h"

@implementation FolderGridCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(IBAction)tile1Click:(id)sender
{
    
    [_tileDelegate DidTileSelected:_slideDataModel1 withTileIndex:_tileIndex1] ;
}
-(IBAction)tile2Click:(id)sender
{
    
    [_tileDelegate DidTileSelected:_slideDataModel2 withTileIndex:_tileIndex2];
}




@end
