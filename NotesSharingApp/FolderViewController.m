
//  FolderViewController.m
//  NotesSharingApp
//  Created by Heba khan on 20/06/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.

#import "FolderViewController.h"
#import "FolderTableViewCell.h"
#import "FolderGridCell.h"
#import "SWRevealViewController.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"
#import "NSArray+SIAdditions.h"
#import "UIColor+SIAdditions.h"
#import "masterCodeViewController.h"
#import "NoteColorViewController.h"
#import "AddProjectViewController.h"
#import "UIViewController+CWPopup.h"
#import "NSArray+SIAdditions.h"
#import "AddFolderViewController.h"
#import "SWTableViewCell.h"
#import "FolderListPopupViewController.h"
#import "shareOptionPopViewController.h"
#import "SMCThemesSupport.h"
#import "DBManager.h"
#import <MessageUI/MessageUI.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import "DataManger.h"
#import "CommonVariableViewController.h"

#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"


#define isBombImage [UIImage imageNamed:@"bomb00.png"]//put image
#define isNotBombImage [UIImage imageNamed:@""]//no image

@implementation NoteDatamodel

@end


@interface FolderViewController ()<SlidePopUpViewDelegate,PopUpViewDelegate,PopUpViewDelegate1,SWTableViewCellDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,PopUpNoteColorDelegate,PopUpFolderViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,masterCodeViewControllerDelagte,UITextViewDelegate,SWRevealViewControllerDelegate,FolderGridCellDelegate>

{
    MFMailComposeViewController *mailComposer;
    
    NSIndexPath *indexPath2;
    NSString *MyCount;
    NSUInteger elements;
    NSArray *sortedArray;
    UILabel *count;
    UIView *viewLeftnavBar;
}
@property (nonatomic) UITextField *txtSearch;

@property(nonatomic,strong)NSString *toNoteshareEmail;
@property (nonatomic,assign) NSInteger temp;
@property (nonatomic,assign) NSInteger pop;
@property(nonatomic,assign)NSInteger selectedButton;
@property(nonatomic,assign)NSInteger selectedIndexPath;
@property(nonatomic,assign)NSInteger swipeButtonindexPath;
@property(nonatomic,strong)UIActionSheet *actionSheet1;
@property(nonatomic,strong)UIActionSheet *actionSheet2;
@property (nonatomic, strong) NSMutableArray *cellSizes;
@property (nonatomic, strong) SlidePopUpView *popup;
@property (nonatomic, strong)DBNoteItems *noteItems1;
@property(nonatomic,strong)UIView *searchView;
@property(nonatomic,assign)NSInteger sortByKey;


//define global array
@property (nonatomic,strong)NSMutableArray *viewArr;
@property (nonatomic,strong)NSMutableArray *sortArr;
@property (nonatomic,strong)NSMutableArray *arrNotes;
@property (nonatomic,strong)NSArray *colorArr;
@property (nonatomic,strong) NSMutableArray *rightUtilityButtons ;
@property(nonatomic,strong)DBManager *dbManager;
@property(nonatomic,strong)NSMutableArray *arrAll;
@property(nonatomic,strong)NSArray *arrAll1;
@property(nonatomic,strong)NSString *bgColor;
@property(nonatomic,assign)NSUInteger alertInteger;
@property(nonatomic,assign)BOOL isLock;


@property(nonatomic,weak)IBOutlet UIView *viewPickerContainer;
@property(nonatomic,weak)IBOutlet UIDatePicker *datePicker;
@property(nonatomic,weak)IBOutlet UIButton *btnDone;
@property(nonatomic,weak)IBOutlet UIButton *btnCancel;
-(IBAction)btnPickerSelcted:(id)sender;
-(IBAction)btnCancelClick:(id)sender;
-(IBAction)btnDoneClick:(id)sender;

@property(nonatomic,assign)NSInteger seletedIndex;

@property(nonatomic,strong)masterCodeViewController *masterLockVC;


@end

@implementation FolderViewController

-(masterCodeViewController *)masterLockVC
{
    if (!_masterLockVC)
    {
        _masterLockVC=[[masterCodeViewController alloc]initWithNibName:@"masterCodeViewController" bundle:nil];
        _masterLockVC.delegate=self;
    }
    
    return _masterLockVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadViewWillApper:) name:postNotification object:nil];
    
    
    
   
    if (_sortByKey==@"".integerValue) {
        
        _sortByKey=21;
    }
    
    [[DataManger sharedmanager]getSortBy];
    
    
    
    if (viewVar==nil) {
        
        _selectedButton=202;
    }
    else
    {
        _selectedButton=viewVar.integerValue;
    }
    
    _selectedIndexPath=0;
    _seletedIndex=-1;
    
    _txtSearch.tag=400;
    
    [self showAndHidePickerView:NO];
    
    _datePicker.minimumDate=[NSDate date];
    
    _dbManager=[[DBManager alloc]init];
    
    [_dbManager createDbANdTable];
    [_dbManager insert:[_dbManager getDbFilePath] withName:@"" note_default_Font:@"" note_default_Password:@"" note_user_id:[[DataManger sharedmanager] getUserId] note_default_color:@""];
    
    [_dbManager getSettingRecords:[_dbManager getDbFilePath]];
    
    
    viewLeftnavBar=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0,40.0, 40)];
    viewLeftnavBar.backgroundColor=[UIColor clearColor];
    
    
    // tableview
    self.tbl.delegate = self;
    
    
    // search view
    self.searchView = [[UIView alloc]initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, 40)];
    
    self.searchView.backgroundColor=[UIColor colorWithRed:(236.0/255) green:(236.0/255) blue:(236.0/255) alpha:(1.0)];
    
    [self.tbl addSubview:self.searchView];
    
    self.viewSearch = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-60, 28)];
    //To make the border look very close to a UITextField
    [self.viewSearch.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.viewSearch.layer setBorderWidth:1.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.viewSearch.layer.cornerRadius = 5;
    self.viewSearch.clipsToBounds = YES;

    self.viewSearch.backgroundColor=[UIColor whiteColor];
    self.searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35,4, 25, 25)];
    self.viewSearch.delegate=self;
    
    self.viewSearch.placeholder=@"  Search Text...";
    [self.viewSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //self.searchBtn.backgroundColor=[UIColor yellowColor];
    //search icon.png
    [self.searchBtn setBackgroundImage:[UIImage imageNamed:@"search icon.png"] forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(searchText:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:self.viewSearch];
    [self.searchView addSubview:self.searchBtn];
    
    
    _viewArr=[[NSMutableArray alloc]init];
    _sortArr=[[NSMutableArray alloc]init];
    _arrNotes=[[NSMutableArray alloc]init];
    
    _colorArr=[[NSArray alloc]init];
    
    _colorArr=[NSArray arrayWithObjects:@"#ffffff",@"#FF2C08",@"#FFFF00",@"#2C00E6",@"#FFC6E6",@"#C03067",@"#996633",@"#00FFFF",@"#FF00FF",@"#7F007F",@"#01A2FF",@"#00FF00",@"#E4EBAD",@"#D8A9E8",nil];
    
    [self getSlideData];
    
    
    self.tbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbl.allowsSelectionDuringEditing=YES;
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    
    [self getLeftBtn];
    [self getSaveBtn];
    
    //nav bar title color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
    //tab bar image outline color
    _imgView.layer.borderWidth = 1.0f;
    _imgView.layer.borderColor = [[UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]CGColor];
    

    [_tbl reloadData];
    
    self.viewCollectionview.hidden=YES;
    [self.viewCollectionview addSubview:self.collectionView];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    //pop up vc
    _popup=[[SlidePopUpView alloc]initWithFrame:CGRectMake(0.0,self.self.view.frame.size.height,self.view.frame.size.width, 300)];
    
    UIButton *slideBtn=[[UIButton alloc]initWithFrame:CGRectMake(294.0,10.0, 25, 25)];
    [slideBtn setTitle:@"OK" forState:UIControlStateNormal];
    [slideBtn addTarget:self action:@selector(slideBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _popup.delegate=self;
    [self.view addSubview:_popup];
    [_popup addSubview:slideBtn];
    
    
    //UIGesture Long Pressed Cell
    _lpgr = [[UILongPressGestureRecognizer alloc]
             initWithTarget:self action:@selector(handleLongPressGesture:)];
    _lpgr.minimumPressDuration = 1.0; //seconds
    _lpgr.delegate = self;
    [self.tbl addGestureRecognizer:_lpgr];
    
    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]init];
    [tapGesture addTarget:self action:@selector(handletap:)];
    
    
    
}

-(void)searchText:(id)sender{

    _arrAll=[NSMutableArray arrayWithArray:[_dbManager getRecordsWithSearch:[_dbManager getDbFilePath] searchText:self.viewSearch.text]];
    
   // self.viewSearch.text=@"";
    [self updatenotelistfromDb];


}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    
        _arrAll=[NSMutableArray arrayWithArray:[_dbManager getRecordsWithSearch:[_dbManager getDbFilePath] searchText:theTextField.text]];
        
        // self.viewSearch.text=@"";
        [self updatenotelistfromDb];
        
        [self.tbl reloadData];
        
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{


   _arrAll=[NSMutableArray arrayWithArray:[_dbManager getRecordsWithSearch:[_dbManager getDbFilePath] searchText:textView.text]];
    [self updatenotelistfromDb];
    

}

-(IBAction)slideBtn:(id)sender{

    [self hideSheet];

}


-(void)reloadViewWillApper:(id)sender
{
    [self getAllNotes];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        [self.viewSearch resignFirstResponder];
    }
    
    
    count=[[UILabel alloc]initWithFrame:CGRectMake(132.0, 10.0, 90, 20)];
    count.tag = 7;
    count.text=MyCount;
    count.textColor=[UIColor whiteColor];
    count.font=[UIFont systemFontOfSize:14.0 weight:1.0];
    
    
    if(scrollView.contentOffset.y < 0)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        
        self.tbl.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
        [viewLeftnavBar addSubview:count];
        [UIView commitAnimations];
        
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        
        [self.viewSearch resignFirstResponder];
        self.tbl.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        for (count in [viewLeftnavBar subviews]) {
            if (count.tag == 7) {
                [count removeFromSuperview];
            }
        }
        [self.txtSearch setText:@""];
        
        
        [UIView commitAnimations];
        
        
    }
    

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getLeftBtn{
    
    UIButton *Btn=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 5.0, 30, 30)];
    
    Btn.imageView.image=[UIImage imageNamed:@"sidebarIcon40x40.png"];
    
    [Btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"sidebarIcon40x40.png"]]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(sideBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:Btn];
    
    UIImageView *Btn2=[[UIImageView alloc]initWithFrame:CGRectMake(40.0, 10.0, 80, 20)];
    [Btn2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ns_logo.png"]]];
    [viewLeftnavBar addSubview:Btn2];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:viewLeftnavBar];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
}


-(IBAction)sideBarBtn:(id)sender{
    
    [[self revealViewController ]revealToggleAnimated:YES];
    
}

-(void)getSaveBtn{
    
//    UIView *viewLeftNavBar=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0,80, 40)];
//    viewLeftNavBar.backgroundColor=[UIColor clearColor];
//    
//    UIButton *Btn=[[UIButton alloc]initWithFrame:CGRectMake(18.0, 5.0, 30, 30)];
//    
//    
//    [Btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"nabBtn2"]]  forState:UIControlStateNormal];
//    [Btn addTarget:self action:@selector(button2:) forControlEvents:UIControlEventTouchUpInside];
//    [viewLeftNavBar addSubview:Btn];
//    
//    
//    UIButton *Btn2=[[UIButton alloc]initWithFrame:CGRectMake(60.0, 5.0, 30, 30)];
//    [Btn2 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"calender.png"]]  forState:UIControlStateNormal];
//    [Btn2 addTarget:self action:@selector(calender:) forControlEvents:UIControlEventTouchUpInside];
//    [viewLeftNavBar addSubview:Btn2];
//    
//    
//    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:viewLeftNavBar];
//    [self.navigationItem setRightBarButtonItem:addButton];
    
}

-(IBAction)calender:(id)sender{
    

}

-(IBAction)button2:(id)sender{
}

-(void)getSlideData{
    
    _rightUtilityButtons = [NSMutableArray new];
    [_rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                  icon:[UIImage imageNamed:@"lock55x55.png"]];
    [_rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                  icon:[UIImage imageNamed:@"bomb55x55.png"]];
    [_rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                  icon:[UIImage imageNamed:@"send55x55.png"]];
    [_rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                  icon:[UIImage imageNamed:@"delete55x55.png"]];
    [_rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                  icon:[UIImage imageNamed:@"share55x55.png"]];
    
#pragma mark-slide list detail
    
    
    NSString *strPath=[[NSBundle mainBundle]pathForResource:@"slidemenu" ofType:@"txt"];
    NSData *data=[NSData dataWithContentsOfFile:strPath];
    
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    
    NSArray *arrView=[response valueForKey:@"view"];
    
    for (NSDictionary *dict in arrView)
    {
        SlideDataModel *model=[[SlideDataModel alloc]init];
        
        model.strTitle=[dict valueForKey:@"name"];
        model.strIconName=[dict valueForKey:@"imagename"];
        model.itemId=[[dict valueForKey:@"itemid"] integerValue];
        
        [_viewArr addObject:model];
    }
    
    
    
    
    NSArray *arrSort=[response valueForKey:@"sort"];
    
    for (NSDictionary *dict in arrSort)
    {
        SlideDataModel *model=[[SlideDataModel alloc]init];
        model.strTitle=[dict valueForKey:@"name"];
        model.strIconName=[dict valueForKey:@"imagename"];
        model.itemId=[[dict valueForKey:@"itemid"] integerValue];
        
        [_sortArr addObject:model];
    }
    
    
}


-(void)updatenotelistfromDb{
    
#pragma mark-Note list detail
    
    [_arrNotes removeAllObjects];
    
    NSMutableArray *arrData=[[NSMutableArray alloc]init];
    
    
    
    for (DBNoteItems *noteItem in _arrAll)
    {
        
        SlideDataModel *model=[[SlideDataModel alloc]init];
        model.cellName=noteItem.note_Title;
        model.cellId= noteItem.note_Id.integerValue;
        
        if ([noteItem.note_Color_List isEqualToString:@"(null)"])
        {
            model.colours=@"#ffffff";
        }
        else
        {
            model.colours=noteItem.note_Color_List;
        }
        
        model.modifiedtime=noteItem.note_Modified_Time;
        model.createdtime=noteItem.note_Created_Time;
        model.timebomb=noteItem.note_Time_bomb;
        model.remindertime=noteItem.note_Reminder;
        model.celllock=noteItem.note_lock;
        
       NSArray *arrNoteElement=[_dbManager getAllNoteElementWithNote_Id:[_dbManager getDbFilePath] where:noteItem.note_Id];
        DBNoteItems *itemsNote=[arrNoteElement si_objectOrNilAtIndex:0];
        
        if (itemsNote)
        {
           model.noteType=itemsNote.NOTE_ELEMENT_TYPE;
        }
        

        if (![model.timebomb isEqualToString:@"0"]&&model.timebomb)
        {
            
            BOOL status=[self isEndDateIsSmallerThanCurrent:model.timebomb];
            if (!status)
            {
                [_arrNotes addObject:model];
                [arrData addObject:noteItem];
                
                
            }
            else
            {
                //remove object
            }
            
        }
        else
        {
            
            [_arrNotes addObject:model];
            [arrData addObject:noteItem];
        }
        
        
        
        
    }
    
    
    MyCount=[NSString stringWithFormat:@"NOTES (%i)",(int)_arrNotes.count];
    _arrAll=[[NSMutableArray alloc]initWithArray:arrData];
    
    [_tbl reloadData];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 1, 1);
        layout.headerHeight = 0;
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
        
    }
    return _collectionView;
    
}

- (NSMutableArray *)cellSizes{
    if (!_cellSizes) {
        
        _cellSizes = [NSMutableArray array];
        for (NSInteger i = 0; i < _arrNotes.count; i++)
        {
            
            SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:i];
            UIFont  *font=[UIFont systemFontOfSize:17.0] ;
            
            CGSize size1 =[model.cellName boundingRectWithSize:CGSizeMake(150, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{
                                                                 NSFontAttributeName :font
                                                                 }
                                                       context:nil].size;
            CGSize size2 =[model.cellDetail boundingRectWithSize:CGSizeMake(150, MAXFLOAT)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{
                                                                   NSFontAttributeName :font
                                                                   }
                                                         context:nil].size;
            
            
            
            
            
            CGSize size = CGSizeMake(100+ 50, size1.height+size2.height);
            
            
            _cellSizes[i] = [NSValue valueWithCGSize:size];
        }
    }
    return _cellSizes;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrNotes.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    
    SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:indexPath.row];
    
    cell.displayString = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
    
    cell.lbltitle.text=model.cellName;
    cell.lblDetail.text=model.cellDetail;
    cell.contentView.backgroundColor=[UIColor si_getColorWithHexString:model.colours];
    cell.lbltitle.numberOfLines=2;
    cell.lbltitle.lineBreakMode=NSLineBreakByWordWrapping;
    
    cell.lblDetail.numberOfLines=10;
    cell.lblDetail.lineBreakMode=NSLineBreakByWordWrapping;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        
        
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
        
        
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (_selectedButton!=203)
    {
        DBNoteItems *noteItem=[_arrAll si_objectOrNilAtIndex:indexPath.row];
        
        if ([noteItem.note_lock boolValue]==YES)
        {
            
            _selectedIndexPath=indexPath.row;
            [self.masterLockVC setNoteItems:noteItem];
            [self.masterLockVC setIsCommingFrom:YES];
            
            [self presentViewController:self.masterLockVC animated:YES completion:^{
                
            }];
            
            
        }
        else
        {
            _selectedIndexPath=indexPath.row;
            
            [self performSegueWithIdentifier:@"noteElement" sender:nil];
        }
 
    }
    
}

-(void)openNote:(BOOL)isunlock
{
    [self performSegueWithIdentifier:@"noteElement" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    id destinationVc=segue.destinationViewController;
    
    if ([destinationVc isKindOfClass:[AddProjectViewController class]])
    {
        DBNoteItems *noteItem=[_arrAll si_objectOrNilAtIndex:_selectedIndexPath];
        NSLog(@"DBNOTEITEM = %@,%@",noteItem.note_Title,noteItem.note_Color);
        
        AddProjectViewController *addProjectViewController=(AddProjectViewController*)destinationVc;
        [addProjectViewController setDbnotelistItem:noteItem];
        
    }

}

-(void)dismissView:(OPTIONSELECTED)selectedOption
{
    
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
        NSLog(@"popup view dismissed");
        
    }];
    
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.cellSizes[indexPath.item] CGSizeValue];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark-Sorting click

- (IBAction)sort:(id)sender{
    
    _pop=1;
    [self showSheeet];
    
    SlideDataModel *model=[[SlideDataModel alloc]init];
    model.strTitle=@"SORT";
    model.strIconName=@"sort_pop_up.png";//image name
    
    [_popup setHeaderdetail:model];
    
    [_popup setArrItems:[NSArray arrayWithArray:_sortArr]];

}

- (IBAction)addField:(id)sender {
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Note title" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Cancel",nil];
    alert.delegate=self;
    alert.tag=2000;
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Note title here";
    [alert show];

}

-(void)dismissFolderView:(CREATEFOLDER)selectOption   WithTag:(NSInteger)selectedOption{
    
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
        [_tbl reloadData];
    }];
 
}

- (IBAction)view:(id)sender {
    
    _pop=2;
    [self showSheeet];
    
    SlideDataModel *model=[[SlideDataModel alloc]init];
    model.strTitle=@"VIEW";
    model.strIconName=@"view_pop_up.png";//image name
    
    [_popup setHeaderdetail:model];
    
    [_popup setArrItems:[NSArray arrayWithArray:_viewArr]];
    
}

-(void)didItemClick:(SlideDataModel *)dataModel{
    
    switch (dataModel.itemId)
    {
        case 11:
        {
            
            _viewCollectionview.hidden=YES;
            
            _selectedButton=201;
            viewVar=[NSString stringWithFormat:@"%ld",(long)_selectedButton];
        
            [_tbl reloadData];
            
            
        }
            break;
        case 12:
        {
            
            _viewCollectionview.hidden=YES;
            _selectedButton=202;
            viewVar=[NSString stringWithFormat:@"%ld",(long)_selectedButton];
            [_tbl reloadData];
            
            
        }
            break;
        case 13:
        {
            
            _viewCollectionview.hidden=YES;
            
            _selectedButton=203;
            viewVar=[NSString stringWithFormat:@"%ld",(long)_selectedButton];
            [_tbl reloadData];
            
            
        }
            break;
        case 14:
        {
            
            
            _viewCollectionview.hidden=NO;
            _selectedButton=204;
            viewVar=[NSString stringWithFormat:@"%ld",(long)_selectedButton];
            [_tbl reloadData];
            
        }
            break;
            
        case 21:
        {
            
            
#pragma mark-Sort by name
            
            _sortByKey=21;
            
            NSSortDescriptor *sortDescriptor =
            [NSSortDescriptor sortDescriptorWithKey:@"cellName"
                                          ascending:YES
                                           selector:@selector(caseInsensitiveCompare:)];
            
            
            NSArray *arr=[_arrNotes sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            _arrNotes=[NSMutableArray arrayWithArray:arr];
            
            [[DataManger sharedmanager]setSortBy:[NSString stringWithFormat:@"%ld",(long)_sortByKey]];
            
            [_tbl reloadData];
            
 
        }
            break;
            
        case 22:
        {
            
#pragma mark-Sort by color
            
            _sortByKey=22;
            
            NSSortDescriptor *sortDescriptor =
            [NSSortDescriptor sortDescriptorWithKey:@"colours"
                                          ascending:YES
                                           selector:@selector(caseInsensitiveCompare:)];
            NSArray *arr=[_arrNotes sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            
            
            _arrNotes=[NSMutableArray arrayWithArray:arr];
            
            [[DataManger sharedmanager]setSortBy:[NSString stringWithFormat:@"%ld",(long)_sortByKey]];
            
            [_tbl reloadData];
            
        }
            break;
            
        case 23://CREATED TIME
        {
            
#pragma mark-Sort by created time
            
      
            _sortByKey=23;
            
            NSArray* newArray = [_arrNotes sortedArrayUsingComparator: ^NSComparisonResult(SlideDataModel *c1, SlideDataModel *c2)
                                 {
                                     NSDate *d1 = [self str2date:c1.createdtime onlyDate:NO];
                                     NSDate *d2 = [self str2date:c2.createdtime onlyDate:NO];
                                     
                                     return [d2 compare:d1];
                                 }];
            
            NSArray* newArray1 = [_arrAll sortedArrayUsingComparator: ^NSComparisonResult(DBNoteItems *c1, DBNoteItems *c2)
                                  {
                                      NSDate *d1 = [self str2date:c1.note_Created_Time onlyDate:NO];
                                      NSDate *d2 = [self str2date:c2.note_Created_Time onlyDate:NO];
                                      
                                      return [d2 compare:d1];
                                  }];
            
            _arrAll=[NSMutableArray arrayWithArray:newArray1];
            _arrNotes=[NSMutableArray arrayWithArray:newArray];
            
            [[DataManger sharedmanager]setSortBy:[NSString stringWithFormat:@"%ld",(long)_sortByKey]];
            
            [_tbl reloadData];
            
            
        }
            break;
            
        case 24://Modified time
        {
            
#pragma mark-Sort by modified time
            
            _sortByKey=24;
            
            NSArray* newArray = [_arrNotes sortedArrayUsingComparator: ^NSComparisonResult(SlideDataModel *c1, SlideDataModel *c2)
                                 {
                                     NSDate *d1 = [self str2date:c1.modifiedtime onlyDate:NO];
                                     NSDate *d2 = [self str2date:c2.modifiedtime onlyDate:NO];
                                     
                                     return [d2 compare:d1];
                                 }];
            
            NSArray* newArray1 = [_arrAll sortedArrayUsingComparator: ^NSComparisonResult(DBNoteItems *c1, DBNoteItems *c2)
                                  {
                                      NSDate *d1 = [self str2date:c1.note_Modified_Time onlyDate:NO];
                                      NSDate *d2 = [self str2date:c2.note_Modified_Time onlyDate:NO];
                                      
                                      return [d2 compare:d1];
                                  }];
            
            _arrAll=[NSMutableArray arrayWithArray:newArray1];
            _arrNotes=[NSMutableArray arrayWithArray:newArray];
            
            [[DataManger sharedmanager]setSortBy:[NSString stringWithFormat:@"%ld",(long)_sortByKey]];
            
            [_tbl reloadData];
            
        }
            
            break;
            
        case 25://reminder time
        {
#pragma mark-Sort by reminder time
            
            _sortByKey=25;
            
            NSMutableArray *Arr=[[NSMutableArray alloc]init];//table
            NSMutableArray *Arr1=[[NSMutableArray alloc]init];//db
            
            
            NSMutableArray *Arr3=[[NSMutableArray alloc]init];//table
            NSMutableArray *Arr4=[[NSMutableArray alloc]init];//db
            
            for (SlideDataModel *object1 in _arrNotes)
            {
                
                if (![object1.remindertime isEqualToString:@""]&&object1.remindertime)
                {
                    [Arr addObject:object1];
                }
                else{
                    
                    [Arr3 addObject:object1];
                }
                
            }
            
            for (DBNoteItems *object1 in _arrAll)
            {
                
                if (![object1.note_Reminder isEqualToString:@""]&&object1.note_Reminder){
                    [Arr1 addObject:object1];
                }
                else
                {
                    [Arr4 addObject:object1];
                }
                
                
            }
            
            
            
            
            NSArray* newArray = [Arr sortedArrayUsingComparator: ^NSComparisonResult(SlideDataModel *c1, SlideDataModel *c2)
                                 {
                                     NSDate *d1 = [self str2date:c1.remindertime onlyDate:NO];
                                     NSDate *d2 = [self str2date:c2.remindertime onlyDate:NO];
                                     
                                     return [d2 compare:d1];
                                 }];
            
            NSArray* newArray1 = [Arr1 sortedArrayUsingComparator: ^NSComparisonResult(DBNoteItems *c1, DBNoteItems *c2)
                                  {
                                      NSDate *d1 = [self str2date:c1.note_Reminder onlyDate:NO];
                                      NSDate *d2 = [self str2date:c2.note_Reminder onlyDate:NO];
                                      
                                      return [d2 compare:d1];
                                  }];
            
            
            
            
            
            _arrAll=[NSMutableArray arrayWithArray:newArray1];
            
            for (DBNoteItems *model in Arr4)
            {
                [_arrAll addObject:model];
            }
            
            _arrNotes=[NSMutableArray arrayWithArray:newArray];
            
            for (SlideDataModel *model in Arr3)
            {
                [_arrNotes addObject:model];
            }
            
            [[DataManger sharedmanager]setSortBy:[NSString stringWithFormat:@"%ld",(long)_sortByKey]];
            
            [_tbl reloadData];
            
            
        }
            break;
            
            
        case 26://time bomb
        {
            
#pragma mark-Sort by  time bomb
            
            _sortByKey=26;
            
            
            NSMutableArray *Arr=[[NSMutableArray alloc]init];//table
            NSMutableArray *Arr1=[[NSMutableArray alloc]init];//db
            
            
            NSMutableArray *Arr3=[[NSMutableArray alloc]init];//table
            NSMutableArray *Arr4=[[NSMutableArray alloc]init];//db
            
            for (SlideDataModel *object1 in _arrNotes)
            {
                
                if (![object1.timebomb isEqualToString:@"0"]&&object1.timebomb){
                    [Arr addObject:object1];
                }
                else{
                    
                    [Arr3 addObject:object1];
                }
                
            }
            
            for (DBNoteItems *object1 in _arrAll)
            {
                
                if (![object1.note_Time_bomb isEqualToString:@"0"]&&object1.note_Time_bomb){
                    [Arr1 addObject:object1];
                }
                else
                {
                    [Arr4 addObject:object1];
                }
                
                
            }
            
            
            
            
            NSArray* newArray = [Arr sortedArrayUsingComparator: ^NSComparisonResult(SlideDataModel *c1, SlideDataModel *c2)
                                 {
                                     NSDate *d1 = [self str2date:c1.timebomb onlyDate:NO];
                                     NSDate *d2 = [self str2date:c2.timebomb onlyDate:NO];
                                     
                                     return [d2 compare:d1];
                                 }];
            
            NSArray* newArray1 = [Arr1 sortedArrayUsingComparator: ^NSComparisonResult(DBNoteItems *c1, DBNoteItems *c2)
                                  {
                                      NSDate *d1 = [self str2date:c1.note_Time_bomb onlyDate:NO];
                                      NSDate *d2 = [self str2date:c2.note_Time_bomb onlyDate:NO];
                                      
                                      return [d2 compare:d1];
                                  }];
            
            
            
            
            
            _arrAll=[NSMutableArray arrayWithArray:newArray1];
            
            for (DBNoteItems *model in Arr4)
            {
                [_arrAll addObject:model];
            }
            
            _arrNotes=[NSMutableArray arrayWithArray:newArray];
            
            for (SlideDataModel *model in Arr3)
            {
                [_arrNotes addObject:model];
            }
            
            [[DataManger sharedmanager]setSortBy:[NSString stringWithFormat:@"%ld",(long)_sortByKey]];
            
            [_tbl reloadData];
             
            
        }
            break;
            
        default:
            break;
    }
    
    [self hideSheet];
    [_tbl setContentOffset:CGPointMake(0, 0)];
}


-(void)didNoteUnlock:(BOOL)isunlock
{
    if (isunlock)
    {
     [[[UIAlertView alloc]initWithTitle:@"" message:@"Note unlocked successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show ];
    }else
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Note locked successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show ];
    }
    
    
    [self getAllNotes];
    
}
-(void)handletap:(UITapGestureRecognizer*)gaesture
{
    
    
    [self hideSheet];
    [_txtSearch resignFirstResponder];
    
}

-(void)hideSheet{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        _popup.frame=CGRectMake(0.0,self.self.view.frame.size.height,self.view.frame.size.width,300);
        _popup.backgroundColor=[UIColor clearColor];
        [_popup layoutSubviews];
    }];
}

-(void)showSheeet{
    
    
    if (_pop==1) {
        [UIView animateWithDuration:0.2 animations:^{
            
            
            _popup.frame=CGRectMake(0.0,self.self.view.frame.size.height-310,self.view.frame.size.width, 310);
            _popup.backgroundColor=[UIColor clearColor];
            [_popup layoutSubviews];
        }];
    }
    else if (_pop==2)
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            
            _popup.frame=CGRectMake(0.0,self.self.view.frame.size.height-180,self.view.frame.size.width, 300);
            _popup.backgroundColor=[UIColor clearColor];
            [_popup layoutSubviews];
        }];
        
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (_actionSheet1.tag==_temp) {
        switch (buttonIndex) {
                
            case 0:
                //alphabetical order
            {
                
                NSSortDescriptor *sortDescriptor =
                [NSSortDescriptor sortDescriptorWithKey:@"name"
                                              ascending:YES
                                               selector:@selector(caseInsensitiveCompare:)];
                [_arrNotes sortedArrayUsingDescriptors:@[sortDescriptor]];
                
                _selectedButton=101;
                [_tbl reloadData];
            }
                break;
                
            
        }
        
    }
    else if (_actionSheet2.tag==_temp){
        
        switch (buttonIndex) {
                
            case 0:
                //List view
            {
                
                _viewCollectionview.hidden=YES;
                
                _selectedButton=201;
                [_tbl reloadData];
            }
                break;
                
            case 1:
                //Detail view
            {
                
                _viewCollectionview.hidden=YES;
                _selectedButton=202;
                [_tbl reloadData];
            }
                break;
                
            case 2:
                //Grid view
            {
                _viewCollectionview.hidden=YES;
                
                _selectedButton=203;
                [_tbl reloadData];
                
                
            }
                break;
                
            case 3:
                //Google keep view view
            {
                _viewCollectionview.hidden=NO;
                _selectedButton=204;
                [_tbl reloadData];
                
                
                
            }
                break;
                
            case 4:
                //Cancel Button Clicked
                break;
        }
        
    }
    
    
}

#pragma TableDetails

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    switch (_selectedButton)
    {
        case 201:
        {
            return _arrNotes.count;
        }
            break;
        case 202:
        {
            return _arrNotes.count;
        }
            break;
            
        case 203:
        {
            
            int rowatindex=0;
            NSInteger countrow=_arrNotes.count;
            
            if (countrow%2==0)
            {
                return (rowatindex=_arrNotes.count/2.0);
            }
            else
            {
                rowatindex=_arrNotes.count/2.0;
                return rowatindex+1;
            }
            return 0;
        }
            break;
            
        case 204:
        {
            if ([tableView isEditing])
                return [_arrNotes count] + 1;
            else
            {
                return _arrNotes.count;
            }
        }
            break;
        default:
            return 0;
            break;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    //view
    switch (_selectedButton)
    {
          
            
#pragma mark-list
        case 201:
            
        {
            //list
            
            UITableViewCell *cellList = [tableView dequeueReusableCellWithIdentifier:@"FolderCell"];
            
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            
            if (cellList == nil)
            {
                cellList = [[[NSBundle mainBundle] loadNibNamed:@"FolderTableViewCell" owner:self options:nil] si_objectOrNilAtIndex:0];
                cellList.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"delete00.png"]withtag:indexPath.row];
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"lock00.png"]withtag:indexPath.row];
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"bomb00.png"]withtag:indexPath.row];
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"send00.png"]withtag:indexPath.row];
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"share00.png"]withtag:indexPath.row];
            
            
            
            FolderTableViewCell *cell=(FolderTableViewCell*)cellList;
            
        
            cell.delegate = self;
            
            
            cell.rightUtilityButtons = rightUtilityButtons;
            
            
            SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:indexPath.row];
            
            
            UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
            myBackView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(119/255.0) blue:(121/255.0) alpha:0.5];
            cell.selectedBackgroundView = myBackView;
            
            if (model.cellName.length>0)
            {
                NSString *firstCapChar = [[model.cellName substringToIndex:1] capitalizedString];
                NSString *cappedString = [model.cellName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
                cell.nameOfFolder.text = cappedString;
                cell.notesDesc.text =@"";
                cell.timeStamp.text =@"";
                cell.contentView.backgroundColor=[UIColor si_getColorWithHexString:model.colours];
            }

            return cell;
            
        }
            break;
            #pragma mark-list Detail
            
        case 202:
            
        {
            //list detail
            UITableViewCell *cellDetail = [tableView dequeueReusableCellWithIdentifier:@"FolderCell"];
            
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            
            if (cellDetail == nil)
            {
                cellDetail = [[[NSBundle mainBundle] loadNibNamed:@"FolderTableViewCell" owner:self options:nil] si_objectOrNilAtIndex:0];
                cellDetail.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"deleteTry55.png"] withtag:indexPath.row];
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"newLock55.png"] withtag:indexPath.row];
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"bombTry55.png"] withtag:indexPath.row];
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"moveTry55.png"] withtag:indexPath.row];
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"shareTry55.png"] withtag:indexPath.row];
            
             FolderTableViewCell *cell=(FolderTableViewCell*)cellDetail;
             cell.rightUtilityButtons = rightUtilityButtons;
            cell.delegate = self;
            

            
            //these are not right utility buttons..They are ui images not required
            cell.shareBtn.hidden=NO;
            cell.deleteBtn.hidden=NO;
            
            SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:indexPath.row];
            
            UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
            myBackView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(119/255.0) blue:(121/255.0) alpha:0.5];
            
            cell.selectedBackgroundView = myBackView;
            
            if (model.cellName.length>0)
            {
                NSString *firstCapChar = [[model.cellName substringToIndex:1] capitalizedString];
                NSString *cappedString = [model.cellName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
                
                cell.nameOfFolder.text = cappedString;
                
                //[model.noteType valueForKey:@"note_type"];
                if ([model.noteType  isEqualToString:@"IMAGE"])
                {
                   cell.notesDesc.text = @"IMAGE";
                    
                }
                else if ([model.noteType  isEqualToString:@"AUDIO"])
                {
                    cell.notesDesc.text = @"AUDIO";
                    
                }
                else if ([model.noteType  isEqualToString:@"TEXT"])
                {
                    cell.notesDesc.text = @"TEXT";
                }else{
                    
                    cell.notesDesc.text=@"";
                }

                NSDate *dateGmt=[self str2date:model.createdtime onlyDate:NO];
                
                NSString *strDate=[self date2strLocal:dateGmt onlyDate:NO];
                
                
                cell.timeStamp.text = [strDate uppercaseString];
                cell.contentView.backgroundColor=[UIColor si_getColorWithHexString:model.colours];
            }
            
            if (![model.timebomb isEqualToString:@"0"]&&model.timebomb)
            {
                
                NSLog(@"time bomb set");
                
                
                [cell.bombImage setImage:[UIImage imageNamed:@"redTimeBomb.png"]];
                
            }
            else
            {
                
            //no image
            [cell.bombImage setImage:[UIImage imageNamed:@""]];
                
            }
            
            
            
            if ([model.celllock isEqualToString:@"1"]&&model.celllock)
            {
                
                NSLog(@"lock is set");
                
                
                [cell.lockImage setImage:[UIImage imageNamed:@"redLock.png"]];
                
            }
            else
            {
                
                //no image
                
                [cell.lockImage setImage:[UIImage imageNamed:@""]];
            }
            
            
            
            return cell;
            
        }
            break;
            
            
             #pragma mark-Tile
            
        case 203:
            
        {
            
            UITableViewCell *cellGrid = [tableView dequeueReusableCellWithIdentifier:@"FolderGridCell"];
            
            NSUInteger convertedIndex=indexPath.row*2;
            //grid
            
            FolderGridCell *cell=(FolderGridCell*)cellGrid;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            if (cell == nil) {
                cell = [[FolderGridCell alloc] init];
                
                cell.view1.frame=CGRectMake(2.0, 1.0,(self.tbl.frame.size.width/2.0f)-2, 200);
                cell.view1.clipsToBounds=YES;
                
                cell.view2.frame=CGRectMake((self.tbl.frame.size.width/2.0f)+1, 1.0,self.tbl.frame.size.width/2.0f-2, 200);
                cell.view2.clipsToBounds=YES;
            }
            
            cell.tileDelegate=self;
            
             //FolderGridCell *cell=(FolderGridCell*)cellGrid;
            
            cell.view1.frame=CGRectMake(2.0, 1.0,(cell.frame.size.width/2.0f)-2, 200);
            
            cell.view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.view1.layer.borderWidth = 0.5f;
            
            cell.view1.clipsToBounds=YES;
            
            cell.view2.frame=CGRectMake((cell.frame.size.width/2.0f)+1, 1.0,cell.frame.size.width/2.0f-2, 200);
            
            cell.view2.clipsToBounds=YES;
            
            
            
            UIView *myBackView = [[UIView alloc] initWithFrame:cellGrid.frame];
            myBackView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(119/255.0) blue:(121/255.0) alpha:0.5];
            cellGrid.selectedBackgroundView = myBackView;
            
            if (convertedIndex < _arrNotes.count)
                
            {
                SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:convertedIndex];
                
                [cell setTileIndex1:convertedIndex];
                
                [cell setSlideDataModel1:[_arrAll si_objectOrNilAtIndex:convertedIndex]];
                
                
                
                cell.view1.hidden=NO;
                
                if (model.cellName.length>0)
                {
                    NSString *firstCapChar = [[model.cellName substringToIndex:1] capitalizedString];
                    NSString *cappedString = [model.cellName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
                    cell.lblDetail1.text = cappedString;
                    cell.lblTitle1.text=model.cellDetail;
                    if ([model.noteType  isEqualToString:@"IMAGE"])
                    {
                        cell.lblTitle1.text = @"IMAGE";
                        
                    }
                    else if ([model.noteType  isEqualToString:@"AUDIO"])
                    {
                        cell.lblTitle1.text = @"AUDIO";
                        
                    }
                    else if ([model.noteType  isEqualToString:@"TEXT"])
                    {
                        cell.lblTitle1.text = @"TEXT";
                    }else{
                        
                        cell.lblTitle1.text=@"";
                    }
                    cell.view1.backgroundColor=[UIColor si_getColorWithHexString:model.colours];
                    
                    
                    NSDate *dateGmt=[self str2date:model.createdtime onlyDate:NO];
                    
                    NSString *strDate=[self date2strLocal:dateGmt onlyDate:NO];
                    
                    
                   // cell.timeStamp.text = [strDate uppercaseString];
                    
                    cell.timeLbl1.text=[strDate uppercaseString];//model.createdtime;
                }

            }
            
            else{
                cell.view1.hidden=YES;
            }
            
            if (convertedIndex+1 < _arrNotes.count)
                
            {
                SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:convertedIndex+1];
                
                [cell setTileIndex2:convertedIndex+1];
                
                
                [cell setSlideDataModel2:[_arrAll si_objectOrNilAtIndex:convertedIndex+1]];
                
                cell.view2.hidden=NO;
                
                if (model.cellName.length>0)
                {
                    NSString *firstCapChar = [[model.cellName substringToIndex:1] capitalizedString];
                    NSString *cappedString = [model.cellName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
                    cell.lblDetail2.text = cappedString;
                   // cell.lblTitle2.text=model.cellDetail;
                    if ([model.noteType  isEqualToString:@"IMAGE"])
                    {
                        cell.lblTitle2.text = @"IMAGE";
                        
                    }
                    else if ([model.noteType  isEqualToString:@"AUDIO"])
                    {
                        cell.lblTitle2.text = @"AUDIO";
                        
                    }
                    else if ([model.noteType  isEqualToString:@"TEXT"])
                    {
                        cell.lblTitle2.text = @"TEXT";
                    }else{
                        
                        cell.lblTitle2.text=@"";
                    }
                    cell.view2.backgroundColor=[UIColor si_getColorWithHexString:model.colours];
                    cell.view2.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    cell.view2.layer.borderWidth = 0.5f;
                    
                    
                    
                    NSDate *dateGmt=[self str2date:model.createdtime onlyDate:NO];
                    
                    NSString *strDate=[self date2strLocal:dateGmt onlyDate:NO];
                    
                    
                    // cell.timeStamp.text = [strDate uppercaseString];
                    
                    cell.timeLbl2.text=[strDate uppercaseString];//model.createdtime;
                    
                   // cell.timeLbl2.text=model.createdtime;
                }
                
                
            }
            
            else
            {
                cell.view2.hidden=YES;
            }
            
            
            
            
            return cell;
            
            
            
        }
            break;
        case 204:
            
        {
            //Google keep
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    
    
    return [[UITableViewCell alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //view
    switch (_selectedButton)
    {
        case 201:
            
        {
            
            
            return 44;
            
        }
            break;
        case 202:
            
        {
            //list detail
            return 110;
            
        }
            break;
        case 203:
            
        {
            //grid
            return 200;
            
        }
            break;
        case 204:
            
        {
            //Google keep
            return 88;
            
        }
            break;
            
        default:
            break;
    }
    
    return 33;
    
}

- (IBAction)sideBar:(id)sender {
}

-(void)dismissNoteColor:(selectNoteColor)selectedNoteOption   WithTag:(NSInteger)selectedNoteOption
{
    [self dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
    }];
    
}

-(void)dismissolderListTable:(selectFolder)selectedOption{
    
    [self dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
        
    }];
    
}

-(void)folderLabel:(NSString*)sender{
    
    NSLog(@"clicked");
    
    _noteItems1.folder_id=sender;
    
    [_dbManager UpdateNoteMoveTofolder:[_dbManager getDbFilePath] withNoteItem:_noteItems1];
    
    [_tbl reloadData];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Moved" message:@"Note moved to Folder" delegate:self cancelButtonTitle:nil otherButtonTitles: @"OK",nil];
    [alert show];
    
    NSLog(@"%@",sender);
}

-(void)backgroundNoteColor:(id)sender{
    
    _bgColor=((NoteColorViewController*)sender).colorString;
    
    NSString *strcolor=_bgColor;
    SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:_selectedIndexPath];
    model.colours=strcolor;
    
    [_dbManager UpdateNoteColorOnList:[_dbManager getDbFilePath] withNoteItem:strcolor note_id:[NSString stringWithFormat:@"%i",(int)model.cellId]];
    
    MyCount=[NSString stringWithFormat:@"NOTES (%i)",(int)_arrNotes.count];
    [_tbl reloadData];
    
}


-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint p = [gestureRecognizer locationInView:self.tbl];
    // CGPoint location = [gestureRecognizer locationInView:self.view];
    
    if (_selectedButton!=203)
    {
        
        indexPath2 = [self.tbl indexPathForRowAtPoint:p];
        
        if (indexPath2 == nil)
        {
            NSLog(@"long press on table view but not on a row");
        }
        else if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
            
            _selectedIndexPath=indexPath2.row;
            
            // CGRect targetRectangle = CGRectMake(location.x,location.y,50,50);
            
            NSLog(@"Long Gesture pressed");
            
            NoteColorViewController *samplePopupViewController = [[NoteColorViewController alloc] initWithNibName:@"NoteColorViewController" bundle:nil];
            //[samplePopupViewController setStringAlertTitle:@"Select Color"];
            samplePopupViewController.delegate=self;
            
            [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
                NSLog(@"popup view presented");
            }];
            
        }
        else {
            
            
        }
    }
    
    
}



- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index withCellIndex:(NSInteger)cellIndex{
    
    
    _noteItems1 =  [_arrAll si_objectOrNilAtIndex:cellIndex];
    _seletedIndex=cellIndex;
    
    switch (index) {
            
        case 0:
        {

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this note?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK",nil];
            [alert show];
            alert.tag=3000;
            
        
            
            break;
        }
        case 1:
        {
            
            
#pragma mark-Lock the note
            
            if ([[[DataManger sharedmanager] getMasterLockCode] length]>0)
            {
                if (![_noteItems1.note_lock boolValue])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lock" message:@"Are you sure you want to lock this note?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK",nil];
                    [alert show];
                    
                    alert.tag=200;
                    _alertInteger=alert.tag;
                    alert.delegate=self;
                }
                else
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lock" message:@"Note already Locked! Please unlock" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
                    
                    
                    [alert show];
                    alert.tag=8000;
                    
                   
                    
                    
                }
            }
            else
            {
            
                [self.masterLockVC setNoteItems:_noteItems1];
                [self.masterLockVC setIsCommingFrom:NO];
                [self.navigationController presentViewController:self.masterLockVC animated:YES completion:^{
                    
                }];
                
                
            }

            break;
        }
            
        case 2:
        {
            
            
            if (![_noteItems1.note_Time_bomb isEqualToString:@"0"]&&_noteItems1.note_Time_bomb)
            {
                
                
               NSDate *dateGmt=[self str2date:_noteItems1.note_Time_bomb onlyDate:NO];
                
                NSString *strDate=[self date2strLocal:dateGmt onlyDate:NO];
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Time bomb already set for  this note,It willl expire on :%@",strDate] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"EDIT",nil];
                
                
                [alert show];
                alert.tag=4000;
                
                
                
            }else{
                
                [self showAndHidePickerView:YES];
                
            }
 
            
            break;
        }
        case 3:
        {
            
            
            FolderListPopupViewController *samplePopupViewController = [[FolderListPopupViewController alloc] initWithNibName:@"FolderListPopupViewController" bundle:nil];
            //[samplePopupViewController setStringAlertTitle:@"Select Color"];
            samplePopupViewController.delegate=self;
            
            [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
                NSLog(@"popup view presented");
            }];
            
            
            
            break;
        }
            
        case 4:
        {
            shareOptionPopViewController *sharePopupViewController = [[shareOptionPopViewController alloc] initWithNibName:@"shareOptionPopViewController" bundle:nil];
            [sharePopupViewController setStringAlertTitle:@"SHARE NOTE VIA"];
            sharePopupViewController.delegate=self;
            
            [self presentPopupViewController:sharePopupViewController animated:YES completion:^(void) {
                NSLog(@"popup view presented");
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)dismissSharePopAlert:(selectOption)selectedOption{
    
    [self dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
    }];
    
}
-(void)dismissSharePopAlert:(selectOption)selectedOption withSharingOption:(SharingOptions*)options
{
    
    
    [self dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
    }];
    
    
    switch (options.strId.integerValue) {
        case 100:
            
        {
            //Note share
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter Friends NoteShare Email Id" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Cancel",nil];
            alert.delegate=self;
            alert.tag=100;
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField * alertTextField = [alert textFieldAtIndex:0];
             _toNoteshareEmail=alertTextField.text;
            alertTextField.keyboardType = UIKeyboardTypeDefault;
            alertTextField.placeholder = @"Enter valid email id here";
            [alert show];
            
            
            
        }
            break;
        case 101:
            
        {
            //WhatsApp
            
            NSString * msg =@"Check out NoteShare App for your smartphone.Download it today from https://noteshare.com/dl/";
            NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",msg];
            NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
                [[UIApplication sharedApplication] openURL: whatsappURL];
            } else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has no WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            
        }
            break;
        case 102:
            
        {
            //email
            
            
            mailComposer = [[MFMailComposeViewController alloc]init];
            mailComposer.mailComposeDelegate = self;
            [mailComposer setSubject:@""];
            [mailComposer setMessageBody:@"Check out NoteShare App for your smartphone.Download it today from https://noteshare.com/dl/" isHTML:NO];
            [self presentViewController:mailComposer animated:YES completion:^{
                
            }];
            
        }
            break;
        case 103:
            
        {
            //sms
            
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"Check out NoteShare App for your smartphone.Download it today from https://noteshare.com/dl/";
                //controller.recipients = [NSArray arrayWithObjects:@"12345678", @"87654321", nil];
                controller.messageComposeDelegate = self;
                
                [self presentViewController:controller animated:YES completion:^{
                    
                }];
            }
        }
            break;
        case 104:
            
        {
            //fb messanger
            
            if ([FBSDKMessengerSharer messengerPlatformCapabilities] & FBSDKMessengerPlatformCapabilityImage)
            {
                
                
                [FBSDKMessengerSharer  shareImage:[UIImage imageNamed:@"birdIcon.png"] withOptions:nil];
                
            } else
            {
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Facebook Messanger is not installed." message:@"Your device has no Facebook Messanger installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
            
        default:
            break;
    }
    
    
}

-(void)dismissKeyboard {
    [self.viewSearch resignFirstResponder];
}

- (void)revealControllerPanGestureBegan:(SWRevealViewController *)revealController{
    
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            //[[self revealViewController]revealToggleAnimated:YES];
            [[self revealViewController]_notifyPanGestureBegan];
            break;
        case 1:
            NSLog(@"left utility buttons open");
        {
            // [[self revealViewController]revealToggleAnimated:YES];
            [[self revealViewController]_notifyPanGestureBegan];
            
        }
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

-(NSString*)date2str:(NSDate*)myNSDateInstance onlyDate:(BOOL)onlyDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (onlyDate) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss z"];
    }
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSString *stringFromDate = [formatter stringFromDate:myNSDateInstance];
    return stringFromDate;
}

-(NSString*)date2strLocal:(NSDate*)myNSDateInstance onlyDate:(BOOL)onlyDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (onlyDate)
    {
        [formatter setDateFormat:@"dd MMM yyyy"];
    }
    else
    {
        [formatter setDateFormat: @"dd MMM yyyy hh:mm a"];
    }
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:myNSDateInstance];
    return stringFromDate;
}


-(NSDate*)str2date:(NSString*)myNSDateInstance onlyDate:(BOOL)onlyDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (onlyDate) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss z"];
    }
    
    //Optionally for time zone conversions
    // [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate *stringFromDate = [formatter dateFromString:myNSDateInstance];
    return stringFromDate;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==200) {
        
        
        switch (buttonIndex)
        {
            case 0:
            {
                //cancel
                [_tbl reloadData];
                
            }
                break;
            case 1:
            {
                //ok
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LOCKED" message:@"Your note is locked!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                _noteItems1.note_lock=@"1";
            
                
                [_dbManager UpdateNoteLock:[_dbManager getDbFilePath] withNoteItem:_noteItems1]
                ;
                
                [self getAllNotes];
                
            }
                break;
                
                
        }
        
        
    }
    //create note
    else if(alertView.tag==2000)
    {
        
        
        NSString *strTitle=[alertView textFieldAtIndex:0].text;
        if (![strTitle isEqualToString:@""]) {
            

        switch (buttonIndex)
        {
            case 0:
            {
                NSString *strCreateTime=[self date2str:[NSDate date] onlyDate:NO];
                
                
                NSLog(@"ADDED TITILE:%@",strTitle);
                
                
#pragma mark-insert note
                
                int success= [_dbManager insert:[_dbManager getDbFilePath] withName:strTitle color:@"#ffffff" created_time:strCreateTime modified_time:strCreateTime time_bomb:0 reminder_time:@"" user_id:[[DataManger sharedmanager] getUserId] folder_id:@"" note_element:@"" server_key:@""note_color:@"#ffffff"];
                
                if (success==0)
                {
                    
                    
                    NSLog(@"Note created successfully");
                    
                    NSArray *arrItems=[_dbManager getRecords:[_dbManager getDbFilePath] where:strTitle];
                    DBNoteItems *noteItems=[arrItems si_objectOrNilAtIndex:0];
                    
                    NSLog(@"{%@ \n  %@ \n %@\n %@\n}",noteItems.note_Id,noteItems.note_Title,noteItems.note_Created_Time,noteItems.note_Color);
                    
                    for (DBNoteItems *noteItem in arrItems)
                    {
                        
                        SlideDataModel *model=[[SlideDataModel alloc]init];
                        model.cellName=noteItem.note_Title;
                        
                        model.cellId= noteItem.note_Id.integerValue;
                        model.colours=noteItem.note_Color;
                        model.modifiedtime=noteItem.note_Modified_Time;
                        model.createdtime=noteItem.note_Created_Time;
                        
                        
                        [_arrNotes addObject:model];
                    }
                    

                    MyCount=[NSString stringWithFormat:@"NOTES (%i)",(int)_arrNotes.count];
                    [self getAllNotes];
                    
                }
                
                
            }
                break;
            case 1:
            {
                NSLog(@"1");//no
                [_tbl reloadData];
            }
                break;
        }
        
        }
        
        else//alert error
        {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Field cannot be blank" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            [alert show];
            [_tbl reloadData];
            
        }
    
    }
    
    else if (alertView.tag==3000)
    {
        SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:_seletedIndex];
        
        switch (buttonIndex)
        {
            case 1:
            {
                
                if ([model.celllock isEqualToString:@"1"]&&model.celllock)
                {
                //alert
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Unlock to delete note" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                    [alert show];
                    [_tbl reloadData];
                }
                else
                {
                    [_dbManager deleteNote:[_dbManager getDbFilePath] withNoteItem:_noteItems1];
                    [_arrNotes removeObjectAtIndex:_seletedIndex];
                    [_arrAll removeObjectAtIndex:_seletedIndex];
                    MyCount=[NSString stringWithFormat:@"NOTES (%i)",(int)_arrNotes.count];
                    [_tbl reloadData];
                }
                
                
            }
                break;
                
            default:
                [_tbl reloadData];
                break;
        }
    }
    else if (alertView.tag==4000)
    {
        
        switch (buttonIndex) {
            case 0:
            {
                
                NSLog(@"OK");
            }
                break;
            case 1:
            {
                NSLog(@"Edit");
                
                [self showAndHidePickerView:YES];
            }
                break;
                
            default:
                break;
        }
        
    }
    else if(alertView.tag==8000)
    {
        
        switch (buttonIndex)
        {
            case 1:
                
            {
                [self.masterLockVC setNoteItems:_noteItems1];
                [self.masterLockVC setIsCommingFrom:NO];
                
                [self.navigationController presentViewController:self.masterLockVC animated:YES completion:^{
                    
                }];
            }
                break;
                
                
            default:
                break;
        }
    }
    
    else if (alertView.tag==100)//noteshare to noteshare alert view
        
    {
        switch (buttonIndex)
        {
                
            case 0:
                
            {
                NSLog(@"case 0");//continue
                [self noteshareMethod];
                [_tbl reloadData];
            }
                break;
                
            case 1:
                
            {
                NSLog(@"case 1");//cancel
                [_tbl reloadData];
            }
                break;
                
                
            default:
                break;
        }
    
    
    }
    else
    {
        
        [_tbl reloadData];
    }
    
    
    
}


-(void)noteshareMethod{

    
    UserDetail *detail=[[DataManger sharedmanager]getLoogedInUserdetail];

    NSString *URLString = [NSString stringWithFormat:@"http://104.154.57.170/user/login"];
    
    
    NSMutableDictionary *dictParameter=[[NSMutableDictionary alloc]init];
    
    
    
    [dictParameter setObject:_toNoteshareEmail forKey:@"email"];
    [dictParameter setObject:detail.userID forKey:@"userfrom"];
    [dictParameter setObject:@"" forKey:@"note"];
    
    
    
    
    NSData *dataobject=[NSJSONSerialization dataWithJSONObject:dictParameter options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *strparameter=[[NSString alloc]initWithData:dataobject encoding:NSUTF8StringEncoding];
    
    
    NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *requestPost=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [requestPost setHTTPMethod:@"POST"];
    requestPost.HTTPBody=[strparameter dataUsingEncoding:NSUTF8StringEncoding];
    [requestPost setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *requestError=nil;
    NSURLResponse *response = nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:requestPost returningResponse:&response error:&requestError];
    
    
    if (requestError == nil) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Warning, status code of response was not 200, it was %ld", (long)statusCode);
            }
        }
        
        NSError *error;
        
        NSDictionary *returnDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        
        NSString *value = [returnDictionary valueForKey:@"value"];
        
        
        if (returnDictionary)
        {
           
            if ([value isEqualToString:@"true"]) {
                
                
            }
            
            else
            {
            
            
            }
            

        }
        
        else
        {
            NSLog(@"error parsing JSON response: %@", error);
            
            NSString *returnString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            NSLog(@"returnString: %@", returnString);
        }
    }
    
    else
        
    {
        NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
        
    }


}


-(void)viewWillAppear:(BOOL)animated{
    
    [self getAllNotes];
   // [[DataManger sharedmanager]setSortBy:_arrNotes];
    
}


#pragma mark-get allNote

-(void)getAllNotes
{
    [_arrNotes removeAllObjects];
    
    _arrAll=[[NSMutableArray alloc]initWithArray:[_dbManager getRecords:[_dbManager getDbFilePath]]];
    
    [ self  updatenotelistfromDb];
    [_tbl  reloadData];
    
}

#pragma mark- Time bomb  Selection

-(void)showAndHidePickerView:(BOOL)visibile
{
    
    if (visibile)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            
            
            _viewPickerContainer.frame=CGRectMake(self.view.frame.origin.x+5, 108,self.view.frame.size.width-10,200);
            [_viewPickerContainer setCenter:CGPointMake(self.view.frame.size.width/2.0f,self.view.frame.size.height/2.0f)];
        }];
    }
    else
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            _viewPickerContainer.frame=CGRectMake(self.view.frame.origin.x+5, self.view.frame.size.height,self.view.frame.size.width-10,200);
        }];
    }
}
-(IBAction)btnPickerSelcted:(id)sender
{
    
}
-(IBAction)btnCancelClick:(id)sender
{
    [self showAndHidePickerView:NO];
}


-(IBAction)btnDoneClick:(id)sender

{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    
    NSString *dateString = [formatter stringFromDate:_datePicker.date];
    NSLog(@"Selected Date:%@",dateString);
    
    _noteItems1.note_Time_bomb=dateString;
    
    if (_noteItems1)
    {
        [_dbManager UpdateNoteTimeBomb:[_dbManager getDbFilePath] withNoteItem:_noteItems1];
        
        [[[UIAlertView alloc]initWithTitle:@"Time Bomb" message:@"Time Bomb has been set." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
        [self getAllNotes];
        
        //[_tbl performSelectorOnMainThread:@selector(updateMethod) withObject:nil waitUntilDone:YES];
        
    }else
    {
        [[[UIAlertView alloc]initWithTitle:@"Time Bomb" message:@"Time Bomb has not been set." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }

    
    [self showAndHidePickerView:NO];
    

}

-(void)updateMethod{

    [_tbl reloadData];
    
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result)
    {
        case MFMailComposeResultSaved:
        {
            NSLog(@"MFMailComposeResultSaved");
            
        }
            break;
        case MFMailComposeResultSent:
        {
            NSLog(@"MFMailComposeResultSent");
            
        }
            break;
        case MFMailComposeResultFailed:
        {
            NSLog(@"MFMailComposeResultFailed");
            
        }
            break;
        case MFMailComposeResultCancelled:
        {
            NSLog(@"MFMailComposeResultCancelled");
            
        }
            break;
            
        default:
            break;
    }
    if (error)
    {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            
            break;
        case MessageComposeResultSent:
            
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark-date compare

///If return yes do not fetch the note

- (BOOL)isEndDateIsSmallerThanCurrent:(NSString *)checkEndDate
{
    NSDate* enddate =[self str2date:checkEndDate onlyDate:NO] ;
    
    
    NSDate* currentdate = [NSDate date];
    
    NSString *strCurrendate=[self date2str:currentdate onlyDate:NO];
    currentdate=[self str2date:strCurrendate onlyDate:NO];
    
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    
    else
        return NO;
}

#pragma mark-DrawerDelegate
-(void)revealController:(SWRevealViewController *)revealController drawerStatus:(DRAWERSTATUS)status
{
    
    switch (status) {
        case OPEN:
            
        {
            self.view.userInteractionEnabled = NO;
        }
            break;
        case CLOSE:
            
        {
            self.view.userInteractionEnabled = YES;;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark-Did tileClick

-(void)DidTileSelected:(DBNoteItems*)datamodel withTileIndex:(NSInteger)tileIndex
{
    
    NSLog(@"%@",datamodel.note_Title);
    
    
    _selectedIndexPath=tileIndex;
    
    if (datamodel)
    {
        if ([datamodel.note_lock boolValue]==YES)
        {
            
            //_selectedIndexPath=indexPath.row;
            [self.masterLockVC setNoteItems:datamodel];
            [self.masterLockVC setIsCommingFrom:YES];
            
            [self presentViewController:self.masterLockVC animated:YES completion:^{
                
            }];
            
        }
        else
        {
            //_selectedIndexPath=indexPath.row;
            
            [self performSegueWithIdentifier:@"noteElement" sender:nil];
        }
 
    }
    
}

@end
