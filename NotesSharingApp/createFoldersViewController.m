//
//  createFoldersViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 16/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "createFoldersViewController.h"
#import "FolderTableViewCell.h"
#import "FolderGridCell.h"
#import "SWRevealViewController.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"
#import "NSArray+SIAdditions.h"
#import "UIColor+SIAdditions.h"
#import "customAlertBoxViewController.h"
#import "UIViewController+CWPopup.h"
#import "AddFolderViewController.h"
#import "pushNoteInFolderViewController.h"

#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"
#import "SMCThemesSupport.h"
#import "DataManger.h"

#import "DBManager.h"

@interface createFoldersViewController ()<SlidePopUpViewDelegate,PopUpViewDelegate1,UIAlertViewDelegate,SWRevealViewControllerDelegate>
{

    NSIndexPath *indexPath2;
    NSString *MyCount;
    NSUInteger elements;
    NSArray *sortedArray;
    UILabel *count;
    UIView *viewLeftnavBar;
    UIButton *btn;

}

@property (nonatomic,assign) NSInteger temp;
@property (nonatomic,assign) NSInteger pop;
@property(nonatomic,assign)NSInteger selectedButton;

@property(nonatomic,strong)UIActionSheet *actionSheet1;
@property(nonatomic,strong)UIActionSheet *actionSheet2;
@property (nonatomic, strong) NSMutableArray *cellSizes;
@property (nonatomic, strong) SlidePopUpView *popup;


//define global array
@property (nonatomic,strong)NSMutableArray *viewArr;
@property (nonatomic,strong)NSMutableArray *sortArr;
@property (nonatomic,strong)NSMutableArray *arrNotes;

@property (nonatomic,strong)NSArray *colorArr;
@property (nonatomic,strong) NSMutableArray *rightUtilityButtons ;


@property(nonatomic,strong)DBManager *dbmanager;
@property(nonatomic,strong)NSArray *arrAll;
@property(nonatomic,strong)NSArray *arrAll1;

@property(nonatomic)NSInteger selectedIndexPath;
@property(nonatomic,strong)NSIndexPath *indexPath1;
@property(nonatomic,strong)NSString *MyCount;
@property(nonatomic,strong)UILabel *count;

@property (strong, nonatomic) IBOutlet UITextField *viewSearch;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property(nonatomic,strong)UIView *searchView;
@property (nonatomic) UITextField *txtSearch;



@end

@implementation createFoldersViewController

@synthesize indexPath1,MyCount,count;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewArr=[[NSMutableArray alloc]init];
    _sortArr=[[NSMutableArray alloc]init];
    _arrNotes=[[NSMutableArray alloc]init];
    _colorArr=[[NSArray alloc]init];
    
    
    
    
    _dbmanager=[[DBManager alloc]init];
    
    [_dbmanager createDbANdTableFolder];
    
    [self getFolderdata];
    
#pragma mark-DeleteNote
    

    _colorArr=[NSArray arrayWithObjects:@"#ffffff",@"#FF2C08",@"#FFFF00",@"#2C00E6",@"#FFC6E6",@"#C03067",@"#996633",@"#00FFFF",@"#FF00FF",@"#7F007F",@"#01A2FF",@"#00FF00",@"#E4EBAD",@"#D8A9E8",nil];
    
    
    [self getSlideData];
    
    
    self.tbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //sidebar menu open
    SWRevealViewController *revealController = [self revealViewController];
    
    revealController.delegate=self;
    
    [self getLeftBtn];
    
    //nav bar title color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
    //tab bar image outline color
    
    _imgView.layer.borderWidth = 1.0f;
    _imgView.layer.borderColor = [[UIColor colorWithRed:(246/255.0) green:(65/255.0) blue:(79/255.0) alpha:1]CGColor];
    
    _selectedButton=202;
    [_tbl reloadData];
    
    self.viewCollectionview.hidden=YES;
    
    [self.viewCollectionview addSubview:self.collectionView];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    
    
    //pop up
    
    _popup=[[SlidePopUpView alloc]initWithFrame:CGRectMake(0.0,self.self.view.frame.size.height,self.view.frame.size.width, 300)];
    _popup.delegate=self;
    
    [self.view addSubview:_popup];
    
    
    _selectedIndexPath=0;
    
    
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
    
    
}

-(void)searchText:(id)sender{
    
    _arrAll=[NSMutableArray arrayWithArray:[_dbmanager getRecordsWithSearch:[_dbmanager getDbFilePath] searchText:self.viewSearch.text]];
    
    
    //[self getFolderdata];
    
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    
    _arrAll=[NSMutableArray arrayWithArray:[_dbmanager getRecordsWithSearchFolder:[_dbmanager getDbFilePathFolder] searchText:theTextField.text]];
    
    [self updatenotelistfromDb];
    
    [self.tbl reloadData];
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    
    _arrAll=[NSMutableArray arrayWithArray:[_dbmanager getRecordsWithSearch:[_dbmanager getDbFilePath] searchText:textView.text]];
    //[self getFolderdata];
    
    
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

-(void)updatenotelistfromDb{
    
#pragma mark-Note list detail
    
    [_arrNotes removeAllObjects];
    
    NSMutableArray *arrData=[[NSMutableArray alloc]init];
    
    
    
    for (DBNoteItems *noteItem in _arrAll)
    {
        
        SlideDataModel *model=[[SlideDataModel alloc]init];
        model.cellName=noteItem.folder_Title;
        model.cellId= noteItem.create_folder_Id.integerValue;
        
        
        
        model.modifiedtime=noteItem.folder_Modified_Time;
        model.createdtime=noteItem.folder_Created_Time;
        
        
            
            [_arrNotes addObject:model];
            [arrData addObject:noteItem];

        
    }
    
    
    MyCount=[NSString stringWithFormat:@"FOLDER (%i)",(int)_arrNotes.count];
    _arrAll=[[NSMutableArray alloc]initWithArray:arrData];
    
    [_tbl reloadData];
}



-(void)getFolderdata
{
    
    [_arrNotes removeAllObjects];
#pragma mark-get allNote
    _arrAll=[_dbmanager getRecordsFolder:[_dbmanager getDbFilePathFolder]];
    
    NSLog(@"%@",_arrAll);
    
    
    
#pragma mark-get all uptaedNote
    
    _arrAll1=[_dbmanager getRecordsFolder:[_dbmanager getDbFilePathFolder]];
    
    for (DBNoteItems *noteItems in _arrAll1)
    {
        NSLog(@"Updated values:{%@ \n  %@ \n %@ \n %@\n %@ \n}",noteItems.create_folder_Id,noteItems.folder_Title,noteItems.folder_Created_Time,noteItems.folder_Deleted,noteItems.folder_Modified_Time);
        
    }
    
    
#pragma mark-Note list detail
    
    
    for (DBNoteItems *noteItem in _arrAll)
    {
        
        SlideDataModel *model=[[SlideDataModel alloc]init];
        model.cellName=noteItem.folder_Title;
        //        model.cellDetail=[dict valueForKey:@"cellDetail"];
        model.cellId= noteItem.create_folder_Id.integerValue;
        //        model.colours=[dict valueForKey:@"colours"];
        model.modifiedtime=noteItem.folder_Modified_Time;
        model.createdtime=noteItem.folder_Created_Time;
        //        model.timebomb=[dict valueForKey:@"timebomb"];
        
        
        [_arrNotes addObject:model];
    }
    
     MyCount=[NSString stringWithFormat:@"FOLDER (%i)",(int)_arrNotes.count];
    [_tbl reloadData];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)getLeftBtn{
    
    UIView *viewLeftNavBar=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0,40.0, 40)];
    viewLeftNavBar.backgroundColor=[UIColor clearColor];
    
    UIButton *Btn=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 5.0, 30, 30)];
    // Btn.backgroundColor = [UIColor yellowColor];
    
    Btn.imageView.image=[UIImage imageNamed:@"sidebarIcon40x40.png"];
    
    [Btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"sidebarIcon40x40.png"]]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(sideBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewLeftNavBar addSubview:Btn];
    
    UIImageView *Btn2=[[UIImageView alloc]initWithFrame:CGRectMake(40.0, 10.0, 90, 20)];
    [Btn2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ns_logo.png"]]];
    [viewLeftNavBar addSubview:Btn2];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:viewLeftNavBar];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
}

-(IBAction)sideBarBtn:(id)sender{
    
    [[self revealViewController ]revealToggleAnimated:YES];
    
}

-(void)getSlideData{
    
    
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
    
    
    
#pragma mark-Note list detail

    
}

- (UICollectionView *)collectionView {
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
            
            // CGSize size = CGSizeMake(arc4random() % 50 + 50, arc4random() % 50 + 50);
            
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
    
    _selectedIndexPath=indexPath.row;
    DBNoteItems *items=[_arrAll si_objectOrNilAtIndex:indexPath.row];
    
   NSArray* arrData=[_dbmanager getAllRecordsWithFolderId:[_dbmanager getDbFilePath] where:items.create_folder_Id];
    
    
    
    [self performSegueWithIdentifier:@"folderPushNoteElement" sender:nil];

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destinationVc=segue.destinationViewController;
    
    if ([destinationVc isKindOfClass:[pushNoteInFolderViewController class]]
        )
    {
        DBNoteItems *noteItem=[_arrAll si_objectOrNilAtIndex:_selectedIndexPath];
        NSLog(@"DBNOTEITEM = %@,%@",noteItem.folder_Title,noteItem.create_folder_Id);
        
        pushNoteInFolderViewController *addProjectViewController=(pushNoteInFolderViewController*)destinationVc;
        [addProjectViewController setDbnoteID:noteItem];
        
    }
    
    
}


-(void)dismissFolderView:(CREATEFOLDER)selectOption{

    [self dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
    }];


}

-(void)dismissView:(OPTIONSELECTED)selectedOption WithTag:(NSInteger)selectedOption
{
    [self dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
    }];
    
    NSString *strcolor=[_colorArr si_objectOrNilAtIndex:selectedOption];
     SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:_selectedIndexPath];
    model.colours=strcolor;
    [_tbl reloadData];
    
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
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Folder title" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Cancel",nil];
    alert.delegate=self;
    alert.tag=2000;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Folder title here";
    [alert show];

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
    
    if (alertView.tag==2000) {
        
    
    
    switch (buttonIndex)
    {
        case 0:
        {
            
           
             NSString *strTitle=[alertView textFieldAtIndex:0].text;
           
           
            
             if (![strTitle isEqualToString:@""]) {
                
                NSString *strCreateTime=[self date2str:[NSDate date] onlyDate:NO];
#pragma mark-insert note
            
            int success= [_dbmanager insert:[_dbmanager getDbFilePathFolder] withName:strTitle folder_color:@"ffffff" folder_created_time:strCreateTime folder_modified_time:strCreateTime folder_time_bomb:0 folder_reminder_time:strCreateTime user_id:[[DataManger sharedmanager] getUserId] note_id:@"" note_element:@"" server_key:@"" ];
            
            if (success==0)
            {
                
                
               
                    
                    NSLog(@"Folder created successfully");
                    
                    NSArray *arrItems=[_dbmanager getRecordsFolder:[_dbmanager getDbFilePathFolder] where:strTitle];
                    DBNoteItems *noteItems=[arrItems si_objectOrNilAtIndex:0];
                    
                    NSLog(@"{%@ \n  %@ \n %@\n}",noteItems.create_folder_Id,noteItems.folder_Title,noteItems.folder_Created_Time);
                    
                    
                    
                    for (DBNoteItems *noteItem in arrItems)
                    {
                        
                        SlideDataModel *model=[[SlideDataModel alloc]init];
                        
                        model.cellName=noteItem.folder_Title;
                        //        model.cellDetail=[dict valueForKey:@"cellDetail"];
                        model.cellId= noteItem.create_folder_Id.integerValue;
                        //        model.colours=[dict valueForKey:@"colours"];
                        model.modifiedtime=noteItem.folder_Modified_Time;
                        model.createdtime=noteItem.folder_Created_Time;
                        [_arrNotes addObject:model];
                    }
                    [_tbl  reloadData];
                
                
            }
                
                
            }
                
                else//alert error
                {
                    
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Field cannot be blank" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                    [alert show];
                    [_tbl reloadData];
                    
                }
            
        }
            break;
        case 1:
        {
            NSLog(@"1");//no
        }
            break;
            
        default:
            break;
            }
        
            
}
    
    else if (alertView.tag==3000)
    {
    
        switch (buttonIndex) {
            
    case 0:
        {
            
            //cancel
            break;
        }
    case 1:
        {

                [_dbmanager deleteFolder:[_dbmanager getDbFilePathFolder] withNoteItem:[NSString stringWithFormat:@"%li",(long)btn.tag]];
            
                [self getFolderdata];
                [_tbl reloadData];
            
        break;
        }

    }
    }
    
    
    else{

        [_tbl reloadData];
    
    }
    
    
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
            [_tbl reloadData];
            
            
        }
            break;
        case 12:
        {
            
            _viewCollectionview.hidden=YES;
            _selectedButton=202;
            [_tbl reloadData];
            
            
        }
            break;
        case 13:
        {
            
            _viewCollectionview.hidden=YES;
            
            _selectedButton=203;
            [_tbl reloadData];
            
            
        }
            break;
        case 14:
        {
            
            
            _viewCollectionview.hidden=NO;
            _selectedButton=204;
            [_tbl reloadData];
            
        }
            break;
        case 15:
        {
            
            
        }
            break;
            
        case 21:
        {
            
            
            NSSortDescriptor *sortDescriptor =
            [NSSortDescriptor sortDescriptorWithKey:@"cellName"
                                          ascending:YES
                                           selector:@selector(caseInsensitiveCompare:)];
            NSArray *arr=[_arrNotes sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            _arrNotes=[NSMutableArray arrayWithArray:arr];
            
            
            [_tbl reloadData];
            
        }
            break;
            
        case 22:
        {
            
            
            NSSortDescriptor *sortDescriptor =
            [NSSortDescriptor sortDescriptorWithKey:@"colours"
                                          ascending:YES
                                           selector:@selector(caseInsensitiveCompare:)];
            NSArray *arr=[_arrNotes sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            _arrNotes=[NSMutableArray arrayWithArray:arr];
            
            
            [_tbl reloadData];
            
        }
            break;
            
        default:
            break;
    }
    [self hideSheet];
    [_tbl setContentOffset:CGPointMake(0, 0)];
}

-(void)hideSheet{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        _popup.frame=CGRectMake(0.0,self.self.view.frame.size.height,self.view.frame.size.width, 300);
        _popup.backgroundColor=[UIColor clearColor];
        [_popup layoutSubviews];
    }];
}

-(void)showSheeet{
    
    
    if (_pop==1) {
        [UIView animateWithDuration:0.2 animations:^{
            
            
            _popup.frame=CGRectMake(0.0,self.self.view.frame.size.height-300,self.view.frame.size.width, 300);
            _popup.backgroundColor=[UIColor clearColor];
            [_popup layoutSubviews];
        }];
    }
    else if (_pop==2)
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            
            _popup.frame=CGRectMake(0.0,self.self.view.frame.size.height-230,self.view.frame.size.width, 300);
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
                
                [_tbl reloadData];
            }
                break;
                
            case 1:
                //color
            {
                // _selectedButton=102;
            }
                break;
                
            case 2:
                //created time
            {
                //_selectedButton=103;
            }
                break;
            case 3:
                //Modified time
            {
                //_selectedButton=104;
            }
                break;
            case 4:
                //reminder time
            {
                //_selectedButton=105;
            }
                break;
            case 5:
                //Time bomb
            {
                //_selectedButton=106;
            }
                break;
                
                
            case 6:
                //Cancel Button Clicked
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
            if ([tableView isEditing])
                return [_arrNotes count] + 1;
            else
            {
            return _arrNotes.count;
            }
        }
            break;
        case 202:
        {
            if ([tableView isEditing])
                return [_arrNotes count] + 1;
            else
            {
                return _arrNotes.count;
            }
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
    
    
    //UITableViewCell *cellDetail = [tableView dequeueReusableCellWithIdentifier:@"FolderCell"];
    
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"FolderCell"];
    
  
    UITableViewCell *cellGrid = [tableView dequeueReusableCellWithIdentifier:@"FolderGridCell"];
    
    //view
    switch (_selectedButton)
    {
            
        case 201:
            
        {
            //list
            
            FolderTableViewCell *cell=(FolderTableViewCell*)cell1;
            
            if (cell == nil) {
                cell = [[FolderTableViewCell alloc] init];
            }
            
            cell.shareBtn.hidden=YES;
            cell.deleteBtn.hidden=YES;
            
            SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:indexPath.row];
            
            
            UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
            myBackView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(119/255.0) blue:(121/255.0) alpha:0.5];
            cell.selectedBackgroundView = myBackView;
            NSString *firstCapChar = [[model.cellName substringToIndex:1] capitalizedString];
            NSString *cappedString = [model.cellName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
            cell.nameOfFolder.text = cappedString;
            cell.notesDesc.text =@"";
            cell.timeStamp.text =@"";
            cell.contentView.backgroundColor=[UIColor si_getColorWithHexString:model.colours];
            return cell;
            
            
            
        }
            break;
        case 202:
            
        {
            //list detail
            
            
            FolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FolderCell"];
            
            
            if (cell == nil) {
                cell = [[FolderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FolderCell"];
            }

            
            
            cell.shareBtn.hidden=YES;
            cell.deleteBtn.hidden=NO;
            
            
            
            SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:indexPath.row];
            
            UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
            myBackView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(119/255.0) blue:(121/255.0) alpha:0.5];
            
            
            cell.selectedBackgroundView = myBackView;
            NSString *firstCapChar = [[model.cellName substringToIndex:1] capitalizedString];
            NSString *cappedString = [model.cellName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
            cell.nameOfFolder.text = cappedString;
            cell.notesDesc.text = model.cellDetail;
            //cell.timeStamp.text = model.createdtime;
            
            
            
            NSDate *dateGmt=[self str2date:model.createdtime onlyDate:NO];
            
            NSString *strDate=[self date2strLocal:dateGmt onlyDate:NO];
            
            cell.timeStamp.text=[strDate uppercaseString];

            
            cell.contentView.backgroundColor=[UIColor si_getColorWithHexString:model.colours];
            
            cell.deleteBtn.tag=model.cellId;
            
            [cell.deleteBtn addTarget:self action:@selector(deleteFolder:) forControlEvents:UIControlEventTouchUpInside];
            

            
            return cell;
            
        }
            break;
        case 203:
            
        {
            
            
            NSUInteger convertedIndex=indexPath.row*2;
            //grid
            
            FolderGridCell *cell=(FolderGridCell*)cellGrid;
            
            if (cell == nil) {
                cell = [[FolderGridCell alloc] init];
                
                cell.view1.frame=CGRectMake(2.0, 1.0,(self.tbl.frame.size.width/2.0f)-2, 118);
                cell.view1.clipsToBounds=YES;
                
                cell.view2.frame=CGRectMake((self.tbl.frame.size.width/2.0f)+1, 1.0,self.tbl.frame.size.width/2.0f-2, 118);
                cell.view2.clipsToBounds=YES;
            }
            
            UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
            myBackView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(119/255.0) blue:(121/255.0) alpha:0.5];
            cell.selectedBackgroundView = myBackView;
            
            
            
            
            if (convertedIndex < _arrNotes.count)
                
            {
                SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:convertedIndex];
                
                cell.view1.hidden=NO;
                NSString *firstCapChar = [[model.cellName substringToIndex:1] capitalizedString];
                NSString *cappedString = [model.cellName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
                cell.lblDetail1.text = cappedString;
                cell.lblTitle1.text=model.cellDetail;
                cell.view1.backgroundColor=[UIColor si_getColorWithHexString:model.colours];
                //cell.timeLbl1.text=model.createdtime;
                
                
                NSDate *dateGmt=[self str2date:model.createdtime onlyDate:NO];
                
                NSString *strDate=[self date2strLocal:dateGmt onlyDate:NO];
                
                cell.timeLbl1.text=[strDate uppercaseString];
                
                
            }
            
            else{
                cell.view1.hidden=YES;
            }
            
            if (convertedIndex+1 < _arrNotes.count)
                
            {
                SlideDataModel *model=[_arrNotes si_objectOrNilAtIndex:convertedIndex+1];
                
                cell.view2.hidden=NO;
                NSString *firstCapChar = [[model.cellName substringToIndex:1] capitalizedString];
                NSString *cappedString = [model.cellName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
                cell.lblDetail2.text = cappedString;
                
                cell.lblTitle2.text=model.cellDetail;
                cell.view2.backgroundColor=[UIColor si_getColorWithHexString:model.colours];
               // cell.timeLbl2.text=model.createdtime;
                
                NSDate *dateGmt=[self str2date:model.createdtime onlyDate:NO];
                
                NSString *strDate=[self date2strLocal:dateGmt onlyDate:NO];
                
                cell.timeLbl2.text=[strDate uppercaseString];

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
            //list
            
            return 44;
            
        }
            break;
        case 202:
            
        {
            //list detail
            return 100;
            
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
    
    return 0;
    
}

-(IBAction)deleteFolder:(id)sender
{
    
    btn=(UIButton*)sender;
    
    NSLog(@"Folder Id Is:%ld",(long)btn
          .tag);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this note?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK",nil];
    [alert show];
    alert.tag=3000;
    
    
    

    
}

- (IBAction)sideBar:(id)sender {
}

-(void)viewWillAppear:(BOOL)animated{
    
        
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
