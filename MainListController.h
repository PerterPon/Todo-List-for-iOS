//
//  MainListController.h
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/12.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"
#import "MainList.h"
#import "TopBar.h"

@interface MainListController : UITableViewController<UITableViewDataSource, UITableViewDelegate, CellControl, ListControl, TopBarControl>

@property (nonatomic) MainList *listTable;

@end
