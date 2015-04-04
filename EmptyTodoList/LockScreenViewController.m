//
//  LockScreenViewController.m
//  EmptyTodoList
//
//  Created by 王 羽涵 on 15/3/25.
//  Copyright (c) 2015年 note.perterpon.com. All rights reserved.
//

#import "LockScreenViewController.h"

@interface LockScreenViewController ()

@end

UIButton *submitEmail = nil;

UITextField *email = nil;

@implementation LockScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    NSString *titleText = @"Todo List";
    UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue" size:40];
    NSDictionary *titleSizeAttribute = @{
                                         NSFontAttributeName : titleFont
    };
    CGSize titleSize = [titleText sizeWithAttributes:titleSizeAttribute];
    CGRect titleRect = CGRectMake(rect.size.width / 2 - titleSize.width / 2, rect.size.height / 2 - titleSize.height / 2, 0, 0);
    titleRect.size   = titleSize;
    UILabel *title = [[UILabel alloc] initWithFrame:titleRect];
    title.text = @"Todo List";
    [title setFont:titleFont];
    title.textColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.view addSubview:title];

    CGFloat fieldX = ( rect.size.width - ( 200 + 60 + 10 ) ) / 2;
    CGFloat fieldY = rect.size.height / 2 - 35 / 2;
    CGRect fieldRect = CGRectMake( fieldX, fieldY, 200, 35);
    email = [[UITextField alloc] initWithFrame:fieldRect];
    [email setBorderStyle:UITextBorderStyleLine];
    email.layer.cornerRadius  = 3.0f;
    email.layer.borderColor   = [[UIColor whiteColor] CGColor];
    email.layer.borderWidth   = 1.0;
    email.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    email.placeholder         = @"请输入邮箱";
    email.alpha               = 0;
    [self.view addSubview:email];
    
    CGFloat btnX = fieldX + 200 + 10;
    CGFloat btnY = rect.size.height / 2 - 35 / 2;
    CGRect btnRect = CGRectMake( btnX, btnY, 60, 35);
    submitEmail = [[UIButton alloc] initWithFrame:btnRect];
    [submitEmail setTitle:@"确定" forState:UIControlStateNormal];
    submitEmail.alpha     = 0;
    [submitEmail addTarget:self action:@selector(submitEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitEmail];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults stringForKey:@"userId"];
    Boolean hasLogin = nil != userId;
    [UIView animateWithDuration:1.5 delay:0.8 options:UIViewAnimationOptionAllowAnimatedContent  animations:^{
        CGRect newRect = CGRectMake(rect.size.width / 2 - titleSize.width / 2, rect.size.height / 2 - titleSize.height / 2 - 100, 0, 0);
        newRect.size = titleSize;
        title.frame = newRect;
        if ( false == hasLogin) {
            email.alpha = 1;
            submitEmail.alpha = 1;
        }
    } completion:^(BOOL finished) {
        if ( true == hasLogin) {
            [_lockDelegate lockScreenDone];
        }
    }];
}

- (void)submitEmail {
    NSString *emailStr = email.text;
    NSURL *url = [[NSURL alloc] initWithString:@"http://note.perterpon.com/user"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *strData = [[NSString alloc] initWithFormat:@"email=%@", emailStr];
    [request setHTTPBody:[strData dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        BOOL hasError = false;
        if ( 200 != [(NSHTTPURLResponse *) response statusCode] ) {
            hasError = true;
        }
        if ( connectionError || true == hasError ) {
            static NSString *title   = @"提示";
            static NSString *message = @"加载出错, 请稍后再试!";
            static NSString *btnMsg  = @"确定";
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:btnMsg, nil];
            [alert show];
        } else {
            NSString *userId = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:userId forKey:@"userId"];
            [_lockDelegate onSubmitEmail];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
