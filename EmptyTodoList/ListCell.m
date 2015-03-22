//
//  ListCell.m
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/14.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import "ListCell.h"

static CGFloat ANAMITE_DURATION = 0.2;

@implementation ListCell

- (void)awakeFromNib {
    // Initialization code
    [_label setDelegate:self];
    _label.returnKeyType = UIReturnKeyDone;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _switchBtn.enabled = NO;
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
