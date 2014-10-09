//
//  LockLineView.m
//  IMS
//
//  Created by rt on 14/6/20.
//  Copyright (c) 2014年 rentao. All rights reserved.
//

#import "LockLineView.h"
#import "LockCircleView.h"

#define LineDefaultColor      [UIColor clearColor].CGColor
#define LineRightColor        RGBACOLOR(166, 214, 126, 1.0).CGColor
#define LineWrongColor        RGBACOLOR(232, 172, 142, 1.0).CGColor

@implementation LockLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setCurLockStatus:(LockStatus)cLineStatus {
    _curLockStatus = cLineStatus;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if ([self.lineArr count] > 1) {
        CGContextRef curContext = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(curContext, 8.0);
        
        switch (self.curLockStatus) {
            case LockStatusDefault:
                CGContextSetStrokeColorWithColor(curContext, LineDefaultColor);
                break;
            case LockStatusRight:
                CGContextSetStrokeColorWithColor(curContext, LineRightColor);
                break;
            default:
                CGContextSetStrokeColorWithColor(curContext, LineWrongColor);
                break;
        }
        CGPoint lastPoint = CGPointZero;
        for (LockCircleView *pointCircle in self.lineArr) {
            CGPoint curPoint = pointCircle.center;
            if (CGPointEqualToPoint(lastPoint,CGPointZero)) {
                CGContextMoveToPoint(curContext, curPoint.x, curPoint.y);
            }else {
                CGContextAddLineToPoint(curContext, lastPoint.x, lastPoint.y);
            }
            lastPoint = curPoint;
        }
        CGContextAddLineToPoint(curContext, lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(curContext, self.curTouchPoint.x, self.curTouchPoint.y);
        CGContextSetLineJoin(curContext, kCGLineJoinRound); // 防止出现件角
        CGContextStrokePath(curContext);
    }
}

@end
