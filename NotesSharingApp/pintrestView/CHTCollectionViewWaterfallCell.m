//
//  UICollectionViewWaterfallCell.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallCell.h"

@implementation CHTCollectionViewWaterfallCell

#pragma mark - Accessors
- (UILabel *)displayLabel {
  if (!_displayLabel) {
    _displayLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    _displayLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _displayLabel.backgroundColor = [UIColor lightGrayColor];
    _displayLabel.textColor = [UIColor whiteColor];
    _displayLabel.textAlignment = NSTextAlignmentCenter;
  }
  return _displayLabel;
}

- (void)setDisplayString:(NSString *)displayString {
  if (![_displayString isEqualToString:displayString]) {
    _displayString = [displayString copy];
    self.displayLabel.text = _displayString;
  }
}

#pragma mark - Life Cycle
- (void)dealloc {
  [_displayLabel removeFromSuperview];
  _displayLabel = nil;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame])
  {
    // Pick a cat at random.

    UIView *imageView = [[UIView alloc] init];
    // Scale with fill for contents when we resize.
    imageView.contentMode = UIViewContentModeScaleAspectFill;

    // Scale the imageview to fit inside the contentView with the image centered:
    CGRect imageViewFrame = CGRectMake(10.f, 10.f, CGRectGetMaxX(self.contentView.bounds), CGRectGetMaxY(self.contentView.bounds));
    imageView.frame = imageViewFrame;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds = YES;
      
      _lbltitle=[[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0,imageView.frame.size.width-10.0f,20)];
      _lblDetail=[[UILabel alloc]initWithFrame:CGRectMake(0.0,8.0,imageView.frame.size.width-10.0f,imageView.frame.size.height-10.0f)];
      
      
      [imageView addSubview:_lblDetail];
      [imageView addSubview:_lbltitle];
    [self.contentView addSubview:imageView];
  }
  return self;
}

@end
