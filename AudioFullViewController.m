//
//  AudioFullViewController.m
//  NoteShare
//
//  Created by tilak raj verma on 30/09/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "AudioFullViewController.h"
#import "AudioCell_1.h"

@interface AudioFullViewController ()

@property(nonatomic,strong)AudioCell_1 *audioCell_1;

@end

@implementation AudioFullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _audioCell_1=[[[NSBundle mainBundle]loadNibNamed:@"AudioCell_1" owner:self options:nil] objectAtIndex:0];
    
    
    [_audioCell_1 setNoteitemList:_noteListItem];
    [self.view addSubview:_audioCell_1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)setNoteListItem:(NoteListItem *)noteListItem
//{
//    
//    
//    
//}



@end
