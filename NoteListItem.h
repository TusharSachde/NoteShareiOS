//
//  NoteListItem.h
//  NoteShare
//
//  Created by tilak raj verma on 30/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AUDIO,
    IMAGES,
    TEXT,
} NOTETYPE;


@interface NoteListItem : NSObject
@property(nonatomic,strong) UIImage *noteimage;
@property(nonatomic,assign)NOTETYPE notetype;
@property(nonatomic,strong)NSURL *audioPlayPath;
@property(nonatomic,strong)NSString *imagePath;
@property(nonatomic,strong)NSString *noteElementID;
@property(nonatomic,strong)NSString *strAudioPlayPath;
@property(nonatomic,strong)NSString *strAudioTotalTime;
@property(nonatomic,strong)NSString *textString;
@property(nonatomic,assign)BOOL isEdited;
@property(nonatomic,assign)NSInteger positionIn;
@property(nonatomic,assign)NSInteger height;
@end
