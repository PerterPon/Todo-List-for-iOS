//
//  AppDelegate.m
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/12.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initLockScreen];
    return YES;
}

- (void)initLockScreen{
    UIScreen *currentScreen = [UIScreen mainScreen];
    CGRect rect = [currentScreen bounds];
    LockScreenViewController *lockScreen = [[LockScreenViewController alloc] initWithNibName:@"LockScreenViewController" bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:rect];
    _window.rootViewController = lockScreen;
    lockScreen.lockDelegate = self;
    [self.window makeKeyAndVisible];
}

- (void)lockScreenDone {
    [self showTouchId];
}

- (void)onSubmitEmail {
    [self performSelectorOnMainThread:@selector(loadBasicView) withObject:self waitUntilDone:YES];
}

- (void)showTouchId {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"身份验证" reply:^(BOOL success, NSError *error) {
            if (error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证过程中发生错误, 请退出后重试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            if (success) {
                [self performSelectorOnMainThread:@selector(loadBasicView) withObject:self waitUntilDone:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证失败!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }];
    } else {
        [self performSelectorOnMainThread:@selector(loadBasicView) withObject:self waitUntilDone:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"只支持touch id身份验证"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
    }
}

- (void)loadBasicView{
    [UIView animateWithDuration:0.4f delay:0.3 options:UIViewAnimationOptionAllowAnimatedContent  animations:^{
        self.window.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self initBasicView];
        self.window.alpha = 0.0;
        [UIView animateWithDuration:0.4f animations:^{
            self.window.alpha = 1;
        }];
    }];
}

- (void)initBasicView{
    UIScreen *currentScreen = [UIScreen mainScreen];
    CGRect rect = [currentScreen bounds];
    _mainView = [[MainView alloc] initWithFrame:rect];
    MainListController *listCtrl = [[MainListController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:rect];
    _window.rootViewController = listCtrl;
    listCtrl.view = _mainView;
    _mainView.listTableCtrl = listCtrl;
    [_mainView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self initLockScreen];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showTouchId) userInfo:nil repeats:NO];
//        [self showTouchId];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
