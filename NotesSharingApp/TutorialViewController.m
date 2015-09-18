//
//  TutorialViewController.m
//  NotesSharingApp
//
//  Created by Heba khan on 05/08/15.
//  Copyright (c) 2015 Heba khan. All rights reserved.
//

#import "TutorialViewController.h"
#import "UserDetail.h"
#import "DataManger.h"


@interface TutorialViewController ()
@property (nonatomic,assign)NSInteger temp;
@end

@implementation TutorialViewController
NSArray *imageNames;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Load images
    imageNames = @[@"screen1.png", @"screen2.png", @"screen3.png", @"screen4.png",
                            @"screen5.png", @"screen6.png", @"screen7.png", @"screen8.png",
                            @"screen9.png", @"screen10.png", @"screen11.png", @"screen12.png",
                            @"screen13.png", @"screen14.png",  @"screen15.png", @"screen16.png", @"screen17.png", @"screen18.png", @"screen19.png", @"screen20.png", @"screen21.png",@"screen22.png",@"screen23.png",@"screen24.png",@"screen25.png",@"screen26.png",@"screen27.png",@"screen28.png",@"screen29.png",@"screen30.png",@"screen31.png",@"screen32.png",@"screen33.png",@"screen34.png",@"screen35.png",@"screen36.png",@"screen37.png",@"screen38.png",@"screen39.png",@"screen40.png",@"screen41.png"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < imageNames.count; i++) {
        
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
        
    }
    
    // Slow motion animation
   
    _slowAnimationImageView.animationImages = images;
    _slowAnimationImageView.animationDuration = 50;
    
   // [self.view addSubview:_slowAnimationImageView];
    
        [_slowAnimationImageView startAnimating];
  
   //   [_slowAnimationImageView stopAnimating];
  
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)next:(id)sender {
    
    UserDetail *detail=[[DataManger sharedmanager]tutorialMethod];
    detail.tutorialAppSeen=YES;
    [[DataManger sharedmanager]tutorialMethodDetail:detail];
    
}

@end
