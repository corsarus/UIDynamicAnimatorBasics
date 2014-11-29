//
//  CCRAttachmentViewController.m
//  UIDynamicAnimatorBasics
//
//  Created by Catalin (iMac) on 27/11/2014.
//  Copyright (c) 2014 Catalin Rosioru. All rights reserved.
//

#import "CCRAttachmentViewController.h"
#import "CCRDynamicBehavior.h"

@interface CCRAttachmentViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (weak, nonatomic) IBOutlet UIButton *fixedBallView;
@property (nonatomic, strong) NSMutableArray *attachedBallViews;
@property (nonatomic) BOOL attachedBallViewsVisible;

@end

@implementation CCRAttachmentViewController

static CGFloat const kAttachedBallRadius = 25.0;

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    
    return _animator;
}

- (NSMutableArray *)attachedBallViews
{
    if (!_attachedBallViews) {
        _attachedBallViews = [[NSMutableArray alloc] init];
    }
    
    return _attachedBallViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fixedBallView.backgroundColor = [UIColor magentaColor];
    [self addAttachedBallViews];
    
    
    
}

- (void)addAttachedBallViews
{
    UIView *attachedView;
    
    for (NSUInteger i = 0; i < 4; i++) {
        attachedView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - kAttachedBallRadius, self.view.center.y - kAttachedBallRadius, 2 * kAttachedBallRadius, 2 * kAttachedBallRadius)];
        attachedView.backgroundColor = [UIColor redColor];
        [self.view insertSubview:attachedView belowSubview:self.fixedBallView];
        [self.attachedBallViews addObject:attachedView];
    }
}


- (IBAction)popAttachedBallViews:(id)sender
{
    // Remove current composed behavior
    [self.animator removeAllBehaviors];
    
    // Recreate the composed behavior and attach it to the animator
    CCRDynamicBehavior *composedBehavior = [[CCRDynamicBehavior alloc] initWithFixedItem:self.fixedBallView attachedItems:self.attachedBallViews];

    composedBehavior.action = ^{
        [self.view setNeedsDisplay];
    };
    
    self.attachedBallViewsVisible ? [composedBehavior hideAttachedItems] : [composedBehavior showAttachedItems];
    [self.animator addBehavior:composedBehavior];
    
    self.attachedBallViewsVisible = !self.attachedBallViewsVisible;
    
}

@end
