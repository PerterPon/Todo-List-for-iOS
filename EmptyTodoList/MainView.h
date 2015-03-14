//
//  MainView.h
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/12.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBar.h"
#import "MainList.h"
#import "MainListController.h"

@interface MainView : UIView

@property (weak) MainListController *listTableCtrl;

@end
