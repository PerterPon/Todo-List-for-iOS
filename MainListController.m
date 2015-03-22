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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPatH{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCell *cell = (ListCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSInteger listId = cell.listId;
    [tableListData removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://note.perterpon.com/note/%ld", listId];
    NSURL *url = [[NSURL alloc] initWithString:urlStr ];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"DELETE"];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         NSInteger responseCode = [(NSHTTPURLResponse *) response statusCode];
         BOOL hasError = false;
         if (200 != responseCode) {
             hasError = true;
         }
         if (connectionError || true == hasError) {
             static NSString *title   = @"提示";
             static NSString *message = @"加载出错, 请稍后再试!";
             static NSString *btnMsg  = @"确定";
             UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:btnMsg, nil];
             [alert show];
         } else {
             NSLog(@"删除成功");
         }
     }];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *deleteBtnTitle = @"放弃";
    return deleteBtnTitle;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ListCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = tableListData[indexPath.row];
    cell.label.text = item[@"content"];
    [cell.switchBtn setOn:[@"n" isEqualToString:item[@"done"]]];
    cell.listId = [item[@"id"] integerValue];
}

- (void)onBeginEditing:(UITextField *)textField {
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
    [tableListData insertObject:newRow atIndex:0];
    [_listTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    ListCell *cell = (ListCell *)[_listTable cellForRowAtIndexPath:indexPath ];
    [cell.label becomeFirstResponder];
}

- (void)onSwitchChange:(id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    ListCell *cell = (ListCell *)switchBtn.superview.superview;
    NSIndexPath *indexPath = [_listTable indexPathForCell:cell];
    [tableListData removeObjectAtIndex:indexPath.row];
    [_listTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)onLableChange:(id)sender{
    ListCell *cell = (ListCell *)sender;
    NSInteger listId = cell.listId;
    NSString *strData;
    NSString *httpMethod;
    NSURL *url;
    NSString *content = cell.label.text;
    NSString *done = cell.switchBtn.isOn == YES ? @"n" : @"y";
    if (0 == listId) {
        httpMethod = @"POST";
        strData = [[NSString alloc] initWithFormat:@"content=%@&done=%@", content, done];
        url = [NSURL URLWithString:@"http://note.perterpon.com/note"];
    } else {
        httpMethod = @"PUT";
        strData = [[NSString alloc] initWithFormat:@"content=%@&done=%@&id=%ld&close=2015-01-01", content, done, listId];
        url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://note.perterpon.com/note/%ld", listId]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:httpMethod];
    [request addValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSData *postData = [strData dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
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
             [self loadData:nil];
             NSLog(@"添加成功");
         }
     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)loadData:(UIRefreshControl *)refreshCtrl {
    static NSString *urlStr = @"http://note.perterpon.com/note";
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
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
                tableListData = [resData mutableCopy];
                [_listTable reloadData];
            }
        }];
}

@end
