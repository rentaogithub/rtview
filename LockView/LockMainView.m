//
//  LockMainView.m
//  IMS
//
//  Created by rt on 14/6/20.
//  Copyright (c) 2014年 rentao. All rights reserved.
//

#import "LockMainView.h"
#import "LockCircleView.h"
#import "LockLineView.h"

@interface LockMainView() {
    LockLineView *lockLineView;
}

@property (nonatomic,strong) NSMutableArray *allCircleArr;
@property (nonatomic,strong) NSMutableArray *pathsToArr; // 经过的点
@property (nonatomic,strong) NSString *firstPW;
- (void)addCircleView;
- (void)checkPointToCircleView:(CGPoint)point;
- (NSString *)getPassword;

@end


@implementation LockMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        self.allCircleArr = [NSMutableArray arrayWithCapacity:0];
        self.pathsToArr = [NSMutableArray arrayWithCapacity:0];
        [self addCircleView];
    }
    return self;
}

- (void)addCircleView {
    lockLineView = [[LockLineView alloc] initWithFrame:self.bounds];
    [lockLineView setCurLockStatus:LockStatusRight];
    [self addSubview:lockLineView];
    for (int i = 0; i<9; i++) {
        int column =  i % 3;
		int row    = i / 3;
        float startX = 30 + 97.5 * column;
        float startY = 10 + 97.5 * row;
        LockCircleView *circleView = [[LockCircleView alloc] initWithFrame:RECT(startX, startY, 65, 65)];
        circleView.tag = i+1;
        [self.allCircleArr addObject:circleView];
        [self addSubview:circleView];
    }
}

- (void)checkPointToCircleView:(CGPoint)point {
    for (LockCircleView *circleView in self.allCircleArr) {
        if (CGRectContainsPoint(circleView.frame,point)) {
            if (circleView.curLockStatus != LockStatusRight) {
                [circleView setCurLockStatus:LockStatusRight];
            }
            if ([self.pathsToArr count] > 0) {
                if (![self.pathsToArr containsObject:circleView]) {
                    [self.pathsToArr addObject:circleView];
                }
                lockLineView.curTouchPoint = circleView.center;
                if ([self.pathsToArr count] > 1) { // draw line
                    if ([lockLineView.lineArr count] != [self.pathsToArr count]) {
                        lockLineView.lineArr = self.pathsToArr;
                        [lockLineView setNeedsDisplay];
                    }
                }
            }else {
                [self.pathsToArr addObject:circleView];
            }
            return;
        }else {
            if ([self.pathsToArr count] > 1) {
                lockLineView.curTouchPoint = point;
                [lockLineView setNeedsDisplay];
            }
        }
    }
}

- (void)changeLockView:(LockStatus)lockStatus{
    switch (lockStatus) {
        case LockStatusDefault:
            for (LockCircleView *circleView in self.pathsToArr) {
                [circleView setCurLockStatus:LockStatusDefault];
            }
            [lockLineView setCurLockStatus:LockStatusDefault];
            [self.pathsToArr removeAllObjects];
            [lockLineView setCurLockStatus:LockStatusRight];
            break;
        case LockStatusRight:
            break;
        default:
            for (LockCircleView *circleView in self.pathsToArr) {
                [circleView setCurLockStatus:LockStatusWrong];
            }
            [lockLineView setCurLockStatus:LockStatusWrong];
            break;
    }
}

- (BOOL)checkPassword {
    if ([self.pathsToArr count] < 4) {
        return NO;
    }
    return YES;
}

- (NSString *)getPassword {
    NSMutableString *pwStr = [NSMutableString stringWithCapacity:0];
    for (LockCircleView *circleView in self.pathsToArr) {
        [pwStr appendFormat:@"%i",circleView.tag];
    }
    return pwStr;
}

- (void)clearData {
    self.firstPW = nil;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint startPoint = [[touches anyObject] locationInView:self];
    [self checkPointToCircleView:startPoint];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint movePoint = [[touches anyObject] locationInView:self];
    [self checkPointToCircleView:movePoint];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    LockCircleView *circleView = (LockCircleView *)[self.pathsToArr lastObject];
    CGPoint lastPoint = circleView.center;
    lockLineView.curTouchPoint = lastPoint; // 清除终点的画线
    [lockLineView setNeedsDisplay];
    //验证密码
    NSDictionary *ndic = nil;
    if ([ToolKit isFirstToDrawPassword]) { // 第一次绘制图形密码
        if ([self checkPassword]) { //密码至少四位
            if (!self.firstPW) {
                self.firstPW = [self getPassword];
                ndic = @{@"action": @(1)};
            }else {
                NSString *secondPW = [self getPassword];
                ndic = @{@"action": @(2),@"firstpw":self.firstPW,@"secondpw":secondPW};
            }
        }else {
            ndic = @{@"action": @(3)};
        }
    }else {
        if ([self checkPassword]) {
            ndic = @{@"action": @(4),@"checkpw":[self getPassword]};
        } else {
            ndic = @{@"action": @(3)};
        }
    }
    self.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:LockNotification object:ndic];
}

@end
