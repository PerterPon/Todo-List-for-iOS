//
//  MainList.m
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/12.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import "MainList.h"

@implementation MainList

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIRefreshControl *refreshCtrl = [[UIRefreshControl alloc] init];
    [self addSubview:refreshCtrl];
    [refreshCtrl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)onRefresh:(id)sender {
    [_refreshDelegate onRefreshTable:sender];
}

@end
