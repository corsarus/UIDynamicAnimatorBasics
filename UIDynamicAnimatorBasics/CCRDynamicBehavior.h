//
//  CCRDynamicBehavior.h
//  UIDynamicAnimatorBasics
//
//  Created by Catalin (iMac) on 28/11/2014.
//  Copyright (c) 2014 Catalin Rosioru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCRDynamicBehavior : UIDynamicBehavior

- (instancetype) initWithFixedItem:(id<UIDynamicItem>)fixedItem attachedItems:(NSArray *)items;

- (void)showAttachedItems;
- (void)hideAttachedItems;

@end
