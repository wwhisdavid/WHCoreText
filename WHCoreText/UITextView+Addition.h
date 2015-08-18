//
//  UITextView+Addition.h
//  DBYS
//
//  Created by Bell on 14-1-3.
//  Copyright (c) 2014年 Bell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Addition)

//- (CGSize)contentSize;

+ (CGFloat)contentViewHeightOffset;

/**
 * when editable is YES
 **/
- (CGFloat)editableContentHeight;
/**
 * when editable is NO
 **/
- (CGFloat)unEditableContentHeight;
/**
 * no matter editable is YES or NO
 **/
- (CGFloat)contentHeight;

@end
