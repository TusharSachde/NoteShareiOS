//
//  DBManager.h
//  NoteShare
//
//  Created by Heba khan on 02/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBNoteItems : NSObject
{
    
    
    
    
}
//note Items
@property(nonatomic,strong)NSString *note_Id;
@property(nonatomic,strong)NSString *note_Title;
@property(nonatomic,strong)NSString *note_Created_Time;
@property(nonatomic,strong)NSString *note_Modified_Time;
@property(nonatomic,strong)NSString *note_Deleted;
@property(nonatomic,strong)NSString *note_Element;
@property(nonatomic,strong)NSString *note_Color;
@property(nonatomic,strong)NSString *note_Color_List;
@property(nonatomic,strong)NSString *folder_id;
@property(nonatomic,strong)NSString *note_Time_bomb;
@property(nonatomic,strong)NSString *note_lock;
@property(nonatomic,strong)NSString *note_Reminder;

//folder Items
@property(nonatomic,strong)NSString *create_folder_Id;
@property(nonatomic,strong)NSString *folder_Title;
@property(nonatomic,strong)NSString *folder_Created_Time;
@property(nonatomic,strong)NSString *folder_Modified_Time;
@property(nonatomic,strong)NSString *folder_Deleted;
//@property(nonatomic,strong)NSString *note_Element;

//NOTE_ELEMENT_ID INTEGER PRIMARY KEY AUTOINCREMENT , NOTE_ID text, NOTE_ELEMENT_CONTENT text, NOTE_ELEMENT_TYPE


@property(nonatomic,strong)NSString *NOTE_ELEMENT_ID;
@property(nonatomic,strong)NSString *NOTE_ELEMENT_CONTENT;
@property(nonatomic,strong)NSString *NOTE_ELEMENT_TYPE;
@property(nonatomic,strong)NSString *NOTE_ELEMENT_MEDIA_TIME;
@property(nonatomic,strong)NSString *NOTE_ELEMENT_TEXT_HEIGHT;

@end





@interface DBManager : NSObject

{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;


#pragma mark-NEw implementation

-(NSString *) getDbFilePath;

-(void)createDbANdTable;

-(int) createTable:(NSString*) filePath;


-(NSArray *) getRecords:(NSString*) filePath where:(NSString *)whereStmt;


-(NSArray *) getRecords:(NSString*) filePath ;
-(NSArray *) getRecordsWithNote_Id:(NSString*) filePath where:(NSString *)note_id;
-(NSArray *) getAllRecordsWithNote_Id:(NSString*) filePath where:(NSString *)note_id;


//-(int) insert:(NSString *)filePath withName:(NSString*)note_Title color:(NSString*)color
// created_time:(NSString*)created_time modified_time:(NSString*)modified_time time_bomb:(NSInteger)time_bomb reminder_time:(NSString*)reminder_time user_id:(NSString*)user_id folder_id:(NSString*)folder_id note_element:(NSString*)note_element server_key:(NSString*)server_key;

-(int) insert:(NSString *)filePath withName:(NSString*)note_Title color:(NSString*)color
 created_time:(NSString*)created_time modified_time:(NSString*)modified_time time_bomb:(NSInteger)time_bomb reminder_time:(NSString*)reminder_time user_id:(NSString*)user_id folder_id:(NSString*)folder_id note_element:(NSString*)note_element server_key:(NSString*)server_key note_color:(NSString*)note_color;

- (int)UpdateNoteElements:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems;


- (int)UpdateNoteColorOnList:(NSString*)filePath withNoteItem:(NSString*)note_color note_id:(NSString*)note_id;
-(int)deleteNote:(NSString*) filePath withNoteItem:(DBNoteItems*)noteItems;

- (int)UpdateNoteLock:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems;
- (int)UpdateNoteTimeBomb:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems;
- (int)UpdateNoteReminder:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems;
//- (int)UpdateNoteTitle:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems;
- (int)UpdateNoteTitle:(NSString*)filePath withNoteItem:(NSString*)note_title note_id:(NSString*)note_id;
-(int)deleteFolder:(NSString*) filePath withNoteItem:(NSString*)folderId;
#pragma folder methods


-(NSString *) getDbFilePathFolder;

-(void)createDbANdTableFolder;

-(int) createTableFolder:(NSString*) filePath;


-(int) insert:(NSString *)filePath withName:(NSString*)folder_Title folder_color:(NSString*)folder_color
folder_created_time:(NSString*)folder_created_time folder_modified_time:(NSString*)folder_modified_time folder_time_bomb:(NSInteger)folder_time_bomb folder_reminder_time:(NSString*)folder_reminder_time user_id:(NSString*)user_id note_id:(NSString*)note_id note_element:(NSString*)note_element server_key:(NSString*)server_key;


-(NSArray *) getRecordsFolder:(NSString*) filePath;

-(NSArray *) getRecordsFolder:(NSString*) filePath where:(NSString *)whereStmt;

//-(int)deleteFolder:(NSString*) filePath withNoteItem:(DBNoteItems*)noteItems;

- (int)UpdateFolderElements:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems;


- (int)UpdateNoteMoveTofolder:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems;
-(NSArray *)getAllRecordsWithFolderId:(NSString*) filePath where:(NSString *)folder_note_id;
-(NSArray *) getRecordsWithSearch:(NSString*) filePath   searchText:(NSString*)searchString;


-(int) insert:(NSString *)filePath withName:(NSString*)note_ID note_element_content:(NSString*)note_element_content
note_element_type:(NSString*)note_element_type note_element_media_time:(NSString*)note_element_media_time;
-(NSArray *)getAllNoteElementWithNote_Id:(NSString*) filePath where:(NSString *)note_id;
-(int)deleteNoteElement:(NSString*) filePath withNoteItem:(NSString*)noteItems_elementId;
- (int)UpdateTextNoteElementContent:(NSString*)filePath withNoteItem:(NSString*)note_textContent note_Element_id:(NSString*)note_Element_id;

-(NSArray *) getRecordsWithSearchFolder:(NSString*) filePath   searchText:(NSString*)searchString;
-(int) insert:(NSString *)filePath withName:(NSString*)note_default_view note_default_Font:(NSString*)note_default_Font
note_default_Password:(NSString*)note_default_Password note_user_id:(NSString*)note_user_id note_default_color:(NSString*)note_default_color;


-(NSArray *) getSettingRecords:(NSString*) filePath;

- (int)UpdateTextNoteElementContent:(NSString*)filePath withNoteItem:(NSString*)note_textContent note_Element_id:(NSString*)note_Element_id note_Element_height:(NSString*)note_Element_height;

@end
