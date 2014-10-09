//
//  LockView.h
//  IMS
//
//  Created by rt on 14/6/23.
//  Copyright (c) 2014年 rentao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LockMainView;
@protocol LockViewDelegate;

@interface LockView : UIView

@property (nonatomic,strong) UILabel *tipLB;
@property (nonatomic,strong) LockMainView *lmView;
@property (nonatomic,strong) UIButton *forgetBtn;
@property (nonatomic,assign) id<LockViewDelegate> delegate;

- (void)removeLockNotification;
- (void)resetLockView;
@end

@protocol LockViewDelegate <NSObject>

- (void)lockViewToDetailDelegete;
- (void)forgetLockPWDelegate;

@end
