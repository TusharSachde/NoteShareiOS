//
//  pushNoteInFolderViewController.m
//  NoteShare
//
//  Created by Heba khan on 16/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "pushNoteInFolderViewController.h"


#import "FolderTableViewCell.h"
#import "FolderGridCell.h"
#import "SWRevealViewController.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"
#import "NSArray+SIAdditions.h"
#import "UIColor+SIAdditions.h"
//#import "customAlertBoxViewController.h"
#import "NoteColorViewController.h"

#import "AddProjectViewController.h"

#import "UIViewController+CWPopup.h"
#import "NSArray+SIAdditions.h"
#import "AddFolderViewController.h"

#import "SWTableViewCell.h"

#import "FolderListPopupViewController.h"

#import "shareOptionPopViewController.h"

//#define CELL_COUNT 30
//#define CELL_IDENTIFIER @"WaterfallCell"
//#define HEADER_IDENTIFIER @"WaterfallHeader"
//#define FOOTER_IDENTIFIER @"WaterfallFooter"
#import "SMCThemesSupport.h"


#import "DBManager.h"

@interface pushNoteInFolderViewController ()<SlidePopUpViewDelegate,PopUpViewDelegate,PopUpViewDelegate1,SWTableViewCellDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,PopUpNoteColorDelegate,PopUpFolderViewDelegate>

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



//define global array
@property (nonatomic,strong)NSMutableArray *viewArr;
@property (nonatomic,strong)NSMutableArray *sortArr;
@property (nonatomic,strong)NSMutableArray *arrNotes;

@property (nonatomic,strong)NSArray *colorArr;
@property (nonatomic,strong) NSMutableArray *rightUtilityButtons ;
@property(nonatomic,strong)DBManager *dbManager;
@property(nonatomic,strong)NSArray *arrAll;
@property(nonatomic,strong)NSArray *arrAll1;


@property(nonatomic,strong)NSString *bgColor;


@property(nonatomic,strong)NSIndexPath *indexPath2;
@property(nonatomic,strong)NSString *MyCount;
@property(nonatomic,assign)NSUInteger elements;
@property(nonatomic,strong)NSArray *sortedArray;
@property(nonatomic,strong)UILabel *count;
@property(nonatomic,strong)UIView *viewLeftnavBar;



@end

@implementation pushNoteInFolderViewController

@synthesize indexPath2,MyCount,elements,sortedArray,count,viewLeftnavBar;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _dbManager=[[DBManager alloc]init];
    
     _arrAll=[_dbManager getAllRecordsWithFolderId:[_dbManager getDbFilePath] where:_dbnoteID.create_folder_Id];

    viewLeftnavBar=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0,40.0, 40)];
    viewLeftnavBar.backgroundColor=[UIColor clearColor];
    
    
    // tableview
    self.tbl.delegate = self;
    
    
    // search view
    self.searchView = [[UIView alloc]initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, 40)];
    
    
    [self.tbl addSubview:self.searchView];
    
    self.viewSearch = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.viewSearch.placeholder=@"Search Text...";
    [self.searchView addSubview:self.viewSearch];
    
    
   
    _arrNotes=[[NSMutableArray alloc]init];
   
    
    [self getSlideData];
    
    
    self.tbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbl.allowsSelectionDuringEditing=YES;
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    [self getLeftBtn];
   // [self getSaveBtn];
    
    //nav bar title color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
    //tab bar image outline color
    _imgView.layer.borderWidth = 1.0f;
    _imgView.layer.borderColor = [[UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]CGColor];
    
    _selectedButton=202;
    _selectedIndexPath=0;
    
    [_tbl reloadData];
    
   // self.viewCollectionview.hidden=YES;
  //  [self.viewCollectionview addSubview:self.collectionView];
  //  [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    //pop up vc
    _popup=[[SlidePopUpView alloc]initWithFrame:CGRectMake(0.0,self.self.view.frame.size.height,self.view.frame.size.width, 300)];
    _popup.delegate=self;
    [self.view addSubview:_popup];
    
    
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
        
        
        [UIView commitAnimations];
        
        
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getLeftBtn{
    
    UIButton *Btn=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 5.0, 30, 30)];
    
    Btn.imageView.image=[UIImage imageNamed:@"sidebarIcon40x40.png"];
    
    [Btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"backnew.png"]]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(sideBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftnavBar addSubview:Btn];
    
    UIImageView *Btn2=[[UIImageView alloc]initWithFrame:CGRectMake(40.0, 10.0, 80, 20)];
    [Btn2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ns_logo.png"]]];
    [viewLeftnavBar addSubview:Btn2];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:viewLeftnavBar];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
}

-(IBAction)sideBarBtn:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedIndexPath=indexPath.row;
    
    [self performSegueWithIdentifier:@"noteElement" sender:nil];

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destinationVc=segue.destinationViewController;
    
    if ([destinationVc isKindOfClass:[AddProjectViewController class]]
        )
    {
        DBNoteItems *noteItem=[_arrAll si_objectOrNilAtIndex:_selectedIndexPath];
        NSLog(@"DBNOTEITEM = %@,%@",noteItem.note_Title,noteItem.note_Color);
        
        AddProjectViewController *addProjectViewController=(AddProjectViewController*)destinationVc;
        [addProjectViewController setDbnotelistItem:noteItem];
        
    }
    
    
}

-(void)dismissView:(OPTIONSELECTED)selectedOption{
    [self dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
    }];
    
}


-(void)dismissFolderView:(CREATEFOLDER)selectOption   WithTag:(NSInteger)selectedOption{
    
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
        
    }];
    
    
}


#pragma TableDetails

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    switch (_selectedButton)
    {
        
        case 202:
        {
            return _arrAll.count;
        }
            break;
            
                default:
            return 0;
            break;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"FolderCell"];
    
    UITableViewCell *cellDetail = [tableView dequeueReusableCellWithIdentifier:@"FolderCell"];
    
//    UITableViewCell *cellGrid = [tableView dequeueReusableCellWithIdentifier:@"FolderGridCell"];
    
    
    //view
    switch (_selectedButton)
    {
            

        case 202:
            
        {
            //list detail
            
            
            FolderTableViewCell *cell=(FolderTableViewCell*)cellDetail;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (cell == nil) {
                cell = [[FolderTableViewCell alloc] init];
            }
            
            
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"deleteTry55.png"] withtag:indexPath.row+100];
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"newLock55.png"] withtag:indexPath.row+100];
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"bombTry55.png"] withtag:indexPath.row];
            
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]
                                                         icon:[UIImage imageNamed:@"shareTry55.png"] withtag:indexPath.row+100];
            
            
            cell.rightUtilityButtons = rightUtilityButtons;
            cell.delegate = self;
            
            
            
            
            
            
            //these are not right utility buttons..They are ui images not required
            cell.shareBtn.hidden=NO;
            cell.deleteBtn.hidden=NO;
            
            DBNoteItems *model=[_arrAll si_objectOrNilAtIndex:indexPath.row];
            
            UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
            myBackView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(119/255.0) blue:(121/255.0) alpha:0.5];
            
            cell.selectedBackgroundView = myBackView;
            
            if (model.note_Title.length>0)
            {
                NSString *firstCapChar = [[model.note_Title substringToIndex:1] capitalizedString];
                NSString *cappedString = [model.note_Title stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
                
                cell.nameOfFolder.text = cappedString;
                //cell.notesDesc.text = model.cellDetail;
                cell.timeStamp.text = model.note_Created_Time;
               // cell.contentView.backgroundColor=[UIColor si_getColorWithHexString:model.colours];
                cell.contentView.backgroundColor=[UIColor si_getColorWithHexString:model.note_Color_List];
            }
            
            
            
            
            return cell;
            
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
        
        case 202:
            
        {
            //list detail
            return 100;
            
        }
            break;
            
        default:
            break;
    }
    
    return 33;
    
}

- (IBAction)sideBar:(id)sender {
}

-(void)dismissNoteColor:(selectNoteColor)selectedNoteOption   WithTag:(NSInteger)selectedNoteOption{
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
    
    
    NSLog(@"%@",sender);
}

-(void)backgroundNoteColor:(id)sender{
    
    //    [self.tbl setBackgroundColor: [UIColor si_getColorWithHexString:((NoteColorViewController*)sender).colorString]];
    
    _bgColor=((NoteColorViewController*)sender).colorString;
    
    NSString *strcolor=_bgColor;
    SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:_selectedIndexPath];
    model.colours=strcolor;
    
    //[_arrNotes removeAllObjects];
    
    [_dbManager UpdateNoteColorOnList:[_dbManager getDbFilePath] withNoteItem:strcolor note_id:[NSString stringWithFormat:@"%i",(int)model.cellId]];
    
    
    
    
    //        for (DBNoteItems *noteItem in _arrAll)
    //        {
    //            noteItem.note_Color=strcolor;
    //
    //            SlideDataModel *model=[[SlideDataModel alloc]init];
    //            model.cellName=noteItem.note_Title;
    //            model.cellId= noteItem.note_Id.integerValue;
    //
    //            if ([noteItem.note_Color isEqualToString:@"(null)"]) {
    //                model.colours=@"#ffffff";
    //            }
    //            else
    //            {
    //                model.colours=noteItem.note_Color;
    //            }
    //
    //            model.modifiedtime=noteItem.note_Modified_Time;
    //            model.createdtime=noteItem.note_Created_Time;
    //
    //            [_arrNotes addObject:model];
    //
    //        }
    
    
    
    MyCount=[NSString stringWithFormat:@"NOTES (%i)",(int)_arrNotes.count];
    [_tbl reloadData];
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index withCellIndex:(NSInteger)cellIndex{
    
    _noteItems1 =   [_arrAll si_objectOrNilAtIndex:cellIndex];
    
    switch (index) {
            
        case 0:
        {
            
            [_dbManager deleteNote:[_dbManager getDbFilePath] withNoteItem:_noteItems1];
            [_arrNotes removeObjectAtIndex:cellIndex];
            [_tbl reloadData];
            
            break;
        }
        case 1:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Lock" message:@"Lock clicked" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            
            NSLog(@"$$$$$$$$$$$$$$$$$ = %ld",(long)_swipeButtonindexPath);
            
            break;
        }
            
        case 2:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TimeBomb" message:@"TimeBomb clicked" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            break;
        }
            
        case 3:
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

-(void)setDbnotelistItem:(DBNoteItems*)dbnoteID{
    
    _dbnoteID=dbnoteID;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
#pragma mark-get allNote
    
    [_tbl  reloadData];
    
}

@end
