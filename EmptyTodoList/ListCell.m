//
//  ListCell.m
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/14.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import "ListCell.h"

static CGFloat ANAMITE_DURATION = 0.2;

CGRect editingPosition;

@implementation ListCell

- (void)awakeFromNib {
    // Initialization code
    [_label setDelegate:self];
    _label.returnKeyType = UIReturnKeyDone;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _switchBtn.enabled = NO;
    ListCell *cell = (ListCell *)textField.superview.superview;
    NSIndexPath *indexPath = [_list indexPathForCell:cell];
    CGRect cellRect = [_list rectForRowAtIndexPath:indexPath];
    editingPosition = _list.bounds;

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat standHeight = screenRect.size.height - 40 - 273;
    CGFloat cellHeight  = cellRect.origin.y + cellRect.size.height;
    
    if ( cellHeight > standHeight ) {
        CGPoint point = CGPointMake(0, cellHeight - standHeight);
        [_list setContentOffset:point animated:YES];
    }

    [UIView animateWithDuration:ANAMITE_DURATION animations:^{
        _switchBtn.alpha = 0.2;
    }];
    [_delegate onBeginEditing:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)onFinishedEdit:(UITextField *)textField {
    [_list setContentOffset:editingPosition.origin animated:YES];
    [UIView animateWithDuration:ANAMITE_DURATION animations:^{
        _switchBtn.alpha = 1.0;
        _switchBtn.enabled = YES;
    }];
    [textField resignFirstResponder];
    [_delegate onLableChange:textField.superview.superview];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self onFinishedEdit:textField];
}

- (IBAction)onSwitchChange:(id)sender {
    [_delegate onSwitchChange:sender];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(doSwitch:) userInfo:sender repeats:NO];
}

- (void)doSwitch:(NSTimer *)timer {
    UISwitch *switchBtn = (UISwitch *)[timer userInfo];
    [_delegate onLableChange:switchBtn.superview.superview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
