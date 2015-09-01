//
//  AddFolderViewController.h
//  NotesSharingApp
//
//  Created by Heba khan on 23/07/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    textBtn,
    OK,
    CANCEL,
    
} CREATEFOLDER;


@protocol PopUpViewDelegate <NSObject>

//-(void)dismissViewWithTag:(NSInteger)selectedOption;
-(void)dismissFolderView:(CREATEFOLDER)selectOption;
-(void)dismissFolderView:(CREATEFOLDER)selectOption   WithTag:(NSInteger)selectedOption;

@end


@interface AddFolderViewController : UIViewController


-(IBAction)btnCancelClick:(id)sender;
-(IBAction)btnOkClick:(id)sender;


@property (strong, nonatomic) IBOutlet UITextField *addFolder;

@property(nonatomic,strong)NSString *stringAlertTitle;
@property(nonatomic,weak)id <PopUpViewDelegate> delegate;

@end
