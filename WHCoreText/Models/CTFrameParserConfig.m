//
//  CTFrameParserConfig.m
//  DyCoreText
//
//  Created by david on 15/8/17.
//  Copyright (c) 2015年 david. All rights reserved.
//
//用于配置参数
#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (id)init{
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = [UIColor blackColor];
    }
    return self;
}

@end
