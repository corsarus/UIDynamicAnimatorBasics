//
//  ViewController.m
//  UIDynamicAnimatorBasics
//
//  Created by Catalin (iMac) on 26/11/2014.
//  Copyright (c) 2014 Catalin Rosioru. All rights reserved.
//

#import "CCRBouncingBallViewController.h"

@interface CCRBouncingBallViewController () <UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIButton *dropBallButton;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIView *dropBallView;
@property (nonatomic, strong) NSDate *dropTime;


@end

@implementation CCRBouncingBallViewController

static CGFloat const kBallViewRadius = 50.0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the animator
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.animator.delegate = self;
}

- (IBAction)dropBall:(id)sender
{
    // If the ball is visible, remove it from the view hierarchy
    if (self.dropBallView) {
        [self.dropBallView removeFromSuperview];
        self.dropBallView = nil;
        
    }
    if (self.dropTime) {
        self.dropTime = nil;
    }
    
    // Disable button
    self.dropBallButton.enabled = NO;

    // Initialize the drop time
    self.dropTime = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0];
    
    // Reset the base color
    self.baseView.backgroundColor = [UIColor orangeColor];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    // Create the ball view and place it above the main view
    self.dropBallView = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - 2 * kBallViewRadius) / 2, -2 * kBallViewRadius, 2 * kBallViewRadius, 2 * kBallViewRadius)];
    self.dropBallView.backgroundColor = [UIColor blueColor];
    // Make a round ball :)
    self.dropBallView.layer.cornerRadius = kBallViewRadius;
    
    [self.view addSubview:self.dropBallView];
    
    // Create behaviors for the effect we're looking for
    
    // Gravity behavior to make the ball fall from the top
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.dropBallView]];
    // Increase the falling speed
    gravityBehavior.magnitude = 3.0;
    
    // Collision behaviour to make stop the falling when the ball touches the base
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.dropBallView]];
    [collisionBehavior addBoundaryWithIdentifier:@"base"
                                       fromPoint:CGPointMake(self.baseView.frame.origin.x, self.baseView.frame.origin.y)
                                         toPoint:CGPointMake(self.baseView.frame.origin.x + self.baseView.frame.size.width, self.baseView.frame.origin.y)];
    
    // Become the collision delegate so that we can adjust the color of the base when the ball touches it
    collisionBehavior.collisionDelegate = self;
    
    // Dynamic item behavior to modify the ball "physical" attributes
    UIDynamicItemBehavior *dynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dropBallView]];
    // Add more bouncing
    dynamicBehavior.elasticity = 0.6;
    // Block any rotation (kind of strange for a ball)
    dynamicBehavior.allowsRotation = NO;

    
    // Attach behaviors to the animator and breath life into the ball
    [self.animator addBehavior:gravityBehavior];
    [self.animator addBehavior:collisionBehavior];
    [self.animator addBehavior:dynamicBehavior];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    // When the ball comes to a rest, remove the behaviors
    [self.animator removeAllBehaviors];
    
    // Enable button
    self.dropBallButton.enabled = YES;
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if ([((NSString *)identifier) isEqualToString:@"base"]) {
        if (fabs([self.dropTime timeIntervalSinceNow]) > 0.1) {
            [UIView animateWithDuration:0.1
                             animations:^{
                                 self.baseView.backgroundColor = [UIColor whiteColor];
                             }];
        }
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier
{
    if ([((NSString *)identifier) isEqualToString:@"base"]) {
        NSTimeInterval animationDuration = -[self.dropTime timeIntervalSinceNow] / 2;
        self.dropTime = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0];
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.baseView.backgroundColor = [UIColor orangeColor];
                         }];
    }
}

@end
