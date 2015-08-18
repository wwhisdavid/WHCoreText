//
//  ViewController2.m
//  DyCoreText
//
//  Created by david on 15/8/17.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "ViewController2.h"
#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "CTDataEntity.h"
#import "CTDataLinkEntity.h"

@interface ViewController2 () <CTDisplayViewDelegate>

@property (nonatomic, strong) NSMutableArray *urlArray;
@property (nonatomic, strong) NSMutableArray *topicArray;
@property (nonatomic, strong) NSMutableArray *rangeArray;
@property (nonatomic, strong) NSString *str;

@end

@implementation ViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.textColor = [UIColor blackColor];
    config.width = 300;
    //从数据库取出对应段落
    NSString *str = @   "新华社北京8月15日电 近一个时期以来，全国多个地区发生重特大安全生产事故，特别是天津"
                        "\n\n"
                        "港“8·12”瑞海公司危险品仓库特别重大火灾爆炸事故，造成重大人员伤亡和财产损失。中共中央总书记、国家主席、中央军委主席习近平对切实做好安全生产#123#工作高度重视 www.tuicool.com/articles/NbmA7zj ，8月15日再次作出重要指示11111。 "
                        ;
//    self.str = str;
//    [self testURL:str];
//    [self testTopic:str];
//    
//    NSDictionary *attr = [CTFrameParser attributesWithConfig:config];
//    NSMutableAttributedString *attributedString =
//    [[NSMutableAttributedString alloc] initWithString:str
//                                           attributes:attr];
//    for (NSTextCheckingResult *result in self.urlArray) {
//        
//        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
//                                 value:(id)[UIColor blueColor].CGColor
//                                 range:result.range];
//        
//        [attributedString addAttribute:(NSString *)kCTUnderlineColorAttributeName
//                                 value:(id)[UIColor blueColor].CGColor
//                                 range:result.range];
//        
//        [attributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
//                                 value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle]
//                                 range:result.range];
//        
//    }
//    for (NSTextCheckingResult *result in self.topicArray) {
//        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
//                                 value:(id)[UIColor blueColor].CGColor
//                                 range:result.range];
//    }
//    
//    CoreTextData *data = [CTFrameParser parseAttributedContent:attributedString
//                                                        config:config];
    
//    CoreTextData *data = [self.ctView matchWithText:str andConfig:config];
    //模拟
    CTDataEntity *entity = [[CTDataEntity alloc] init];
    entity.text = @ "新华社北京8月15日电 近一个时期以来，全国多个地区发生重特大安全生产事故，特别是天津"
                    "\n\n"
                    "港“8·12”瑞海公司危险品仓库特别重大火灾爆炸事故，造成重大人员伤亡和财产损失。中共中央总书记、国家主席、中央军委主席习近平对切实做好安全生产#123#工作高度重视 www.tuicool.com/articles/NbmA7zj ，8月15日再次作出重要指示11111。 ";
//    NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:@118, @"location", @4, @"length", @"222", @"topicID", nil];
//    debugLog(@"%@",entity.linkArray);
    CTDataLinkEntity *linkEntity = [[CTDataLinkEntity alloc] init];
    linkEntity.location = 117;
    linkEntity.length = 5;
    linkEntity.topicID = @"222";
    [entity.linkArray addObject:linkEntity];
    debugLog(@"%@",entity.linkArray);
    
    CoreTextData *data = [self.ctView matchWithConfig:config andTextEntity:entity];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = [UIColor yellowColor];
    self.ctView.origin = CGPointMake(30, 30);
    self.ctView.width = config.width;
    debugLog(@"%f %f %f %f", self.ctView.origin.x, self.ctView.frame.origin.y, self.ctView.frame.size.width, self.ctView.frame.size.height );
    [self.view addSubview:self.ctView];
}

#pragma mark - setter and getter

- (CTDisplayView *)ctView
{
    if (_ctView == nil) {
        _ctView = [[CTDisplayView alloc] init];
        _ctView.delegate = self;
    }
    return _ctView;
}

- (NSMutableArray *)urlArray
{
    if (_urlArray == nil) {
        _urlArray = [[NSMutableArray alloc] init];
    }
    return _urlArray;
}

- (NSMutableArray *)topicArray
{
    if (_topicArray == nil) {
        _topicArray = [[NSMutableArray alloc] init];
    }
    return _topicArray;
}

- (NSMutableArray *)rangeArray
{
    if (_rangeArray == nil) {
        _rangeArray = [[NSMutableArray alloc] init];
    }
    return _rangeArray;
}
#pragma mark - test

- (void)testURL:(NSString *)text {
    //url匹配
    [self.urlArray removeAllObjects];
    NSString *urlPattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSError *error;
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:urlPattern options:0 error:&error];
    if (!error) {
        NSArray *results = [regular matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        for (NSTextCheckingResult *result in results) {
            debugLog(@"%@ %@", NSStringFromRange(result.range), [text substringWithRange:result.range]);
            [self.urlArray addObject:result];
            [self.rangeArray addObject:[NSValue valueWithRange:result.range]];
        }
    }
    else { // 如果有错误，则把错误打印出来
        debugLog(@"error - %@", error);
    }
}

- (void)testTopic:(NSString *)text {
    [self.topicArray removeAllObjects];
    NSString *urlPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";

    NSError *error;
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:urlPattern options:0 error:&error];
    if (!error) {
        NSArray *results = [regular matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        for (NSTextCheckingResult *result in results) {
            NSLog(@"%@ %@", NSStringFromRange(result.range), [text substringWithRange:result.range]);
            [self.topicArray addObject:result];
            [self.rangeArray addObject:[NSValue valueWithRange:result.range]];
        }
    }
    else { // 如果有错误，则把错误打印出来
        NSLog(@"error - %@", error);
    }
}

//#pragma mark - action
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//    //获取UITouch对象
//    UITouch *touch = [touches anyObject];
//    
//    //获取触摸点击当前view的坐标位置
//    CGPoint location = [touch locationInView:self.ctView];
//    NSLog(@"touch:%@",NSStringFromCGPoint(location));
//    
////    CoreTextLinkData *linkdata = [CoreTextUtils touchLinkInView:self.ctView atPoint:location data:self.ctView.data];
////    if (linkdata) {
////        NSLog(@"hint link!");
////        return;
////    }
//    //获取每一行
//    CFArrayRef lines = CTFrameGetLines(self.ctView.data.ctFrame);
//    CGPoint origins[CFArrayGetCount(lines)];
//    
//    //获取每行的原点坐标
//    CTFrameGetLineOrigins(self.ctView.data.ctFrame, CFRangeMake(0, 0), origins);
//    CTLineRef line = NULL;
//    CGPoint lineOrigin = CGPointZero;
//    for (int i= 0; i < CFArrayGetCount(lines); i++)
//    {
//        CGPoint origin = origins[i];
//        CGPathRef path = CTFrameGetPath(self.ctView.data.ctFrame);
//        
//        //获取整个CTFrame的大小
//        CGRect rect = CGPathGetBoundingBox(path);
//        NSLog(@"origin:%@",NSStringFromCGPoint(origin));
//        NSLog(@"rect:%@",NSStringFromCGRect(rect));
//        //坐标转换，把每行的原点坐标转换为uiview的坐标体系
//        CGFloat y = rect.origin.y + rect.size.height - origin.y;
//        NSLog(@"y:%f",y);
//        //判断点击的位置处于那一行范围内
//        if ((location.y <= y) && (location.x >= origin.x))
//        {
//            line = CFArrayGetValueAtIndex(lines, i);
//            lineOrigin = origin;
//            break;
//        }
//    }
//    location.x -= lineOrigin.x;
//    //获取点击位置所处的字符位置，就是相当于点击了第几个字符
//    CFIndex index = CTLineGetStringIndexForPosition(line, location);
//    NSLog(@"index:%ld",index);
//    //判断点击的字符是否在需要处理点击事件的字符串范围内，这里是hard code了需要触发事件的字符串范围
//    if (index == (CFIndex)-1) {
//        debugLog(@"点在了view之外");
//        return;
//    }
//    
//
//    for (NSTextCheckingResult *result in self.urlArray){
//        NSRange range = result.range;
//        if(index >= range.location && index <= range.location + range.length){
//            debugLog(@"点到URL~%lu",(unsigned long)range.location);
//            //打开对应url
//        }
//    }
//    for (NSTextCheckingResult *result in self.topicArray){
//        NSRange range = result.range;
//        if(index >= range.location && index <= range.location + range.length){
//            debugLog(@"点到话题~%lu",(unsigned long)range.location);
//            //打开对应话题
//        }
//    }

//}
#pragma mark - CTDisplayViewDelegate
- (void)displayView:(CTDisplayView *)displayView didTouchURL:(NSURL *)url
{
    debugLog(@"点击了url：%@", [url absoluteString]);
}

- (void)displayView:(CTDisplayView *)displayView didTouchTopic:(NSString *)topicID
{
    debugLog(@"话题id：%@",topicID);
}
@end
