//
//  ViewController3.m
//  DyCoreText
//
//  Created by deyi on 15/8/18.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "ViewController3.h"
#import "DyTextView.h"
#import "CTDataEntity.h"
#import "CTDataLinkEntity.h"
@interface ViewController3 ()<DyTextViewDelegate>

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CTDataEntity *entity = [[CTDataEntity alloc] init];
    entity.text = @ "新华社北京8月15日电 近一个时期以来，全国多个地区发生重特大安全生产事故，特别是天港“8·12”瑞海公司危险品仓库特别重大火灾爆炸事故，造成重大人员伤亡和财产损失。中共中央总书记、国家主席、中央军委主席习近平对切实做好安全生产#123#工作高度重视  tuicool.com/articles/NbmA7zj，8月15日再次作出重要指示11111。 ";
    //    NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:@118, @"location", @4, @"length", @"222", @"topicID", nil];
    //    debugLog(@"%@",entity.linkArray);
    CTDataLinkEntity *linkEntity = [[CTDataLinkEntity alloc] init];
    linkEntity.location = 117;
    linkEntity.length = 5;
    linkEntity.topicID = @"222";
    [entity.linkArray addObject:linkEntity];

    DyTextView *textView = [[DyTextView alloc] initWithEntity:entity];
    CGFloat width = self.view.width;
    textView.width = width;
    textView.x = 0;
    textView.y = 0;

    CGFloat height = [textView contentHeight];
    
    textView.height = height;
    
    textView.delegate2 = self;
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)test{
    UITextView *t = [[UITextView alloc] init];
    t.textColor = [UIColor redColor];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"新华社北京8月15日电 近一个时期以来，全国多个地区发生重特大安全生产事故，特别是天津"
                                       "港“8·12”瑞海公司危险品仓库特别重大火灾爆炸事故，造成重大人员伤亡和财产损失。中共中央总书记、国家主席、中央军委主席习近平对切实做好安全生产#123#工作高度重视 tuicool.com/articles/NbmA7zj ，8月15日再次作出重要指示11111。 "];
    [attr addAttribute:(NSString *)kCTForegroundColorAttributeName
                 value:(id)[UIColor blueColor].CGColor
                 range:NSMakeRange(5, 5)];
    t.attributedText = attr;
    t.selectedRange = NSMakeRange(5, 5);
    NSArray * array = [t selectionRectsForRange:t.selectedTextRange];
    debugLog(@"%@", array);
    t.frame = self.view.bounds;
    
    [self.view addSubview:t];
    UIView *view = [[UIView alloc] init];
    UITextSelectionRect *rect = [array firstObject];
    view.frame = rect.rect;
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)textView:(DyTextView *)textView didTouchURL:(NSURL *)url
{

}

- (void)textView:(DyTextView *)textView didTouchTopic:(NSString *)topicID andType:(NSString *)type
{

}
#pragma mark - delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.textView.frame.size.height;
}

#pragma mark - datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    return cell;
    
}
@end
