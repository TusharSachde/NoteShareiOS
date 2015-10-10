//
//  FolderListPopupViewController.h
//  NoteShare
//
//  Created by Heba khan on 16/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    
    folderList,
    folderSelected,
    
} selectFolder;

@protocol PopUpFolderViewDelegate <NSObject>

-(void)dismissolderListTable:(selectFolder)selectedOption;// WithTag:(NSInteger)selectedOption;
-(void)folderLabel:(NSString*)folderId;

-(void)didFolderItemClick:(selectFolder)data;

@end




@interface FolderListPopupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tbl;

@property(nonatomic,strong)NSArray *arrFolder;
@property(nonatomic,strong)NSString *folderStr;
@property(nonatomic,weak)id <PopUpFolderViewDelegate> delegate;
- (IBAction)closePopup:(id)sender;

@end
