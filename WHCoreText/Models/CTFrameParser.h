//
//  CTFrameParser.h
//  DyCoreText
//
//  Created by david on 15/8/17.
//  Copyright (c) 2015年 david. All rights reserved.
//
//用于生成最后绘制界面的CTFrameRef实例
#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"

@interface CTFrameParser : NSObject

+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParserConfig *)config;

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig*)config;

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig*)config;


@end
