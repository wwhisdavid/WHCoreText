//
//  UITextView+Addition.m
//  DBYS
//
//  Created by Bell on 14-1-3.
//  Copyright (c) 2014年 Bell. All rights reserved.
//

#import "UITextView+Addition.h"

@implementation UITextView (Addition)


+ (CGFloat)contentViewHeightOffset
{
    return 16.f;
}

- (CGFloat)editableContentHeight
{
    CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, FLT_MAX)];
    return size.height;
}

- (CGFloat)unEditableContentHeight
{
    CGRect oldFrame = self.frame;    
    [self sizeToFit];
    
    CGRect newFrame = self.frame;
    self.frame = oldFrame;
    
    return newFrame.size.height;
}

- (CGFloat)contentHeight
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        if (self.editable) {
            return [self editableContentHeight];
        } else {
            return [self unEditableContentHeight];
        }
    } else {
        return [self contentSize].height;
    }
}

@end
