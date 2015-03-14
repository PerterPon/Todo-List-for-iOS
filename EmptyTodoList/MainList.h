//
//  MainList.h
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/12.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListControl <NSObject>

@optional

- (void)onRefreshTable:(id)sender;

@end

@interface MainList : UITableView

@property (nonatomic) id<ListControl> refreshDelegate;

@end
