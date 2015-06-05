//
//  AlignmentView.m
//  AdaptiveLayoutOrientationAlignment
//
//  Created by admin on 28/05/15.
//  Copyright (c) 2015 corsarus. All rights reserved.
//

#import "AlignmentView.h"

NS_ENUM(NSInteger, ViewOrientation) {
    Undefined,
    Portrait,
    Landscape
};

CGFloat const kBlockViewSpacing = 20.0;

@interface AlignmentView ()

@property (nonatomic, strong) NSMutableArray *blockViews;
@property (nonatomic) enum ViewOrientation currentOrientation;
@property (nonatomic, strong) NSArray *installedConstraints;

@end

@implementation AlignmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.blockViews = [[NSMutableArray alloc] init];
        
        [self addBlocks];
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark - Add the content

- (void)addBlocks
{
    for (uint i = 0; i < 3; i++) {
        UIView *blockView = [[UIView alloc] init];
        
        blockView.translatesAutoresizingMaskIntoConstraints = NO;
        if (i % 2 == 0)
            blockView.backgroundColor = [UIColor orangeColor];
        else
            blockView.backgroundColor = [UIColor greenColor];
        
        // The block view is square, so add constraints to make the width equal to the height
        [blockView addConstraint:[NSLayoutConstraint constraintWithItem:blockView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:blockView
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.0
                                                               constant:0.0]];

        [self addSubview:blockView];
        [self.blockViews addObject:blockView];
        
        // The block views should have the same width and height
        if (i > 0)
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.blockViews[i]
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.blockViews[i - 1]
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.0
                                                              constant:0.0]];
    }
}

#pragma mark - Orientation detection

- (BOOL)isPortraitOrientation
{
    // Use the aspect ratio to determine the orientation
    return self.bounds.size.height >= self.bounds.size.width;
}

#pragma mark - Constraints

- (NSArray *)constraintsForPortraitOrientation
{
    
    NSDictionary *blockViewBindings = @{@"blockView0": self.blockViews[0], @"blockView1": self.blockViews[1], @"blockView2": self.blockViews[2]};
    
    // Constraints for the vertical alignment; the block views horizontal centers are aligned
    NSMutableArray *constraints = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-spacing-[blockView0]-spacing-[blockView1]-spacing-[blockView2]-spacing-|"
                                                                           options:NSLayoutFormatAlignAllCenterX
                                                                           metrics:@{@"spacing": @(kBlockViewSpacing)}
                                                                             views:blockViewBindings] mutableCopy];
    
    // Align the horizontal center of the first block view with the horizontal center of the custom view
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.blockViews[0]
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0.0]];
    
    return constraints;
}

- (NSArray *)constraintsForLandscapeOrientation
{
    
    NSDictionary *blockViewBindings = @{@"blockView0": self.blockViews[0], @"blockView1": self.blockViews[1], @"blockView2": self.blockViews[2]};
    
    // Constraints for the horizontal alignment; the block views vertical centers are aligned
    NSMutableArray *constraints = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-spacing-[blockView0]-spacing-[blockView1]-spacing-[blockView2]-spacing-|"
                                                                   options:NSLayoutFormatAlignAllCenterY
                                                                   metrics:@{@"spacing": @(kBlockViewSpacing)}
                                                                     views:blockViewBindings] mutableCopy];
    
    // Align the vertical center of the first block view with the vertical center of the custom view
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.blockViews[0]
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0.0]];
    return constraints;
}

#pragma mark - Layout

- (void)updateConstraints
{
    
    // Install the constraints specific to the current orientation
    if ([self isPortraitOrientation] && self.currentOrientation != Portrait) {
        if (self.installedConstraints != nil)
            [self removeConstraints:self.installedConstraints];
        self.installedConstraints = [self constraintsForPortraitOrientation];
        self.currentOrientation = Portrait;
    
    }
    else if (![self isPortraitOrientation] && self.currentOrientation == Portrait) {
        if (self.installedConstraints != nil)
            [self removeConstraints:self.installedConstraints];

        [self removeConstraints:self.installedConstraints];
        self.installedConstraints = [self constraintsForLandscapeOrientation];
        self.currentOrientation =Landscape;
    
    }
    
    [self addConstraints:self.installedConstraints];
    
    [super updateConstraints];
}


@end
