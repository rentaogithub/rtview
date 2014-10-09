//
//  LockMainView.h
//  IMS
//
//  Created by rt on 14/6/20.
//  Copyright (c) 2014年 rentao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockScreenHead.h"

@interface LockMainView : UIView

- (void)changeLockView:(LockStatus)lockStatus;
- (BOOL)checkPassword;
- (void)clearData;
@end
