//
//  DyTextView.h
//  DyCoreText
//
//  Created by deyi on 15/8/18.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTDataEntity.h"
#import "UITextView+Addition.h"
@class DyTextView;

@protocol DyTextViewDelegate <NSObject>

@optional

- (void)textView:(DyTextView *)textView didTouchURL:(NSURL *)url;
- (void)textView:(DyTextView *)textView didTouchTopic:(NSString *)topicID andType:(NSString *)type;

@end

@interface DyTextView : UITextView

/**
 *  DyTextView的委托
 */
@property (nonatomic, weak) id<DyTextViewDelegate> delegate2;

- (instancetype)initWithEntity:(CTDataEntity *)entity;

//- (CGFloat)heightWithMaxSize:(CGSize)maxSize;

@end
