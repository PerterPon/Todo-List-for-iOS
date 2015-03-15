//
//  TopBar.m
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/12.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import "TopBar.h"

@implementation TopBar

- (void) drawRect:(CGRect)rect {
    CGRect screenRect  = [[UIScreen mainScreen] bounds];
    CGRect newRect     = CGRectMake( 0.0, 20.0, screenRect.size.width, 40.0);
    [self setFrame:newRect];
    [self initSeparateLine:rect];
    [self initAddBtn];
    [super drawRect:rect];
}

- (void)initSeparateLine:(CGRect) rect {
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
}

- (void)initAddBtn{
    CGRect btnRect = _addBtn.frame;
    btnRect.size = CGSizeMake(30.0, 30.0);
    [_addBtn setFrame:btnRect];
    [_addBtn addTarget:self action:@selector(onAddBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onAddBtnClicked:(id)sender {
    [_addDlegate onAddBtnClicked:sender];
}

@end
