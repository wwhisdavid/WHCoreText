//
//  CTDisplayView.h
//  DyCoreText
//
//  Created by david on 15/8/17.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextData.h"
@class CTDataEntity;
@class CTFrameParserConfig;
@class CTDisplayView;

@protocol CTDisplayViewDelegate <NSObject>

@optional

- (void)displayView:(CTDisplayView *)displayView didTouchURL:(NSURL *)url;
- (void)displayView:(CTDisplayView *)displayView didTouchTopic:(NSString *)topicID;

@end

@interface CTDisplayView : UIView

@property (strong, nonatomic) CoreTextData * data;
@property (weak, nonatomic) id<CTDisplayViewDelegate> delegate;

- (CoreTextData *)matchWithText:(NSString *)text andConfig:(CTFrameParserConfig *)config;

- (CoreTextData *)matchWithConfig:(CTFrameParserConfig *)config andTextEntity:(CTDataEntity *)entity;

@end
