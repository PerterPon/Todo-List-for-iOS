//
//  AppDelegate.h
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/12.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBar.h"
#import "MainView.h"
#import "MainListController.h"
#import "LockScreenViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, LockScreenProtocol>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainView *mainView;

@end

