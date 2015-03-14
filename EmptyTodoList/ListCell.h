//
//  ListCell.h
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/14.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellControl <NSObject>

@optional

- (void)onSwitchChange:(id)sender;

- (void)onLableChange:(id)sender;

@end

@interface ListCell : UITableViewCell

@property (strong) IBOutlet UISwitch *switchBtn;

@property (strong) IBOutlet UILabel *label;

@property (nonatomic) id<CellControl> delegate;

@property (nonatomic) NSInteger listId;

@end

