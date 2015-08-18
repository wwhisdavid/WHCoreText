//
//  ViewController.m
//  DyCoreText
//
//  Created by david on 15/8/17.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import "CTDisplayView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITextView *textView = [[UITextView alloc] init];
    textView.text = @"新华社北京8月15日电 近一个时期以来，全国多个地区发生重特大安全生产事故，特别是天津"
    "港“8·12”瑞海公司危险品仓库特别重大火灾爆炸事故，造成重大人员伤亡和财产损失。中共中央总书记、国家主席、中央军委主席习近平对切实做好安全生产#123#工作高度重视 www.tuicool.com/articles/NbmA7zj ，8月15日再次作出重要指示11111。 ";
    textView.frame = self.view.bounds;
    [self.view addSubview:textView];
    //url匹配
    NSString *urlPattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    //话题
//    NSString *urlPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    NSError *error;
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:urlPattern options:0 error:&error];
    if (!error) {
        NSArray *results = [regular matchesInString:textView.text options:0 range:NSMakeRange(0, textView.text.length)];
        for (NSTextCheckingResult *result in results) {
            NSLog(@"%@ %@", NSStringFromRange(result.range), [textView.text substringWithRange:result.range]);
        }
    }
    else { // 如果有错误，则把错误打印出来
    NSLog(@"error - %@", error);
    }
    CTDisplayView *dis = [[CTDisplayView alloc] init];
    dis.frame = CGRectMake(100, 100, 200, 500);
    dis.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dis];
}

- (void)testURL:(NSString *)text {
    //url匹配
    NSString *urlPattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSError *error;
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:urlPattern options:0 error:&error];
    if (!error) {
        NSArray *results = [regular matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        for (NSTextCheckingResult *result in results) {
            NSLog(@"%@ %@", NSStringFromRange(result.range), [text substringWithRange:result.range]);
        }
    }
    else { // 如果有错误，则把错误打印出来
        NSLog(@"error - %@", error);
    }

}
@end
