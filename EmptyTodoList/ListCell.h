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

- (void)onBeginEditing:(UITextField *)textField;

- (void)onDidAddRow:(id)sender;

@end

@interface ListCell : UITableViewCell<UITextFieldDelegate>

@property (strong) IBOutlet UISwitch *switchBtn;

@property (strong) IBOutlet UITextField *label;

@property (nonatomic) id<CellControl> delegate;

@property (nonatomic) NSInteger listId;

@end

