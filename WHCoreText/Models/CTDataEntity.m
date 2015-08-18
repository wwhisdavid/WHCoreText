//
//  CTDataEntity.m
//  DyCoreText
//
//  Created by david on 15/8/18.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "CTDataEntity.h"

@implementation CTDataEntity

- (NSMutableArray *)linkArray
{
    if (_linkArray == nil) {
        _linkArray = [[NSMutableArray alloc] init];
    }
    return _linkArray;
}

@end
