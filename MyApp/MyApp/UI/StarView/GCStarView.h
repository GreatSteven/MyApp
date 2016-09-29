//
//  GCStarView.h
//  MyApp
//
//  Created by 陈诚 on 16/9/29.
//  Copyright © 2016年 陈诚. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GCStarView;

@protocol GCStarViewDelegate <NSObject>
@optional
- (void)starRateView:(GCStarView *)starRateView starDidChange:(int)starCount;
@end

@interface GCStarView : UIView

@property (nonatomic, assign) CGFloat scorePercent;//得分值，范围为0-5，默认为0
@property (nonatomic, assign) BOOL hasAnimation;//是否允许动画，默认为NO
@property (nonatomic, assign) BOOL allowIncompleteStar;//评分时是否允许不是整星，默认为NO
@property (nonatomic,assign) BOOL isSingleShow;// 是否是仅显示评分数且不可进行评分

@property (nonatomic, weak) id<GCStarViewDelegate>delegate;
@end

