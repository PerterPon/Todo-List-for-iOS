//
//  MainView.m
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/12.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import "MainView.h"

@implementation MainView

NSInteger TOP_BAR_HEIGHT = 60;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self initTopBar:rect];
    [self initTable:rect];
}

- (void)initTopBar:(CGRect) rect{
    CGRect topBarRect = CGRectMake(0.0, 00.0, rect.size.width, TOP_BAR_HEIGHT);
    TopBar *topBar = [[TopBar alloc] initWithFrame:topBarRect];
    [topBar setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [self addSubview:topBar];
    topBar.delegate = _listTableCtrl;
}

- (void)initTable:(CGRect) rect{
    CGRect listRect = CGRectMake(0.0, 60.0, rect.size.width, rect.size.height - TOP_BAR_HEIGHT);
    MainList *mainList = [[MainList alloc] initWithFrame:listRect];
    [self addSubview:mainList];
    mainList.dataSource = _listTableCtrl;
    mainList.delegate   = _listTableCtrl;
    mainList.refreshDelegate = _listTableCtrl;
    _listTableCtrl.listTable = mainList;
}

@end