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

NSMutableArray *tableListData;

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
    cell.listId = [item[@"id"] integerValue];
}

- (void)onBeginEditing:(UITextField *)textField {
    NSLog(@"123123");
}

- (void)onRefreshTable:(id)sender {
    UIRefreshControl *refreshCtrl = (UIRefreshControl *)sender;
    [refreshCtrl beginRefreshing];
    [self loadData:refreshCtrl];
}

- (void)onAddBtnClicked:(id)sender{
    NSDictionary *newRow = @{
         @"id"      : @"0",
         @"content" : @"",
         @"done"    : @"n",
         @"time"    : @""
    };
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:tableListData];
    [newArray insertObject:newRow atIndex:0 ];
    tableListData = newArray;
    [_listTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    ListCell *cell = (ListCell *)[_listTable cellForRowAtIndexPath:indexPath ];
    [cell.label becomeFirstResponder];
}

- (void)onSwitchChange:(id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    ListCell *cell = (ListCell *)switchBtn.superview.superview;
    NSInteger listId = cell.listId;
}

- (void)onLableChange:(id)sender{
    ListCell *cell = (ListCell *)sender;
    NSInteger listId = cell.listId;
    NSString *strData;
    NSString *httpMethod;
    NSURL *url;
    NSString *content = cell.label.text;
    NSString *done = cell.switchBtn.isOn == YES ? @"y" : @"n";
    if (0 == listId) {
        httpMethod = @"POST";
        strData = [[NSString alloc] initWithFormat:@"content=%@&done=%@", content, done];
        url = [NSURL URLWithString:@"http://note.perterpon.com:8000/note"];
    } else {
        httpMethod = @"PUT";
        strData = [[NSString alloc] initWithFormat:@"content=%@&done=%@&id=%ld", content, done, listId];
        url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://note.perterpon.com:8000/note/%ld", listId]];
    }
    NSLog(url.path);
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    NSLog(@"Http method:%@", httpMethod);
    [request setHTTPMethod:httpMethod];
    NSData *postData = [strData dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    NSLog(@"http 发送数据%@", strData);
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error){
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
             NSLog(@"添加成功");
         }
     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)loadData:(UIRefreshControl *)refreshCtrl {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
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
