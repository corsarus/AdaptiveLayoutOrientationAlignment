//
//  ViewController.m
//  AdaptiveLayoutOrientationAlignment
//
//  Created by admin on 28/05/15.
//  Copyright (c) 2015 corsarus. All rights reserved.
//

#import "ViewController.h"
#import "AlignmentView.h"

@interface ViewController ()

@property (nonatomic, strong) AlignmentView *alignmentView;

@end

@implementation ViewController

#pragma mark - Accessors

- (AlignmentView *)alignmentView
{
    if (_alignmentView == nil) {
        _alignmentView = [[AlignmentView alloc] init];
    }
    
    return _alignmentView;
}

#pragma - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addAlignmentView];
}

#pragma mark - AlignmentView

- (void)addAlignmentView
{
    [self.view addSubview:self.alignmentView];
    
    // Pin the alignement view to the four edges of the view controller's view
    [self.view  addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[alignmentView]|"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                         views:@{@"alignmentView": self.alignmentView}]];
    
    [self.view  addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[alignmentView]|"
                                                                       options:NSLayoutFormatAlignAllCenterY
                                                                       metrics:nil
                                                                         views:@{@"alignmentView": self.alignmentView}]];
}

#pragma mark - UIContentContainer protocol

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
   
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Update the constraints for the new orientation
        [self.alignmentView setNeedsUpdateConstraints];
        
    } completion:nil];
}

@end
