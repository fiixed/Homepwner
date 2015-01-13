//
//  BubbleBackgroundView.m
//  Homepwner
//
//  Created by Andrew Bell on 1/14/15.
//  Copyright (c) 2015 FiixedMobile. All rights reserved.
//

#import "BubbleBackgroundView.h"

@interface BubbleBackgroundView ()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *arrowImageView;

@end

@implementation BubbleBackgroundView

@synthesize arrowDirection  = _arrowDirection;
@synthesize arrowOffset     = _arrowOffset;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // background (for demo only, we don't actually need this for our background)
        UIImage *backgroundImage = [UIImage imageNamed:@"bubble-rect"];
        UIImage *resizableBackgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 40, 40, 40) resizingMode:UIImageResizingModeStretch];
        
        self.backgroundImageView = [[UIImageView alloc] initWithImage:resizableBackgroundImage];
        self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        
        // round those corners!
        self.backgroundImageView.layer.cornerRadius = 15;
        self.backgroundImageView.layer.masksToBounds = YES;
        
        // arrow
        UIImage *arrowImage = [UIImage imageNamed:@"bubble-triangle"];
        
        self.arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
        
        // make sure the arrow is on top of the background
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.arrowImageView];
    }
    
    return self;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

+ (CGFloat)arrowBase
{
    return 31.0;
}

+ (CGFloat)arrowHeight
{
    return 70.0;
}

+ (BOOL)wantsDefaultContentAppearance
{
    return YES;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
    [self setNeedsLayout];
}

- (UIPopoverArrowDirection)arrowDirection {
    return _arrowDirection;
}

- (void)setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset;
    [self setNeedsLayout];
}

- (CGFloat)arrowOffset {
    return _arrowOffset;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat arrowHeight = [self.class arrowHeight];
    
    CGRect backgroundFrame = self.frame;
    CGPoint arrowCenter = CGPointZero;
    CGFloat arrowTransformInRadians = 0;
    
    if (self.arrowDirection == UIPopoverArrowDirectionUp) {
        backgroundFrame.origin.y += arrowHeight;
        backgroundFrame.size.height -= arrowHeight;
        arrowTransformInRadians = 0;
        arrowCenter = CGPointMake(backgroundFrame.size.width * 0.5 + self.arrowOffset, arrowHeight * 0.5);
    } else if (self.arrowDirection == UIPopoverArrowDirectionDown) {
        backgroundFrame.size.height -= arrowHeight;
        arrowTransformInRadians = M_PI;
        arrowCenter = CGPointMake(backgroundFrame.size.width * 0.5 + self.arrowOffset, backgroundFrame.size.height + arrowHeight * 0.5);
    } else if (self.arrowDirection == UIPopoverArrowDirectionLeft) {
        backgroundFrame.origin.x += arrowHeight;
        backgroundFrame.size.width -= arrowHeight;
        arrowTransformInRadians = M_PI_2 * 3.0;
        arrowCenter = CGPointMake(arrowHeight * 0.5, backgroundFrame.size.height * 0.5 + self.arrowOffset);
    } else if (self.arrowDirection == UIPopoverArrowDirectionRight) {
        backgroundFrame.size.width -= arrowHeight;
        arrowTransformInRadians = M_PI_2;
        arrowCenter = CGPointMake(backgroundFrame.size.width + arrowHeight * 0.5, backgroundFrame.size.height * 0.5 + self.arrowOffset);
    }
    
    self.backgroundImageView.frame = backgroundFrame;
    self.arrowImageView.center = arrowCenter;
    self.arrowImageView.transform = CGAffineTransformMakeRotation(arrowTransformInRadians);
}


@end
