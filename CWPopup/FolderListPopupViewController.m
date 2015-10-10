//
//  FolderListPopupViewController.m
//  NoteShare
//
//  Created by Heba khan on 16/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "FolderListPopupViewController.h"
#import "UIViewController+CWPopup.h"
#import "DBManager.h"

@interface FolderListPopupViewController ()
@property(nonatomic,strong)DBManager *dbmanager;
@end

@implementation FolderListPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     _dbmanager=[[DBManager alloc]init];
#pragma mark-get allNote
    _arrFolder=[_dbmanager getRecordsFolder:[_dbmanager getDbFilePathFolder]];
    
    NSLog(@"%@",_arrFolder);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrFolder.count;
    
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    DBNoteItems *dbNote =[_arrFolder objectAtIndex:indexPath.row];
    
    cell.textLabel.text=dbNote.folder_Title;
    cell.textLabel.font=[UIFont systemFontOfSize:15 weight:0];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DBNoteItems *dbNote =[_arrFolder objectAtIndex:indexPath.row];
    _folderStr=dbNote.create_folder_Id;

    
    if ([_delegate respondsToSelector:@selector(dismissolderListTable:)])
    {
        [_delegate dismissolderListTable:folderSelected];
        
    }
    
    [_delegate dismissolderListTable:folderList];
    [self.delegate folderLabel:_folderStr];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closePopup:(id)sender {
    
    [_delegate dismissolderListTable:folderList];
}
@end
