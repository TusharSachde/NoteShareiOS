//
//  FolderViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 20/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "CHTCollectionViewWaterfallLayout.h"
#import "SlidePopUpView.h"
#import "SlideDataModel.h"

#import "SWTableViewCell.h"


@interface NoteDatamodel : NSObject

@end

@interface FolderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout,UIGestureRecognizerDelegate,UISearchBarDelegate,SWTableViewCellDelegate>


@property (strong, nonatomic) IBOutlet UITextField *viewSearch;

//buttons
- (IBAction)sort:(id)sender;
- (IBAction)addField:(id)sender;
- (IBAction)view:(id)sender;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

//table
@property (strong, nonatomic)  SlidePopUpView *slidePopupView;
@property (strong, nonatomic) IBOutlet UITableView *tbl;
@property (strong, nonatomic) IBOutlet UIView *viewCollectionview;

//populating array
@property(strong,nonatomic) NSArray *cellName;
@property(strong,nonatomic) NSArray *cellDeatil;
@property(strong,nonatomic) NSArray *cellTimeDetail;

//nav bar buttons
- (IBAction)sideBar:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sidebar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

//tab bar
@property (strong, nonatomic) IBOutlet UIImageView *imgView;


//image Picker
@property (weak,nonatomic) UIActionSheet *sheet;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;


//long press gesture
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *lpgr;

@end
