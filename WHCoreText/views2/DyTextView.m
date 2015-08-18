//
//  DyTextView.m
//  DyCoreText
//
//  Created by deyi on 15/8/18.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "DyTextView.h"
#import "CTDataLinkEntity.h"

@interface DyTextView()

@property (nonatomic, strong) NSMutableArray *urlArray;
@property (nonatomic, strong) NSMutableArray *topicArray;

@end

@implementation DyTextView

#pragma mark - init

- (instancetype)initWithEntity:(CTDataEntity *)entity
{
    self = [super init];
    if (self) {
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:entity.text];
        
        
        [self matchURL:entity.text];
        [self catchTopicOrUser:entity.text andCTDataEntity:entity];
        
        [attributeStr addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:20.0]
                             range:NSMakeRange(0, entity.text.length)];
        
        for (NSTextCheckingResult *result in self.urlArray) {
            [attributeStr addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor blueColor]
                                 range:result.range];
            
            [attributeStr addAttribute:NSUnderlineColorAttributeName
                                     value:[UIColor blueColor]
                                     range:result.range];
            
            [attributeStr addAttribute:NSUnderlineStyleAttributeName
                                     value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                                     range:result.range];       
        }
        for (CTDataLinkEntity *link in self.topicArray) {
            [attributeStr addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor blueColor]
                                 range:NSMakeRange(link.location, link.length)];
        }
        self.attributedText = attributeStr;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.editable = NO;
        self.textContainerInset = UIEdgeInsetsMake(0, - 5, 0, -5);
        self.scrollEnabled = NO;
    }
    return self;
}

#pragma mark - action

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    [self markURLWithPoint:point];
    [self markLinkWithPoint:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *childView in self.subviews) {
        if (childView.tag == 123) {
            [childView removeFromSuperview];
        }
    }
}

#pragma mark - private

- (void)markURLWithPoint:(CGPoint)point
{
    BOOL contains = NO;
    for (NSTextCheckingResult *result in self.urlArray) {
        self.selectedRange = result.range;
        
        NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
        
        self.selectedRange = NSMakeRange(0, 0);
        
        for (UITextSelectionRect *selectedRect in rects) {
            CGRect rect = selectedRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            
            if (CGRectContainsPoint(rect, point)) {
                contains = YES;
                NSURL *url = [NSURL URLWithString:[self.text substringWithRange:result.range]];
                if([self.delegate2 respondsToSelector:@selector(textView:didTouchURL:)]){
                    [self.delegate2 textView:self didTouchURL:url];
                }
                break;
            }
        }
        if (contains) {
            for (UITextSelectionRect *selectedRect in rects) {
                CGRect rect = selectedRect.rect;
                if (rect.size.width == 0 || rect.size.height == 0) continue;
                
                UIView *cover = [[UIView alloc] init];
                cover.backgroundColor = [UIColor redColor];
                cover.frame = rect;
                cover.tag = 123;
                cover.layer.cornerRadius = 5.0f;
                [self insertSubview:cover atIndex:0];
            }
            break;
        }
    }
}

- (void)matchURL:(NSString *)text {
    //url匹配
    [self.urlArray removeAllObjects];
    NSString *urlPattern = @"((((https?|file|ftp|gopher|news|nntp):(?:\\/\\/)?){0,1}(?:[\\-;:&=\\+\\$,\\w]+@)?(([0-9\\.\\-]+:[0-9]+)|(([A-Za-z0-9]+[\\.\\-])+([A-Za-z0-9]+))|(?:www\\.|[\\-;:&=\\+\\$,\\w]+@)(([A-Za-z0-9]+[\\.\\-])+([A-Za-z0-9]+))))((?:\\/[\\+~%\\/\\.\\w\\-_]*)?\\??(?:[\\-\\+=&;%@\\.\\w_]*)#?(?:[\\.\\!\\/\\\\w]*))?)";
    NSError *error;
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:urlPattern options:0 error:&error];
    if (!error) {
        NSArray *results = [regular matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        for (NSTextCheckingResult *result in results) {
            debugLog(@"%@ %@", NSStringFromRange(result.range), [text substringWithRange:result.range]);
            [self.urlArray addObject:result];
        }
    }
    else { // 如果有错误，则把错误打印出来
        debugLog(@"error - %@", error);
    }
}

- (void)catchTopicOrUser:(NSString *)text andCTDataEntity:(CTDataEntity *)entity
{
    [self.topicArray removeAllObjects];
    for (CTDataLinkEntity *link in entity.linkArray) {
        [self.topicArray addObject:link];
    }
}

- (void)markLinkWithPoint:(CGPoint)point
{
    BOOL contains = NO;
    for (CTDataLinkEntity *result in self.topicArray) {
        NSRange range = NSMakeRange(result.location, result.length);
        self.selectedRange = range;
        
        NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
        
        self.selectedRange = NSMakeRange(0, 0);
        
        for (UITextSelectionRect *selectedRect in rects) {
            CGRect rect = selectedRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            
            if (CGRectContainsPoint(rect, point)) {
                contains = YES;
                if([self.delegate2 respondsToSelector:@selector(textView:didTouchTopic:andType:)]){
                    [self.delegate2 textView:self didTouchTopic:result.topicID andType:result.type];
                    debugLog(@"%@",result.topicID);
                }
                break;
            }
        }
        if (contains) {
            for (UITextSelectionRect *selectedRect in rects) {
                CGRect rect = selectedRect.rect;
                if (rect.size.width == 0 || rect.size.height == 0) continue;
                
                UIView *cover = [[UIView alloc] init];
                cover.backgroundColor = [UIColor redColor];
                cover.frame = rect;
                cover.tag = 123;
                cover.layer.cornerRadius = 5.0f;
                [self insertSubview:cover atIndex:0];
            }
            break;
        }
    }

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

@end
