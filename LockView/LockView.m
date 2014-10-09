//
//  LockView.m
//  IMS
//
//  Created by rt on 14/6/23.
//  Copyright (c) 2014年 rentao. All rights reserved.
//

#import "LockView.h"
#import "LockMainView.h"
#import "LockScreenHead.h"

@interface LockView ()

- (void)addSubViewAction;
- (void)doFindPasswordAction;
- (void)doRedrawAction:(NSNotification *)notifi;

@end

@implementation LockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViewAction];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRedrawAction:) name:LockNotification object:nil];
    }
    return self;
}

- (void)removeLockNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LockNotification object:nil];
}

- (void)resetLockView {
    _tipLB.text = @"请绘制图形密码";
    _tipLB.textColor = [UIColor blackColor];
    [_tipLB shake];
    [_lmView clearData];
    [_lmView changeLockView:LockStatusDefault];
    [ToolKit saveFirstToDrawPassword:YES];
    [ToolKit deleteLockPassword];
}

- (void)addSubViewAction {
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:RECT((CGRectGetWidth(self.frame)-200)/2, 15, 200, 30)];
    nameLabel.text = [ToolKit getUserName];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = FONTSYSTEM(17);
    [self addSubview:nameLabel];
    CGFloat iHeight = iPhone5?20:0;
    _tipLB = ({
        UILabel *tlb = [[UILabel alloc]initWithFrame:RECT(0, 45+iHeight, 320, 30)];
        if ([ToolKit isFirstToDrawPassword]) {
            tlb.text = @"请绘制图形密码";
        }
        tlb.textAlignment = NSTextAlignmentCenter;
        tlb.backgroundColor = [UIColor clearColor];
        tlb.font = FONTSYSTEM(15);
        tlb;
    });
    [self addSubview:_tipLB];
    
    iHeight = iPhone5?(iHeight+20):0;
    
    _lmView = ({
        LockMainView *lmv = [[LockMainView alloc] initWithFrame:RECT(0, 80+iHeight, 320, 280)];
        lmv;
    });
    [self addSubview:_lmView];
    
    iHeight = iPhone5?(iHeight+30):0;
    _forgetBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = FONTSYSTEM(16);
        btn.frame = RECT((CGRectGetWidth(self.frame)-120)/2, 370+iHeight, 120, 30);
        [btn setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doFindPasswordAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:_forgetBtn];
    
}

- (void)doFindPasswordAction {
    if ([self.delegate respondsToSelector:@selector(forgetLockPWDelegate)]) {
        [self.delegate forgetLockPWDelegate];
    }
}

- (void)doRedrawAction:(NSNotification *)notifi {
    NSDictionary *lockDic = (NSDictionary *)notifi.object;
    NSInteger actionNumber = [lockDic[@"action"] integerValue];
    dispatch_time_t disTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    [_tipLB shake];
    switch (actionNumber) {
        case 1:
            _tipLB.text = @"请确认绘制图形密码";
            _tipLB.textColor = [UIColor blackColor];
            [_lmView changeLockView:LockStatusDefault];
            break;
        case 2:
            if ([lockDic[@"firstpw"] isEqualToString:lockDic[@"secondpw"]]) {
                [ToolKit saveFirstToDrawPassword:NO];
                [ToolKit saveLockPassword:lockDic[@"firstpw"]];
                [_lmView clearData];
                if ([self.delegate respondsToSelector:@selector(lockViewToDetailDelegete)]) {
                    [self.delegate lockViewToDetailDelegete];
                }
            }else {
                _tipLB.text = @"确认绘制图形密码不一致";
                _tipLB.textColor = [UIColor redColor];
                [_lmView changeLockView:LockStatusWrong];
            }
            break;
        case 3:
            _tipLB.text = @"绘制图形密码至少四位";
            _tipLB.textColor = [UIColor redColor];
            [_lmView changeLockView:LockStatusWrong];
            break;
            
        default:
        {
            NSString *checkPW = [ToolKit getLockPass];
            if ([checkPW isEqualToString:lockDic[@"checkpw"]]) {
                if ([self.delegate respondsToSelector:@selector(lockViewToDetailDelegete)]) {
                    [self.delegate lockViewToDetailDelegete];
                }
            }else {
                _tipLB.text = @"图形密码不对";
                _tipLB.textColor = [UIColor redColor];
                [_lmView changeLockView:LockStatusWrong];
            }
        }
            break;
    }
    dispatch_after(disTime, dispatch_get_main_queue(), ^(void){
        [_lmView changeLockView:LockStatusDefault];
        _lmView.userInteractionEnabled = YES;
    });
}
@end
