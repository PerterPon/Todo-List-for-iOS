//
//  ListCell.m
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/14.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
}
- (IBAction)onSwitchChange:(id)sender {
    [_delegate onSwitchChange:sender];
}

- (IBAction)onLableChange:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
