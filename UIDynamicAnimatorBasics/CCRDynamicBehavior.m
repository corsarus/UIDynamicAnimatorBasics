//
//  CCRDynamicBehavior.m
//  UIDynamicAnimatorBasics
//
//  Created by Catalin (iMac) on 28/11/2014.
//  Copyright (c) 2014 Catalin Rosioru. All rights reserved.
//

#import "CCRDynamicBehavior.h"

@interface CCRDynamicBehavior ()

@property (nonatomic, weak) id<UIDynamicItem> fixedItem;
@property (nonatomic, weak) NSArray *attachedItems;


@end

@implementation CCRDynamicBehavior

- (instancetype) initWithFixedItem:(id<UIDynamicItem>)fixedItem attachedItems:(NSArray *)items
{
    if (!(self = [super init])) return nil;
    
    _fixedItem = fixedItem;
    _attachedItems = items;
    
    // Snap behaviour is vigorous. Tone it down by adding some resistance.
    UIDynamicItemBehavior *dynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:items];
    dynamicBehavior.resistance = 5.0;
    [self addChildBehavior:dynamicBehavior];
    
    return self;
}


- (void)showAttachedItems
{
    NSArray *snapOffsets = @[[NSValue valueWithCGPoint:CGPointMake(-100.0, -100.0)],
                             [NSValue valueWithCGPoint:CGPointMake(100.0, -100.0)],
                             [NSValue valueWithCGPoint:CGPointMake(100.0, 100.0)],
                             [NSValue valueWithCGPoint:CGPointMake(-100.0, 100.0)]];
    

    [self updateSnapBehaviorsWithOffsets:snapOffsets relatedToPoint:self.fixedItem.center];

}

- (void)hideAttachedItems
{
    NSArray *snapOffset = @[[NSValue valueWithCGPoint:CGPointZero],
                             [NSValue valueWithCGPoint:CGPointZero],
                             [NSValue valueWithCGPoint:CGPointZero],
                             [NSValue valueWithCGPoint:CGPointZero]];
    
    
    [self updateSnapBehaviorsWithOffsets:snapOffset relatedToPoint:self.fixedItem.center];
    
}

- (void)updateSnapBehaviorsWithOffsets:(NSArray *)offsets relatedToPoint:(CGPoint)point
{
    // Remove existing snap behaviors
    for (UIDynamicBehavior *behavior in self.childBehaviors) {
        if ([behavior isMemberOfClass:[UISnapBehavior class]]) {
            [self removeChildBehavior:behavior];
        }
    }
    
    for (NSUInteger i = 0; i < self.attachedItems.count; i++) {
        id<UIDynamicItem> item = self.attachedItems[i];
        CGPoint snapOffset = ((NSValue *)offsets[i]).CGPointValue;
        
        UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:item snapToPoint:CGPointMake(point.x - snapOffset.x, point.y - snapOffset.y)];
        snapBehavior.damping = 0.5;
        [self addChildBehavior:snapBehavior];
    }
}


@end
