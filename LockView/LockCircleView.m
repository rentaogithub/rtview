//
//  LockCircleView.m
//  IMS
//
//  Created by rt on 14/6/19.
//  Copyright (c) 2014年 rentao. All rights reserved.
//

#import "LockCircleView.h"

#define OutterCircleRect              RECT(2.5, 2.5, 60, 60)
#define InnerCircleRect               RECT(22.5, 22.5, 21, 21)
#define OutterCircleDefaultColor      RGBACOLOR(204, 204, 204, 1.0).CGColor
#define OutterCircleRightColor        RGBACOLOR(104, 224, 6, 1.0).CGColor
#define OutterCircleWrongColor        RGBACOLOR(243, 92, 17, 1.0).CGColor
#define InnerCircleDefaultColor      RGBACOLOR(204, 204, 204, 1.0).CGColor
#define InnerCircleRightColor        RGBACOLOR(104, 224, 6, 1.0).CGColor
#define InnerCircleWrongColor        RGBACOLOR(243, 92, 17, 1.0).CGColor

@implementation LockCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setCurLockStatus:(LockStatus)lockCircleStatus {
    _curLockStatus = lockCircleStatus;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef curContext = UIGraphicsGetCurrentContext();
    switch (self.curLockStatus) {
        case LockStatusDefault:
            [self drawCircle:curContext outterColor:OutterCircleDefaultColor innerColor:InnerCircleDefaultColor];
            break;
        case LockStatusRight:
            [self drawCircle:curContext outterColor:OutterCircleRightColor innerColor:InnerCircleRightColor];
            break;
        default:
            [self drawCircle:curContext outterColor:OutterCircleWrongColor innerColor:InnerCircleWrongColor];
            break;
    }
}

- (void)drawCircle:(CGContextRef)curContext outterColor:(CGColorRef)ocolorRef innerColor:(CGColorRef)icolorRef {
    //outer circle
    CGContextSetLineWidth(curContext, 5);
    CGContextSetStrokeColorWithColor(curContext, ocolorRef);
    CGContextStrokeEllipseInRect(curContext,OutterCircleRect);
    
    //inner circle
    CGContextSetLineWidth(curContext, 10.5);
    CGContextSetFillColorWithColor(curContext, icolorRef);
    CGContextFillEllipseInRect(curContext, InnerCircleRect);
}

@end
