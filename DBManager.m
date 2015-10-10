//
//  DBManager.m
//  NoteShare
//  Created by Heba khan on 02/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>
#import "DataManger.h"

static NSString *NOTE_ID=@"NOTE_ID";
static NSString *NOTE_TITLE=@"NOTE_TITLE";
static NSString *COLOR=@"COLOR";
static NSString *NOTE_COLOR=@"NOTE_COLOR";
static NSString *CREATED_TIME=@"CREATED_TIME";
static NSString *MODIFIED_TIME=@"MODIFIED_TIME";
static NSString *TIME_BOMB=@"TIME_BOMB";
static NSString *REMINDER_TIME=@"REMINDER_TIME";
static NSString *USER_ID=@"USER_ID";
static NSString *NOTE_ELEMENT=@"NOTE_ELEMENT";
static NSString *SERVER_KEY=@"SERVER_KEY";
static NSString *FOLDER_ID=@"FOLDER_ID";
static NSString *NOTE_DELETE_STATUS=@"NOTE_DELETE_STATUS";
static NSString *NOTE_LOCK=@"NOTE_LOCK";




static NSString *CREATE_FOLDER_ID=@"CREATE_FOLDER_ID";
static NSString *FOLDER_TITLE=@"FOLDER_TITLE";
static NSString *FOLDER_COLOR=@"FOLDER_COLOR";
static NSString *FOLDER_CREATED_TIME=@"FOLDER_CREATED_TIME";
static NSString *FOLDER_MODIFIED_TIME=@"FOLDER_MODIFIED_TIME";
static NSString *FOLDER_TIME_BOMB=@"FOLDER_TIME_BOMB";
static NSString *FOLDER_REMINDER_TIME=@"FOLDER_REMINDER_TIME";
static NSString *FOLDER_DELETE_STATUS=@"FOLDER_DELETE_STATUS";

#pragma mark @ noteShare element
static NSString *NOTE_ELEMENT_ID=@"NOTE_ELEMENT_ID";
static NSString *NOTE_ELEMENT_TYPE=@"NOTE_ELEMENT_TYPE";
static NSString *NOTE_ELEMENT_CONTENT=@"NOTE_ELEMENT_CONTENT";
static NSString *NOTE_ELEMENT_MEDIA_TIME=@"NOTE_ELEMENT_MEDIA_TIME";
static NSString *NOTE_ELEMENT_TEXT_HEIGHT=@"NOTE_ELEMENT_TEXT_HEIGHT";


#pragma mark @ Note Setting
static NSString *NOTE_DEFAULT_VIEW=@"NOTE_DEFAULT_VIEW";
static NSString *NOTE_DEFAULT_FONT=@"NOTE_DEFAULT_FONT";
static NSString *NOTE_DEFAULT_PASSWORD=@"NOTE_DEFAULT_PASSWORD";
static NSString *NOTE_DEFAULT_COLOR=@"NOTE_DEFAULT_COLOR";
static NSString *NOTE_USER_ID=@"NOTE_USER_ID";


@implementation DBNoteItems


@end



static DBManager *sharedInstance = nil;


@implementation DBManager



#pragma mark-New implamentation

-(NSString *) getDbFilePath {
    NSString * docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSLog(@"Db file path:%@",docsPath);
    return [docsPath stringByAppendingPathComponent:@"NoteShareDatabase.db"];
}

-(void)createDbANdTable {
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self getDbFilePath]]) //if the file does not exist
    {
        [self createTable:[self getDbFilePath]];
        [self createNoteElementTable:[self getDbFilePath]];
        [self createSettingTable:[self getDbFilePath]];
        //[self insert:[self getDbFilePath] withName:@"" note_default_Font:@"" note_default_Password:@"" note_user_id:@""];
    }
    
}

-(int) createTable:(NSString*) filePath {
    sqlite3* db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        // char * query ="CREATE TABLE IF NOT EXISTS students ( id INTEGER PRIMARY KEY AUTOINCREMENT, name  TEXT, age INTEGER, marks INTEGER )";
        
        char *query ="create table if not exists NoteShare (NOTE_ID INTEGER PRIMARY KEY AUTOINCREMENT , NOTE_TITLE text, COLOR text, CREATED_TIME text,MODIFIED_TIME text,TIME_BOMB INTEGER,REMINDER_TIME text,USER_ID text,FOLDER_ID INTEGER,NOTE_ELEMENT text,SERVER_KEY text,NOTE_DELETE_STATUS INTEGER,NOTE_COLOR text,NOTE_LOCK text)";
        
        char * errMsg;
        rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,errMsg);
        }
        
        sqlite3_close(db);
    }
    
    return rc;
    
}

-(int) createSettingTable:(NSString*) filePath {
    sqlite3* db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        // char * query ="CREATE TABLE IF NOT EXISTS students ( id INTEGER PRIMARY KEY AUTOINCREMENT, name  TEXT, age INTEGER, marks INTEGER )";
        
        char *query ="create table if not exists NoteShareSetting (NOTE_USER_ID text PRIMARY KEY ,NOTE_DEFAULT_VIEW text, NOTE_DEFAULT_FONT text, NOTE_DEFAULT_PASSWORD text,NOTE_DEFAULT_COLOR text)";
        
        char * errMsg;
        rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,errMsg);
        }
        
        sqlite3_close(db);
    }
    
    return rc;
    
}




#pragma folder database creation

-(NSString *) getDbFilePathFolder {
    NSString * docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    return [docsPath stringByAppendingPathComponent:@"FolderShareDatabase.db"];
}

-(void)createDbANdTableFolder {
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self getDbFilePathFolder]]) //if the file does not exist
    {
        [self createTableFolder:[self getDbFilePathFolder]];
    }
    
}

-(int) createTableFolder:(NSString*) filePath {
    sqlite3* db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        char *query ="create table if not exists FolderShare (CREATE_FOLDER_ID INTEGER PRIMARY KEY AUTOINCREMENT , FOLDER_TITLE text, FOLDER_COLOR text, FOLDER_CREATED_TIME text,FOLDER_MODIFIED_TIME text,FOLDER_TIME_BOMB INTEGER,FOLDER_REMINDER_TIME text,USER_ID text,NOTE_ID INTEGER,NOTE_ELEMENT text,SERVER_KEY text,FOLDER_DELETE_STATUS INTEGER,NOTE_COLOR text,NOTE_LOCK text)";
        
        char * errMsg;
        rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,errMsg);
        }
        
        sqlite3_close(db);
    }
    
    return rc;
    
}




#pragma insert command
-(int) insert:(NSString *)filePath withName:(NSString*)note_default_view note_default_Font:(NSString*)note_default_Font
 note_default_Password:(NSString*)note_default_Password note_user_id:(NSString*)note_user_id note_default_color:(NSString*)note_default_color
{
    
    sqlite3* db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        //  NSString * query  = [NSString
        //stringWithFormat:@"INSERT INTO students (name,age,marks) VALUES (\"%@\",%ld,%ld)",name,(long)age,(long)marks];
        
        NSString *query = [NSString stringWithFormat:@"insert into NoteShareSetting (%@,%@,%@,%@,%@) values (\"%@\",\"%@\", \"%@\",\"%@\",\"%@\")",NOTE_USER_ID,NOTE_DEFAULT_VIEW,NOTE_DEFAULT_FONT,NOTE_DEFAULT_PASSWORD,NOTE_DEFAULT_COLOR,note_user_id,note_default_view,note_default_Font,note_default_Password,note_default_color];
        
        
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}

-(int) insert:(NSString *)filePath withName:(NSString*)note_Title color:(NSString*)color
 created_time:(NSString*)created_time modified_time:(NSString*)modified_time time_bomb:(NSInteger)time_bomb reminder_time:(NSString*)reminder_time user_id:(NSString*)user_id folder_id:(NSString*)folder_id note_element:(NSString*)note_element server_key:(NSString*)server_key note_color:(NSString*)note_color
{
    sqlite3* db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        //  NSString * query  = [NSString
        //stringWithFormat:@"INSERT INTO students (name,age,marks) VALUES (\"%@\",%ld,%ld)",name,(long)age,(long)marks];
        
        NSString *query = [NSString stringWithFormat:@"insert into NoteShare (%@,%@, %@, %@,%@,%@,%@,%@,%@,%@,%@,%@) values (\"%@\",\"%@\", \"%@\", \"%@\", \"%ld\" , \"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\", \"%ld\", \"%@\")",NOTE_TITLE,COLOR,CREATED_TIME,MODIFIED_TIME,TIME_BOMB,REMINDER_TIME,USER_ID,FOLDER_ID,NOTE_ELEMENT,SERVER_KEY,NOTE_DELETE_STATUS,NOTE_COLOR,note_Title,color,created_time,modified_time,(long)time_bomb,reminder_time,user_id,folder_id,note_element,server_key,(long)[@"0" integerValue],note_color];
        
        
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}


-(int) insert:(NSString *)filePath withName:(NSString*)folder_Title folder_color:(NSString*)folder_color
folder_created_time:(NSString*)folder_created_time folder_modified_time:(NSString*)folder_modified_time folder_time_bomb:(NSInteger)folder_time_bomb folder_reminder_time:(NSString*)folder_reminder_time user_id:(NSString*)user_id note_id:(NSString*)note_id note_element:(NSString*)note_element server_key:(NSString*)server_key
{
    sqlite3* db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        //  NSString * query  = [NSString
        //stringWithFormat:@"INSERT INTO students (name,age,marks) VALUES (\"%@\",%ld,%ld)",name,(long)age,(long)marks];
        
        NSString *query = [NSString stringWithFormat:@"insert into FolderShare (%@,%@, %@, %@,%@,%@,%@,%@,%@,%@,%@) values (\"%@\",\"%@\", \"%@\", \"%@\", \"%ld\" , \"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\", \"%ld\")",FOLDER_TITLE,FOLDER_COLOR,FOLDER_CREATED_TIME,FOLDER_MODIFIED_TIME,FOLDER_TIME_BOMB,FOLDER_REMINDER_TIME,USER_ID,NOTE_ID,NOTE_ELEMENT,SERVER_KEY,FOLDER_DELETE_STATUS,folder_Title,folder_color,folder_created_time,folder_modified_time,(long)folder_time_bomb,folder_reminder_time,user_id,note_id,note_element,server_key,(long)[@"0" integerValue]];
        
        
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}




#pragma all get records
//NoteShareSetting



-(NSArray *) getSettingRecords:(NSString*) filePath
{
    NSMutableArray * resultArray =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = [NSString stringWithFormat:@"SELECT * from NoteShareSetting where %@=\"%@\"",NOTE_USER_ID,[[DataManger sharedmanager] getUserId]];
        
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                DBNoteItems *noteItem=[[DBNoteItems alloc]init];
                
                noteItem.note_Title = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(stmt, 1)];
                
                noteItem.note_Created_Time = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(stmt, 2)];
                
                noteItem.note_Id = [[NSString alloc]initWithUTF8String:
                                    (const char *) sqlite3_column_text(stmt, 0)];
                noteItem.note_Deleted = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 3)];
                noteItem.note_Color = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 4)];
                
                [resultArray addObject:noteItem];
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return resultArray;
    
}



-(NSArray *) getRecords:(NSString*) filePath{
    NSMutableArray * resultArray =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = [NSString stringWithFormat:@"SELECT * from NoteShare where %@=\"%@\"",USER_ID,[[DataManger sharedmanager] getUserId]];
        
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                DBNoteItems *noteItem=[[DBNoteItems alloc]init];
                
                noteItem.note_Title = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(stmt, 1)];
                
                noteItem.note_Created_Time = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(stmt, 3)];
                
                noteItem.note_Id = [[NSString alloc]initWithUTF8String:
                                    (const char *) sqlite3_column_text(stmt, 0)];
                noteItem.note_Deleted = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 11)];
                noteItem.note_Modified_Time = [[NSString alloc]initWithUTF8String:
                                               (const char *) sqlite3_column_text(stmt, 4)];
                noteItem.note_Element = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 9)];
                
                noteItem.note_Color = [[NSString alloc]initWithUTF8String:
                                       (const char *) sqlite3_column_text(stmt, 2)];//give index here
                
                noteItem.note_Color_List = [[NSString alloc]initWithUTF8String:
                                            (const char *) sqlite3_column_text(stmt, 12)];//give index here
                
                noteItem.folder_id = [[NSString alloc]initWithUTF8String:
                                      (const char *) sqlite3_column_text(stmt, 8)];//give index here
                
                //NSLog(@"%@",(const char *) sqlite3_column_text(stmt, 13));
                
                if ((const char *) sqlite3_column_text(stmt, 13)!=nil)
                {
                    noteItem.note_lock= [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 13)];
                }
                if ((const char *) sqlite3_column_text(stmt, 5)!=nil)
                {
                    NSString *stringTimebomb= [[NSString alloc]initWithUTF8String:
                                               (const char *) sqlite3_column_text(stmt, 5)];
                    noteItem.note_Time_bomb=stringTimebomb;
                    
                }
                
                if ((const char *) sqlite3_column_text(stmt, 6)!=nil)
                {
                    NSString *stringReminder= [[NSString alloc]initWithUTF8String:
                                               (const char *) sqlite3_column_text(stmt, 6)];
                    noteItem.note_Reminder=stringReminder;
                    
                }
                
                
                
                
                [resultArray addObject:noteItem];
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return resultArray;
    
}






-(NSArray *) getRecordsWithSearch:(NSString*) filePath   searchText:(NSString*)searchString
{
    NSMutableArray * resultArray =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = [NSString  stringWithFormat:@"SELECT * from NoteShare Where %@ LIKE \'%@%%\' ",NOTE_TITLE,searchString];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                DBNoteItems *noteItem=[[DBNoteItems alloc]init];
                
                noteItem.note_Title = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(stmt, 1)];
                
                noteItem.note_Created_Time = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(stmt, 3)];
                
                noteItem.note_Id = [[NSString alloc]initWithUTF8String:
                                    (const char *) sqlite3_column_text(stmt, 0)];
                noteItem.note_Deleted = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 11)];
                noteItem.note_Modified_Time = [[NSString alloc]initWithUTF8String:
                                               (const char *) sqlite3_column_text(stmt, 4)];
                noteItem.note_Element = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 9)];
                
                noteItem.note_Color = [[NSString alloc]initWithUTF8String:
                                       (const char *) sqlite3_column_text(stmt, 2)];//give index here
                
                noteItem.note_Color_List = [[NSString alloc]initWithUTF8String:
                                            (const char *) sqlite3_column_text(stmt, 12)];//give index here
                
                noteItem.folder_id = [[NSString alloc]initWithUTF8String:
                                      (const char *) sqlite3_column_text(stmt, 8)];//give index here
                
                //NSLog(@"%@",(const char *) sqlite3_column_text(stmt, 13));
                
                if ((const char *) sqlite3_column_text(stmt, 13)!=nil)
                {
                    noteItem.note_lock= [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 13)];
                }
                if ((const char *) sqlite3_column_text(stmt, 5)!=nil)
                {
                    NSString *stringTimebomb= [[NSString alloc]initWithUTF8String:
                                               (const char *) sqlite3_column_text(stmt, 5)];
                    noteItem.note_Time_bomb=stringTimebomb;
                    
                }
                
                if ((const char *) sqlite3_column_text(stmt, 6)!=nil)
                {
                    NSString *stringReminder= [[NSString alloc]initWithUTF8String:
                                               (const char *) sqlite3_column_text(stmt, 6)];
                    noteItem.note_Reminder=stringReminder;
                    
                }
                
                
                
                
                [resultArray addObject:noteItem];
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return resultArray;
    
}


-(NSArray *) getRecordsWithSearchFolder:(NSString*) filePath   searchText:(NSString*)searchString
{
    NSMutableArray * resultArray =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = [NSString  stringWithFormat:@"SELECT * from FolderShare Where %@ LIKE \'%@%%\' ",FOLDER_TITLE,searchString];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                DBNoteItems *noteItem=[[DBNoteItems alloc]init];
                
                noteItem.folder_Title = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(stmt, 1)];
                
                noteItem.folder_Created_Time = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(stmt, 3)];
                
                noteItem.folder_id = [[NSString alloc]initWithUTF8String:
                                    (const char *) sqlite3_column_text(stmt, 0)];
                noteItem.folder_Deleted= [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 11)];
                noteItem.folder_Modified_Time = [[NSString alloc]initWithUTF8String:
                                               (const char *) sqlite3_column_text(stmt, 4)];
//                noteItem.note_Element = [[NSString alloc]initWithUTF8String:
//                                         (const char *) sqlite3_column_text(stmt, 9)];
//                
//                noteItem.note_Color = [[NSString alloc]initWithUTF8String:
//                                       (const char *) sqlite3_column_text(stmt, 2)];//give index here
//                
//                noteItem.note_Color_List = [[NSString alloc]initWithUTF8String:
//                                            (const char *) sqlite3_column_text(stmt, 12)];//give index here
//                
//                noteItem.folder_id = [[NSString alloc]initWithUTF8String:
//                                      (const char *) sqlite3_column_text(stmt, 8)];//give index here
//                
//                //NSLog(@"%@",(const char *) sqlite3_column_text(stmt, 13));
//                
//                if ((const char *) sqlite3_column_text(stmt, 13)!=nil)
//                {
//                    noteItem.note_lock= [[NSString alloc]initWithUTF8String:
//                                         (const char *) sqlite3_column_text(stmt, 13)];
//                }
//                if ((const char *) sqlite3_column_text(stmt, 5)!=nil)
//                {
//                    NSString *stringTimebomb= [[NSString alloc]initWithUTF8String:
//                                               (const char *) sqlite3_column_text(stmt, 5)];
//                    noteItem.note_Time_bomb=stringTimebomb;
//                    
//                }
//                
//                if ((const char *) sqlite3_column_text(stmt, 6)!=nil)
//                {
//                    NSString *stringReminder= [[NSString alloc]initWithUTF8String:
//                                               (const char *) sqlite3_column_text(stmt, 6)];
//                    noteItem.note_Reminder=stringReminder;
//                    
//                }
//                
                
                
                
                [resultArray addObject:noteItem];
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return resultArray;
    
}




-(NSArray *) getRecordsFolder:(NSString*) filePath{
    NSMutableArray * resultArray =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
       // NSString  * query = @"SELECT * from FolderShare";
        
         NSString  * query = [NSString stringWithFormat:@"SELECT * from FolderShare where %@=\"%@\"",USER_ID,[[DataManger sharedmanager] getUserId]];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                DBNoteItems *noteItem=[[DBNoteItems alloc]init];
                
                noteItem.folder_Title = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 1)];
                
                noteItem.folder_Created_Time = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(stmt, 3)];
                
                noteItem.create_folder_Id = [[NSString alloc]initWithUTF8String:
                                             (const char *) sqlite3_column_text(stmt, 0)];
                noteItem.folder_Deleted = [[NSString alloc]initWithUTF8String:
                                           (const char *) sqlite3_column_text(stmt, 11)];
                noteItem.folder_Modified_Time = [[NSString alloc]initWithUTF8String:
                                                 (const char *) sqlite3_column_text(stmt, 4)];
                
                
                [resultArray addObject:noteItem];
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return resultArray;
    
}

#pragma get records from

-(NSArray *) getRecords:(NSString*) filePath where:(NSString *)whereStmt{
    NSMutableArray * resultArray =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString *query = [NSString stringWithFormat: @"select %@, %@, %@ from NoteShare where %@=\"%@\"",NOTE_TITLE,CREATED_TIME,NOTE_ID,NOTE_TITLE,whereStmt];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                DBNoteItems *noteItem=[[DBNoteItems alloc]init];
                
                noteItem.note_Title = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(stmt, 0)];
                
                noteItem.note_Created_Time = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(stmt, 1)];
                
                noteItem.note_Id = [[NSString alloc]initWithUTF8String:
                                    (const char *) sqlite3_column_text(stmt, 2)];
                
                
                
                
                [resultArray addObject:noteItem];
                
            }
            
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return resultArray;
    
}


-(NSArray *) getAllRecordsWithNote_Id:(NSString*) filePath where:(NSString *)note_id
{
    NSMutableArray * resultArray =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString *query = [NSString stringWithFormat: @"select %@, %@, %@ from NoteShare where %@=\"%@\"",NOTE_TITLE,CREATED_TIME,NOTE_ID,NOTE_TITLE,note_id];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                DBNoteItems *noteItem=[[DBNoteItems alloc]init];
                
                noteItem.note_Title = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(stmt, 0)];
                
                noteItem.note_Created_Time = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(stmt, 1)];
                
                noteItem.note_Id = [[NSString alloc]initWithUTF8String:
                                    (const char *) sqlite3_column_text(stmt, 2)];
                
                
                
                
                [resultArray addObject:noteItem];
                
            }
            
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        
        else
            
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        
        sqlite3_close(db);
    }
    
    return resultArray;
    
}


-(NSArray *) getRecordsWithNote_Id:(NSString*) filePath where:(NSString *)note_id{
    NSMutableArray * resultArray =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString *query = [NSString stringWithFormat: @"select %@,%@,%@,%@,%@,%@,%@ from NoteShare where %@=\"%@\"",NOTE_TITLE,CREATED_TIME,NOTE_ID,NOTE_ELEMENT,MODIFIED_TIME,COLOR,REMINDER_TIME,NOTE_ID
                           ,note_id];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                DBNoteItems *noteItem=[[DBNoteItems alloc]init];
                
                noteItem.note_Title = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(stmt, 0)];
                
                noteItem.note_Created_Time = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(stmt, 1)];
                
                noteItem.note_Id = [[NSString alloc]initWithUTF8String:
                                    (const char *) sqlite3_column_text(stmt, 2)];
                
                noteItem.note_Element = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 3)];
                
                noteItem.note_Modified_Time = [[NSString alloc]initWithUTF8String:
                                               (const char *) sqlite3_column_text(stmt,4)];
                
                noteItem.note_Color = [[NSString alloc]initWithUTF8String:
                                       (const char *) sqlite3_column_text(stmt, 5)];
                
                noteItem.note_Reminder = [[NSString alloc]initWithUTF8String:
                                          (const char *) sqlite3_column_text(stmt, 6)];
                
                
                [resultArray addObject:noteItem];
                
            }
            
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        
        else
            
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        
        sqlite3_close(db);
    }
    
    return resultArray;
    
}

-(NSArray *) getRecordsFolder:(NSString*) filePath where:(NSString *)whereStmt{
    NSMutableArray * resultArray =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString *query = [NSString stringWithFormat: @"select %@, %@, %@ from FolderShare where %@=\"%@\"",FOLDER_TITLE,FOLDER_CREATED_TIME,CREATE_FOLDER_ID,FOLDER_TITLE,whereStmt];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                DBNoteItems *noteItem=[[DBNoteItems alloc]init];
                
                noteItem.folder_Title = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 0)];
                
                noteItem.folder_Created_Time = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(stmt, 1)];
                
                noteItem.create_folder_Id = [[NSString alloc]initWithUTF8String:
                                             (const char *) sqlite3_column_text(stmt, 2)];
                
            
                
                [resultArray addObject:noteItem];
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return resultArray;
    
}

-(NSArray *)getAllRecordsWithFolderId:(NSString*) filePath where:(NSString *)folder_note_id{
    NSMutableArray * resultArray =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        //        NSString *query = [NSString stringWithFormat: @"select * from NoteShare where %@=\"%@\"",FOLDER_ID, folder_note_id];
        
        NSString *query = [NSString stringWithFormat: @"select %@,%@,%@,%@,%@,%@,%@,%@,%@ from NoteShare where %@=\"%@\"",NOTE_TITLE,CREATED_TIME,NOTE_ID,NOTE_ELEMENT,MODIFIED_TIME,COLOR,NOTE_COLOR,NOTE_LOCK,TIME_BOMB,FOLDER_ID,folder_note_id];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                DBNoteItems *noteItem=[[DBNoteItems alloc]init];
                
                noteItem.note_Title = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(stmt, 0)];
                
                noteItem.note_Created_Time = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(stmt, 1)];
                
                noteItem.note_Id = [[NSString alloc]initWithUTF8String:
                                    (const char *) sqlite3_column_text(stmt, 2)];
                
                noteItem.note_Element = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 3)];
                
                noteItem.note_Modified_Time = [[NSString alloc]initWithUTF8String:
                                               (const char *) sqlite3_column_text(stmt,4)];
                
                noteItem.note_Color = [[NSString alloc]initWithUTF8String:
                                       (const char *) sqlite3_column_text(stmt, 5)];
                
                noteItem.note_Color_List=[[NSString alloc]initWithUTF8String:
                                          (const char *) sqlite3_column_text(stmt, 6)];
                
                
                if ((const char *) sqlite3_column_text(stmt, 7)!=nil)
                {
                    noteItem.note_lock= [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 7)];
                }
                
                if ((const char *) sqlite3_column_text(stmt, 8)!=nil)
                {
                    noteItem.note_Time_bomb = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(stmt, 8)];
                }
                
                
                [resultArray addObject:noteItem];
                
            }
            
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        
        else
            
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        
        sqlite3_close(db);
    }
    
    return resultArray;
    
}


#pragma mark-updateSetting
//NoteShareSetting
//NOTE_USER_ID,NOTE_DEFAULT_VIEW,NOTE_DEFAULT_FONT,NOTE_DEFAULT_PASSWORD,note_user_id,note_default_view,n
-(int)updateSetting:(NSString*)filePath masterPassword:(NSString*)masterPassword user_id:(NSString*)userID
{
    
    sqlite3* db = NULL;
    int rc=0;
    sqlite3_stmt* stmt =NULL;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
        
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    
    else
    {
        NSLog(@"Exitsing data, Update Please");
        NSString *query = [NSString stringWithFormat:@"UPDATE NoteShareSetting set %@ = '%@' WHERE NOTE_USER_ID = ?",NOTE_DEFAULT_PASSWORD,masterPassword];
        
        
        sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL );
        sqlite3_bind_text(stmt, 1, [userID UTF8String], -1, SQLITE_TRANSIENT);
        
        if(sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"success to update record  rc:%d ",sqlite3_step(stmt));
        }else{
            
            NSLog(@"Failed to insert record  rc:%d",sqlite3_step(stmt));
        }
        
        sqlite3_close(db);
    }
    return rc;
}

-(int)updateSettingUserID:(NSString*)filePath user_id:(NSString*)userID
{
    
    sqlite3* db = NULL;
    int rc=0;
    sqlite3_stmt* stmt =NULL;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
        
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    
    else
    {
        NSLog(@"Exitsing data, Update Please");
        NSString *query = [NSString stringWithFormat:@"UPDATE NoteShareSetting set NOTE_USER_ID = ?"];
        
        
        sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL );
        sqlite3_bind_text(stmt, 1, [userID UTF8String], -1, SQLITE_TRANSIENT);
        
        if(sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"success to update record  rc:%d ",sqlite3_step(stmt));
        }else{
            
            NSLog(@"Failed to insert record  rc:%d",sqlite3_step(stmt));
        }
        
        sqlite3_close(db);
    }
    return rc;
}

#pragma update code

- (int)UpdateNoteElements:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems{
    
    
    sqlite3* db = NULL;
    int rc=0;
    sqlite3_stmt* stmt =NULL;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
        
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    
    else
        
    {
        
        NSLog(@"Exitsing data, Update Please");
        NSString *query = [NSString stringWithFormat:@"UPDATE NoteShare set %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' , %@ = '%@' WHERE NOTE_ID = ?",NOTE_TITLE,noteItems.note_Title,NOTE_DELETE_STATUS, noteItems.note_Deleted,MODIFIED_TIME, noteItems.note_Modified_Time,NOTE_ELEMENT,noteItems.note_Element,COLOR,noteItems.note_Color];
        
        
        sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL );
        sqlite3_bind_int(stmt, 1, noteItems.note_Id.intValue);
        
        if(sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"success to update record  rc:%d ",sqlite3_step(stmt));
        }else{
            
            NSLog(@"Failed to insert record  rc:%d",sqlite3_step(stmt));
        }
        
        sqlite3_close(db);
        
    }
    
    return rc;
    
}



#pragma mark- update Note color on list

- (int)UpdateNoteColorOnList:(NSString*)filePath withNoteItem:(NSString*)note_color note_id:(NSString*)note_id{
    
    
    sqlite3* db = NULL;
    int rc=0;
    sqlite3_stmt* stmt =NULL;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSLog(@"Exitsing data, Update Please");
        NSString *query = [NSString stringWithFormat:@"UPDATE NoteShare set %@ = '%@' WHERE NOTE_ID = ?",NOTE_COLOR,note_color];
        
        
        sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL );
        sqlite3_bind_int(stmt, 1, note_id.intValue);
        
        if(sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"success to update record  rc:%d ",sqlite3_step(stmt));
        }else{
            
            NSLog(@"Failed to insert record  rc:%d",sqlite3_step(stmt));
        }
        
        sqlite3_close(db);
        
    }
    return rc;
    
}

- (int)UpdateFolderElements:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems{
    
    
    sqlite3* db = NULL;
    int rc=0;
    sqlite3_stmt* stmt =NULL;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSLog(@"Exitsing data, Update Please");
        NSString *query = [NSString stringWithFormat:@"UPDATE FolderShare set %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' WHERE CREATE_FOLDER_ID = ?",FOLDER_TITLE,noteItems.folder_Title,FOLDER_DELETE_STATUS, noteItems.folder_Deleted,FOLDER_MODIFIED_TIME, noteItems.folder_Modified_Time,NOTE_ELEMENT,noteItems.note_Element];
        
        // char * errMsg;
        // rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        
        sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL );
        sqlite3_bind_int(stmt, 1, noteItems.note_Id.intValue);
        
        if(sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"success to update record  rc:%d ",sqlite3_step(stmt));
        }else{
            
            NSLog(@"Failed to insert record  rc:%d",sqlite3_step(stmt));
        }
        
        sqlite3_close(db);
        
    }
    return rc;
    
}

#pragma mark-Update Note time Bomb

- (int)UpdateNoteTimeBomb:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems
{
    
    
    sqlite3* db = NULL;
    int rc=0;
    sqlite3_stmt* stmt =NULL;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
        
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    
    else
        
    {
        
        NSLog(@"Exitsing data, Update Please");
        NSString *query = [NSString stringWithFormat:@"UPDATE NoteShare set %@ = '%@' WHERE NOTE_ID = ?",TIME_BOMB,noteItems.note_Time_bomb];
        
        
        sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL );
        sqlite3_bind_int(stmt, 1, noteItems.note_Id.intValue);
        
        if(sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"success to update record  rc:%d ",sqlite3_step(stmt));
        }else{
            
            NSLog(@"Failed to insert record  rc:%d",sqlite3_step(stmt));
        }
        
        sqlite3_close(db);
        
    }
    
    return rc;
    
}

#pragma mark-Update Note Reminder

- (int)UpdateNoteReminder:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems
{
    
    
    sqlite3* db = NULL;
    int rc=0;
    sqlite3_stmt* stmt =NULL;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
        
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    
    else
        
    {
        
        NSLog(@"Exitsing data, Update Please");
        NSString *query = [NSString stringWithFormat:@"UPDATE NoteShare set %@ = '%@' WHERE NOTE_ID = ?",REMINDER_TIME,noteItems.note_Reminder];
        
        
        sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL );
        sqlite3_bind_int(stmt, 1, noteItems.note_Id.intValue);
        
        if(sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"success to update record  rc:%d ",sqlite3_step(stmt));
        }else{
            
            NSLog(@"Failed to insert record  rc:%d",sqlite3_step(stmt));
        }
        
        sqlite3_close(db);
        
    }
    
    return rc;
    
}


- (int)UpdateNoteTitle:(NSString*)filePath withNoteItem:(NSString*)note_title note_id:(NSString*)note_id{
    
    
    sqlite3* db = NULL;
    int rc=0;
    sqlite3_stmt* stmt =NULL;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSLog(@"Exitsing data, Update Please");
        NSString *query = [NSString stringWithFormat:@"UPDATE NoteShare set %@ = '%@' WHERE NOTE_ID = ?",NOTE_TITLE,note_title];
        
        
        sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL );
        sqlite3_bind_int(stmt, 1, note_id.intValue);
        
        if(sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"success to update record  rc:%d ",sqlite3_step(stmt));
        }else{
            
            NSLog(@"Failed to insert record  rc:%d",sqlite3_step(stmt));
        }
        
        sqlite3_close(db);
        
    }
    return rc;
    
}



#pragma mark-Update Note lock

- (int)UpdateNoteLock:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems
{
    
    
    sqlite3* db = NULL;
    int rc=0;
    sqlite3_stmt* stmt =NULL;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
        
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    
    else
        
    {
        
        NSLog(@"Exitsing data, Update Please");
        NSString *query = [NSString stringWithFormat:@"UPDATE NoteShare set %@ = '%@' WHERE NOTE_ID = ?",NOTE_LOCK,noteItems.note_lock];
        
        
        sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL );
        sqlite3_bind_int(stmt, 1, noteItems.note_Id.intValue);
        
        if(sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"success to update record  rc:%d ",sqlite3_step(stmt));
        }else{
            
            NSLog(@"Failed to insert record  rc:%d",sqlite3_step(stmt));
        }
        
        sqlite3_close(db);
        
    }
    
    return rc;
    
}

#pragma mark-Update Note move to folder

- (int)UpdateNoteMoveTofolder:(NSString*)filePath withNoteItem:(DBNoteItems*)noteItems{
    
    
    sqlite3* db = NULL;
    int rc=0;
    sqlite3_stmt* stmt =NULL;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
        
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    
    else
        
    {
        
        NSLog(@"Exitsing data, Update Please");
        NSString *query = [NSString stringWithFormat:@"UPDATE NoteShare set %@ = '%@' WHERE NOTE_ID = ?",FOLDER_ID,noteItems.folder_id];
        
        
        sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL );
        sqlite3_bind_int(stmt, 1, noteItems.note_Id.intValue);
        
        if(sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"success to update record  rc:%d ",sqlite3_step(stmt));
        }else{
            
            NSLog(@"Failed to insert record  rc:%d",sqlite3_step(stmt));
        }
        
        sqlite3_close(db);
        
    }
    
    return rc;
    
}

#pragma mark-note  delete

-(int)deleteNote:(NSString*) filePath withNoteItem:(DBNoteItems*)noteItems{
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM NoteShare where NOTE_ID=\"%@\"",noteItems.note_Id];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}

-(int)deleteFolder:(NSString*) filePath withNoteItem:(NSString*)folderId{
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM FolderShare where CREATE_FOLDER_ID=\"%@\"",folderId];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}



#pragma mark-Note Element table Initlization

-(int) createNoteElementTable:(NSString*) filePath {
    sqlite3* db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        // char * query ="CREATE TABLE IF NOT EXISTS students ( id INTEGER PRIMARY KEY AUTOINCREMENT, name  TEXT, age INTEGER, marks INTEGER )";
        
        char *query ="create table if not exists NoteShareElement (NOTE_ELEMENT_ID INTEGER PRIMARY KEY AUTOINCREMENT , NOTE_ID text, NOTE_ELEMENT_CONTENT text, NOTE_ELEMENT_TYPE text,NOTE_ELEMENT_MEDIA_TIME text,NOTE_ELEMENT_TEXT_HEIGHT text)";
        
        char * errMsg;
        rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,errMsg);
        }
        
        sqlite3_close(db);
    }
    
    return rc;
    
}

-(int) insert:(NSString *)filePath withName:(NSString*)note_ID note_element_content:(NSString*)note_element_content
note_element_type:(NSString*)note_element_type note_element_media_time:(NSString*)note_element_media_time
{
    sqlite3* db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        //  NSString * query  = [NSString
        //stringWithFormat:@"INSERT INTO students (name,age,marks) VALUES (\"%@\",%ld,%ld)",name,(long)age,(long)marks];
        
        NSString *query = [NSString stringWithFormat:@"insert into NoteShareElement (%@,%@, %@ ,%@) values (\"%@\",\"%@\", \"%@\", \"%@\")",NOTE_ID,NOTE_ELEMENT_CONTENT,NOTE_ELEMENT_TYPE,NOTE_ELEMENT_MEDIA_TIME,note_ID,note_element_content,note_element_type,note_element_media_time];
        
        
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}


-(NSArray *)getAllNoteElementWithNote_Id:(NSString*) filePath where:(NSString *)note_id
{
    NSMutableArray * resultArray =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString *query = [NSString stringWithFormat: @"select * from NoteShareElement where %@=\"%@\"",NOTE_ID,note_id];
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                DBNoteItems *noteItem=[[DBNoteItems alloc]init];
                
                noteItem.NOTE_ELEMENT_ID = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(stmt, 0)];
                
                noteItem.note_Id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(stmt, 1)];
                
                
                if ((const char *) sqlite3_column_text(stmt, 2)!=nil)
                {
                    noteItem.NOTE_ELEMENT_CONTENT = [[NSString alloc]initWithUTF8String:
                                                     (const char *) sqlite3_column_text(stmt, 2)];
                }
                
                
                noteItem.NOTE_ELEMENT_TYPE = [[NSString alloc]initWithUTF8String:
                                              (const char *) sqlite3_column_text(stmt, 3)];
                noteItem.NOTE_ELEMENT_MEDIA_TIME = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(stmt,4)];
                
                if ((const char *) sqlite3_column_text(stmt, 5)!=nil)
                {
                    noteItem.NOTE_ELEMENT_TEXT_HEIGHT = [[NSString alloc]initWithUTF8String:
                                                  (const char *) sqlite3_column_text(stmt, 5)];
                }
                
                [resultArray addObject:noteItem];
                
            }
            
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        
        else
            
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        
        sqlite3_close(db);
    }
    
    return resultArray;
    
}

-(int)deleteNoteElement:(NSString*) filePath withNoteItem:(NSString*)noteItems_elementId{
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM NoteShareElement where NOTE_ELEMENT_ID=\"%@\"",noteItems_elementId];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}


- (int)UpdateTextNoteElementContent:(NSString*)filePath withNoteItem:(NSString*)note_textContent note_Element_id:(NSString*)note_Element_id note_Element_height:(NSString*)note_Element_height

{
    
    
    sqlite3* db = NULL;
    int rc=0;
    sqlite3_stmt* stmt =NULL;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSLog(@"Exitsing data, Update Please");
        NSString *query = [NSString stringWithFormat:@"UPDATE NoteShareElement set %@ = '%@' , %@ = '%@' WHERE NOTE_ELEMENT_ID = ?",NOTE_ELEMENT_CONTENT,note_textContent,NOTE_ELEMENT_TEXT_HEIGHT,note_Element_height];
        
        
        sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL );
        sqlite3_bind_int(stmt, 1, note_Element_id.intValue);
        
        if(sqlite3_step(stmt) == SQLITE_DONE)
        {
            NSLog(@"success to update record  rc:%d ",sqlite3_step(stmt));
        }else{
            
            NSLog(@"Failed to insert record  rc:%d",sqlite3_step(stmt));
        }
        
        sqlite3_close(db);
        
    }
    return rc;
    
}




#pragma mark-Unused

+(DBManager*)getSharedInstance{
    
    static DBManager *sharedInstance=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[DBManager alloc]init];
        
    });
    
    return sharedInstance;
}


@end
