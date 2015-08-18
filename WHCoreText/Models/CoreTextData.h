//
//  CoreTextData.h
//  DyCoreText
//
//  Created by david on 15/8/17.
//  Copyright (c) 2015年 david. All rights reserved.
//
//用于保存由CTFrameParser类生成的CTFrameRef实例以及CTFrameRef实际绘制需要的高度

#import <Foundation/Foundation.h>

@interface CoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSAttributedString *content;

@end
