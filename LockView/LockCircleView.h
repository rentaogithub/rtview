//
//  LockCircleView.h
//  IMS
//
//  Created by rt on 14/6/19.
//  Copyright (c) 2014年 rentao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LockScreenHead.h"

@interface LockCircleView : UIView

@property (nonatomic,assign)LockStatus curLockStatus;

- (void)drawCircle:(CGContextRef)curContext outterColor:(CGColorRef)ocolorRef innerColor:(CGColorRef)icolorRef;
@end
