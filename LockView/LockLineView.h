//
//  LockLineView.h
//  IMS
//
//  Created by rt on 14/6/20.
//  Copyright (c) 2014年 rentao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockScreenHead.h"

@interface LockLineView : UIView
@property (nonatomic,assign) LockStatus curLockStatus;
@property (nonatomic,strong) NSMutableArray *lineArr;
@property (nonatomic,assign) CGPoint curTouchPoint;
@end
