//
//  LockScreenViewController.h
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/25.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol  LockScreenProtocol<NSObject>

- (void)lockScreenDone;

- (void)onSubmitEmail;

@end


@interface LockScreenViewController : UIViewController

@property (nonatomic) id<LockScreenProtocol> lockDelegate;

@end

