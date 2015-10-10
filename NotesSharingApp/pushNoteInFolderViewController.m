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
#import "NoteColorViewController.h"
#import <MessageUI/MessageUI.h>
#import "AddProjectViewController.h"
#import "UIViewController+CWPopup.h"
#import "NSArray+SIAdditions.h"
#import "AddFolderViewController.h"
#import "SWTableViewCell.h"
#import "FolderListPopupViewController.h"
#import "shareOptionPopViewController.h"
#import "SMCThemesSupport.h"
#import "DataManger.h"
#import "masterCodeViewController.h"
#import "DBManager.h"
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>

@interface pushNoteInFolderViewController ()<SlidePopUpViewDelegate,PopUpViewDelegate,PopUpViewDelegate1,SWTableViewCellDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,PopUpNoteColorDelegate,PopUpFolderViewDelegate,masterCodeViewControllerDelagte,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,SWRevealViewControllerDelegate>

{
    MFMailComposeViewController *mailComposer;
    
    NSIndexPath *indexPath2;
    NSString *MyCount;
    NSUInteger elements;
    NSArray *sortedArray;
    UILabel *count;
    UIView *viewLeftnavBar;
}

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
@property(nonatomic,assign)NSUInteger alertInteger;
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


@property(nonatomic,assign)BOOL isLock;

@property (strong, nonatomic) IBOutlet UIButton *searchBtn;

@property(nonatomic,weak)IBOutlet UIView *viewPickerContainer;
@property(nonatomic,weak)IBOutlet UIDatePicker *datePicker;
@property(nonatomic,weak)IBOutlet UIButton *btnDone;
@property(nonatomic,weak)IBOutlet UIButton *btnCancel;
-(IBAction)btnPickerSelcted:(id)sender;
-(IBAction)btnCancelClick:(id)sender;
-(IBAction)btnDoneClick:(id)sender;

@property(nonatomic,assign)NSInteger seletedIndex;

@property(nonatomic,strong)masterCodeViewController *masterLockVC;
@property (nonatomic) UITextField *txtSearch;
@end

@implementation pushNoteInFolderViewController

@synthesize indexPath2,MyCount,elements,sortedArray,count,viewLeftnavBar;


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
    
    
    _seletedIndex=-1;
    
    _txtSearch.tag=400;
    
    [self showAndHidePickerView:NO];
    
    _datePicker.minimumDate=[NSDate date];
    
    _dbManager=[[DBManager alloc]init];
    _arrNotes=[[NSMutableArray alloc]init];
    

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
    
    [self.searchBtn setBackgroundImage:[UIImage imageNamed:@"search icon.png"] forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(searchText:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:self.viewSearch];
    [self.searchView addSubview:self.searchBtn];
    

    self.tbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbl.allowsSelectionDuringEditing=YES;
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    

    //nav bar title color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
    //tab bar image outline color
    _imgView.layer.borderWidth = 1.0f;
    _imgView.layer.borderColor = [[UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]CGColor];
    
    
    _selectedButton=202;
    _selectedIndexPath=0;
    
    
    [self getSlideData];
    [self getLeftBtn];
    [_tbl reloadData];
    
    
    //pop up vc
    _popup=[[SlidePopUpView alloc]initWithFrame:CGRectMake(0.0,self.self.view.frame.size.height,self.view.frame.size.width, 300)];
    _popup.delegate=self;
    [self.view addSubview:_popup];
    
    
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
            if (count.tag == 7)
            {
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


-(void)reloadViewWillApper:(id)sender
{
    [self getFolderNotes];
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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


-(void)dismissView:(OPTIONSELECTED)selectedOption{
    [self dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
    }];
    
}


-(void)dismissFolderView:(CREATEFOLDER)selectOption   WithTag:(NSInteger)selectedOption{
    
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
        
    }];
    
    
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
    
    
    [self getFolderNotes];
    
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
    
    
    UITableViewCell *cellDetail = [tableView dequeueReusableCellWithIdentifier:@"FolderCell"];
    
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
                //cell.timeStamp.text = model.note_Created_Time;
                
                
                NSDate *dateGmt=[self str2date:model.note_Created_Time onlyDate:NO];
                
                NSString *strDate=[self date2strLocal:dateGmt onlyDate:NO];
                
                
                cell.timeStamp.text = [strDate uppercaseString];
                
                
                
               // cell.contentView.backgroundColor=[UIColor si_getColorWithHexString:model.colours];
                cell.contentView.backgroundColor=[UIColor si_getColorWithHexString:model.note_Color_List];
            }
            
            
            if ([model.NOTE_ELEMENT_TYPE  isEqualToString:@"IMAGE"])
            {
                cell.notesDesc.text = @"IMAGE";
                
            }
            else if ([model.NOTE_ELEMENT_TYPE  isEqualToString:@"AUDIO"])
            {
                cell.notesDesc.text = @"AUDIO";
                
            }
            else if ([model.NOTE_ELEMENT_TYPE  isEqualToString:@"TEXT"])
            {
                cell.notesDesc.text = @"TEXT";
            }else{
                
                cell.notesDesc.text=@"";
            }
            
            
            if (![model.note_Time_bomb isEqualToString:@"0"]&&model.note_Time_bomb)
            {
                
                NSLog(@"time bomb set");
                
                
                [cell.bombImage setImage:[UIImage imageNamed:@"redTimeBomb.png"]];
                
            }
            else
            {
                
                //no image
                [cell.bombImage setImage:[UIImage imageNamed:@""]];
                
            }
            
            
            
            if ([model.note_lock isEqualToString:@"1"]&&model.note_lock)
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
        [_tbl reloadData];
    }];
    
}

-(void)folderLabel:(NSString*)sender{
    
    NSLog(@"clicked");
    
    _noteItems1.folder_id=sender;
    
    [_dbManager UpdateNoteMoveTofolder:[_dbManager getDbFilePath] withNoteItem:_noteItems1];
    
    
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
                }else
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
                
                
                //cell.timeStamp.text = [strDate uppercaseString];
                
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Time bomb already set for  this note,It willl expire on :%@",[strDate uppercaseString]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"EDIT",nil];
                
                
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
                
                [self getFolderNotes];
                
            }
                break;
                
                
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
                _noteItems1.folder_id=nil;
                [_dbManager  UpdateNoteMoveTofolder:[_dbManager getDbFilePath] withNoteItem:_noteItems1];
                [_arrNotes removeObjectAtIndex:_seletedIndex];
                
                
                [self getFolderNotes];
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
    
    
    else
    {
        
        [_tbl reloadData];
    }
    
    
    
}
-(void)updateMethod{

    [_tbl reloadData];

}

-(void)viewDidAppear:(BOOL)animated
{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getFolderNotes];
    
}


#pragma mark-get allNote

-(void)getFolderNotes
{
    [_arrNotes removeAllObjects];
    
    _arrAll=[_dbManager getAllRecordsWithFolderId:[_dbManager getDbFilePath] where:_dbnoteID.create_folder_Id];
    
    [ self  updatenotelistfromDb];
    [_tbl  reloadData];
    
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

        
        NSArray *arrNoteElement=[_dbManager getAllNoteElementWithNote_Id:[_dbManager getDbFilePath] where:noteItem.note_Id];
        DBNoteItems *itemsNote=[arrNoteElement si_objectOrNilAtIndex:0];
        
        if (itemsNote)
        {
            model.noteType=itemsNote.NOTE_ELEMENT_TYPE;
            noteItem.NOTE_ELEMENT_TYPE=itemsNote.NOTE_ELEMENT_TYPE;
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
    //[self showAndHidePickerView:NO];
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
        
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Time Bomb" message:@"Time Bomb has been set." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        [self getFolderNotes];
        
        ///[_tbl performSelectorOnMainThread:@selector(updateMethod) withObject:nil waitUntilDone:YES];
        
        
    }else
    {
        [[[UIAlertView alloc]initWithTitle:@"Time Bomb" message:@"Time Bomb has not been set." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
    
    [self showAndHidePickerView:NO];
    
   // [_tbl reloadData];
    
 
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
            self.view.userInteractionEnabled = YES;
        }
            break;
            
        default:
            break;
    }
}

@end
