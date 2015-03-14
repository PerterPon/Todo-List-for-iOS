//
//  MainListController.m
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/12.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import "MainListController.h"

@interface MainListController ()

@end

NSMutableArray *tableListData = nil;

@implementation MainListController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ( nil == tableListData) {
        return 0;
    }
    return tableListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (nil == cell) {
        cell = (ListCell *)[[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil][0];
        cell.delegate = self;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ListCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = tableListData[indexPath.row];
    cell.label.text = item[@"content"];
    [cell.switchBtn setOn:[@"n" isEqualToString:item[@"done"]]];
    cell.listId = indexPath.row;
}

- (void)onRefreshTable:(id)sender {
    UIRefreshControl *refreshCtrl = (UIRefreshControl *)sender;
    [refreshCtrl beginRefreshing];
    [self loadData:refreshCtrl];
}

- (void)onAddBtnClicked:(id)sender{
    
}

- (void)onSwitchChange:(id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    ListCell *cell = (ListCell *)switchBtn.superview.superview;
    NSInteger listId = cell.listId;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)loadData:(UIRefreshControl *)refreshCtrl {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd"];
    NSString *today = [formatter stringFromDate:[NSDate date]];
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://note.perterpon.com:8000/note/%@",today]];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    static NSString *httpMethod = @"GET";
    [request setURL:url];
    [request setHTTPMethod:httpMethod];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
        ^(NSURLResponse *response, NSData *data, NSError *error){
            if (nil != refreshCtrl) {
                [refreshCtrl endRefreshing];
            }
            NSInteger responseCode = [(NSHTTPURLResponse *) response statusCode];
            BOOL hasError = false;
            if (200 != responseCode) {
                hasError = true;
            }
            if (error || true == hasError) {
                static NSString *title   = @"提示";
                static NSString *message = @"加载出错, 请稍后再试!";
                static NSString *btnMsg  = @"确定";
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:btnMsg, nil];
                [alert show];
            } else {
                NSError *error = nil;
                NSMutableArray *resData = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                tableListData = resData;
                [_listTable reloadData];
            }
        }];
}

@end
