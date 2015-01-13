//
//  BubbleBackgroundView.h
//  Homepwner
//
//  Created by Andrew Bell on 1/14/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleBackgroundView : UIPopoverBackgroundView

@property (nonatomic, readwrite) UIPopoverArrowDirection arrowDirection;
@property (nonatomic, readwrite) CGFloat arrowOffset;

@end
