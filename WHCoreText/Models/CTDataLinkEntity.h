//
//  CTDataLinkEntity.h
//  DyCoreText
//
//  Created by david on 15/8/18.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTDataLinkEntity : NSObject

/**
 *  话题或者@用户的链接id
 */
@property (nonatomic, copy) NSString *topicID;

/**
 *  话题或者@用户在文本中的位置
 */
@property (nonatomic, assign) NSInteger location;

/**
 *  话题或者@用户在文本中的长度
 */
@property (nonatomic, assign) NSInteger length;


@end
