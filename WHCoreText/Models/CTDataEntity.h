//
//  CTDataEntity.h
//  DyCoreText
//
//  Created by david on 15/8/18.
//  Copyright (c) 2015年 david. All rights reserved.
//
//模型结构待定，模拟结构

#import <Foundation/Foundation.h>

@interface CTDataEntity : NSObject

/**
 *  文本，从json解析来
 */
@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) NSMutableArray *linkArray;
@end
