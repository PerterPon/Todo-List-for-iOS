//
//  TopBar.m
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/12.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import "TopBar.h"

@implementation TopBar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 2);
    CGFloat sigColor = (CGFloat) 201 / 255.0;
    CGContextSetRGBStrokeColor(context, sigColor, sigColor, sigColor, 1);
    CGContextBeginPath(context);
    CGSize size = rect.size;
    CGContextMoveToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextStrokePath(context);
    [self initAddBtn];
}

- (void)initAddBtn{
    CGRect btnRect = CGRectMake(20, 25, 20, 20);
    UIButton *button = [[UIButton alloc] initWithFrame:btnRect];
    [button setTitle:@"+" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:30.0];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onAddBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)onAddBtnClicked:(id)sender {
    [_delegate onAddBtnClicked:sender];
}

@end
