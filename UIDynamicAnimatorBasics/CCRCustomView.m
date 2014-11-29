//
//  CCRCustomView.m
//  UIDynamicAnimatorBasics
//
//  Created by Catalin (iMac) on 28/11/2014.
//  Copyright (c) 2014 Catalin Rosioru. All rights reserved.
//

#import "CCRCustomView.h"

@implementation CCRCustomView


- (void)drawRect:(CGRect)rect {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(currentContext, [UIColor redColor].CGColor);
    
    UIView *topView = self.subviews[self.subviews.count - 1];
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[UIView class]] && subview != topView) {
            UIBezierPath *attachmentPath = [[UIBezierPath alloc] init];
            [attachmentPath moveToPoint:topView.center];
            [attachmentPath addLineToPoint:subview.center];
            attachmentPath.lineWidth = 2.0;
            
            [attachmentPath stroke];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make the views round
    for (UIView *subview in self.subviews) {
        subview.layer.cornerRadius = subview.bounds.size.width / 2;
    }
}


@end
