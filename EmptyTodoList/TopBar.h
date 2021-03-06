//
//  TopBar.h
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/12.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopBarControl <NSObject>

- (void) onAddBtnClicked:(id)sender;

@end


@interface TopBar : UINavigationBar

@property (nonatomic) id<TopBarControl> addDlegate;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

