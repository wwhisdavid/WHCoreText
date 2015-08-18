//
//  CTDisplayView.m
//  DyCoreText
//
//  Created by david on 15/8/17.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "CTDataEntity.h"
#import "CTDataLinkEntity.h"
#import <CoreText/CoreText.h>
@interface CTDisplayView ()

@property (nonatomic, strong) NSMutableArray *urlArray;
@property (nonatomic, strong) NSMutableArray *topicArray;
@property (nonatomic, strong) NSMutableArray *rangeArray;
@property (nonatomic, strong) NSString *text;


@end

@implementation CTDisplayView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
    }
}

#pragma mark - NSRegularExpression

- (void)matchURL:(NSString *)text {
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

- (void)matchTopic:(NSString *)text {
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

- (void)catchTopicOrUser:(NSString *)text andCTDataEntity:(CTDataEntity *)entity
{
    [self.topicArray removeAllObjects];
    for (CTDataLinkEntity *link in entity.linkArray) {
        [self.topicArray addObject:link];
    }
}

#pragma mark - action

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //获取UITouch对象
    UITouch *touch = [touches anyObject];
    
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self];
    NSLog(@"touch:%@",NSStringFromCGPoint(location));
    
    //    CoreTextLinkData *linkdata = [CoreTextUtils touchLinkInView:self.ctView atPoint:location data:self.ctView.data];
    //    if (linkdata) {
    //        NSLog(@"hint link!");
    //        return;
    //    }
    //获取每一行
    CFArrayRef lines = CTFrameGetLines(self.data.ctFrame);
    CGPoint origins[CFArrayGetCount(lines)];
    
    //获取每行的原点坐标
    CTFrameGetLineOrigins(self.data.ctFrame, CFRangeMake(0, 0), origins);
    CTLineRef line = NULL;
    CGPoint lineOrigin = CGPointZero;
    for (int i= 0; i < CFArrayGetCount(lines); i++)
    {
        CGPoint origin = origins[i];
        CGPathRef path = CTFrameGetPath(self.data.ctFrame);
        
        //获取整个CTFrame的大小
        CGRect rect = CGPathGetBoundingBox(path);
        NSLog(@"origin:%@",NSStringFromCGPoint(origin));
        NSLog(@"rect:%@",NSStringFromCGRect(rect));
        //坐标转换，把每行的原点坐标转换为uiview的坐标体系
        CGFloat y = rect.origin.y + rect.size.height - origin.y;
        NSLog(@"y:%f",y);
        //判断点击的位置处于那一行范围内
        if ((location.y <= y) && (location.x >= origin.x))
        {
            line = CFArrayGetValueAtIndex(lines, i);
            lineOrigin = origin;
            break;
        }
    }
    location.x -= lineOrigin.x;
    //获取点击位置所处的字符位置，就是相当于点击了第几个字符
    CFIndex index = CTLineGetStringIndexForPosition(line, location);
    NSLog(@"index:%ld",index);
    //判断点击的字符是否在需要处理点击事件的字符串范围内，这里是hard code了需要触发事件的字符串范围
    if (index == (CFIndex)-1) {
        debugLog(@"点在了view之外");
        return;
    }
    
    for (NSTextCheckingResult *result in self.urlArray){
        NSRange range = result.range;
        if(index >= range.location && index <= range.location + range.length){
            
            //打开对应url
            NSURL *url = [NSURL URLWithString:[self.text substringWithRange:result.range]];
            if ([self.delegate respondsToSelector:@selector(displayView:didTouchURL:)]) {
                [self.delegate displayView:self didTouchURL:url];
            }
        }
    }
    
//    for (NSTextCheckingResult *result in self.topicArray){
//        NSRange range = result.range;
//        if(index >= range.location && index <= range.location + range.length){
//            
//            //通过服务器传的段落JSON的location找到对应location的id
//            NSString *topicID = nil;
//            //打开对应话题
//            if ([self.delegate respondsToSelector:@selector(displayView:didTouchTopic:)]) {
//                //传对应话题id进来，调用代理实现跳转。
//                [self.delegate displayView:self didTouchTopic:topicID];
//            }
//        }
//    }
    
    for (CTDataLinkEntity *link in self.topicArray){
        NSRange range = NSMakeRange(link.location, link.length);
        if(index >= range.location && index <= range.location + range.length){
            
            //通过服务器传的段落JSON的location找到对应location的id
            NSString *topicID = link.topicID;
            //打开对应话题
            if ([self.delegate respondsToSelector:@selector(displayView:didTouchTopic:)]) {
                //传对应话题id进来，调用代理实现跳转。
                [self.delegate displayView:self didTouchTopic:topicID];
            }
        }
    }
}

- (CoreTextData *)matchWithText:(NSString *)text andConfig:(CTFrameParserConfig *)config
{
    self.text = text;
    [self matchURL:text];
    [self matchTopic:text];
    
    NSDictionary *attr = [CTFrameParser attributesWithConfig:config];
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attr];
    for (NSTextCheckingResult *result in self.urlArray) {
        
        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                 value:(id)[UIColor blueColor].CGColor
                                 range:result.range];
        
        [attributedString addAttribute:(NSString *)kCTUnderlineColorAttributeName
                                 value:(id)[UIColor blueColor].CGColor
                                 range:result.range];
        
        [attributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                                 value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                                 range:result.range];
        
    }
    for (NSTextCheckingResult *result in self.topicArray) {
        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                 value:(id)[UIColor blueColor].CGColor
                                 range:result.range];
    }
    
    CoreTextData *data = [CTFrameParser parseAttributedContent:attributedString
                                                        config:config];
    return data;
}

- (CoreTextData *)matchWithConfig:(CTFrameParserConfig *)config andTextEntity:(CTDataEntity *)entity
{
    self.text = entity.text;
    [self matchURL:entity.text];
    [self catchTopicOrUser:entity.text andCTDataEntity:entity];
    
    NSDictionary *attr = [CTFrameParser attributesWithConfig:config];
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:entity.text
                                           attributes:attr];
    for (NSTextCheckingResult *result in self.urlArray) {
        
        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                 value:(id)[UIColor blueColor].CGColor
                                 range:result.range];
        
        [attributedString addAttribute:(NSString *)kCTUnderlineColorAttributeName
                                 value:(id)[UIColor blueColor].CGColor
                                 range:result.range];
        
        [attributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                                 value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                                 range:result.range];
    }
    
    for (CTDataLinkEntity *link in self.topicArray) {
        NSRange linkRange = NSMakeRange(link.location, link.length);
        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                 value:(id)[UIColor blueColor].CGColor
                                 range:linkRange];
    }
    
    CoreTextData *data = [CTFrameParser parseAttributedContent:attributedString
                                                        config:config];
    return data;
}
#pragma mark - setter and getter

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
@end
