//
//  GCStarView.m
//  MyApp
//
//  Created by 陈诚 on 16/9/29.
//  Copyright © 2016年 陈诚. All rights reserved.
//

#import "GCStarView.h"

#define FOREGROUND_STAR_IMAGE_NAME @"starpre"
#define BACKGROUND_STAR_IMAGE_NAME @"starnor"
#define DEFALUT_STAR_NUMBER 5
#define ANIMATION_TIME_INTERVAL 0.2

@interface GCStarView ()
@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;
@property (nonatomic, assign) NSInteger numberOfStars;

@property (nonatomic,assign) BOOL isDoneLayout;
@property (nonatomic, strong) UIGestureRecognizer *gesture;

@end

@implementation GCStarView

- (instancetype)init {
    NSAssert(NO, @"You should never call this method in this class. Use initWithFrame: instead!");
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _numberOfStars = DEFALUT_STAR_NUMBER;
    [self buildDataAndUI];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _numberOfStars = DEFALUT_STAR_NUMBER;
        [self buildDataAndUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _numberOfStars = DEFALUT_STAR_NUMBER;
        [self buildDataAndUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *foregroundSubViews =  self.foregroundStarView.subviews;
    NSArray *backgroundSubViews = self.backgroundStarView.subviews;
    
    if (!_isDoneLayout) {
        int foreIndex =0;
        for (NSInteger tag = 99; tag < 99 + DEFALUT_STAR_NUMBER ; tag ++) {
            
            for (UIView *view in foregroundSubViews) {
                if ([view isKindOfClass:[UIImageView class]] && view.tag == tag) {
                    UIImageView *starImageView = (UIImageView *)view;
                    starImageView.frame = CGRectMake(foreIndex * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height);
                    foreIndex++;
                }
            }
        }
        
        int backIndex =0;
        for (int tag = 99; tag < 99 + DEFALUT_STAR_NUMBER ; tag ++) {
            for (UIView *view in backgroundSubViews) {
                if ([view isKindOfClass:[UIImageView class]] && view.tag == tag) {
                    UIImageView *starImageView = (UIImageView *)view;
                    starImageView.frame = CGRectMake(backIndex * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height);
                    backIndex++;
                }
            }
        }
        _isDoneLayout = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    CGFloat animationTimeInterval = self.hasAnimation ? ANIMATION_TIME_INTERVAL : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        NSLog(@"scorePercent:%@",[NSString stringWithFormat:@"%f",_scorePercent]);
        weakSelf.foregroundStarView.frame = CGRectMake(0, 0, self.scorePercent * (self.bounds.size.width/DEFALUT_STAR_NUMBER), weakSelf.bounds.size.height);
        NSLog(@"%@",NSStringFromCGRect(weakSelf.foregroundStarView.frame));
    }];
}

#pragma mark - Get and Set Methods
- (void)setScorePercent:(CGFloat)scroePercent {
    if (_scorePercent == scroePercent) {
        return;
    }
    
    if (scroePercent < 0) {
        _scorePercent = 0;
    }else if (scroePercent >5) {
        _scorePercent = 5;
    }
    else {
        _scorePercent = scroePercent;
    }
    
    int starCount =_scorePercent*5;
    [self setNeedsLayout];
    
    if ([self.delegate respondsToSelector:@selector(starRateView:starDidChange:)]) {
        [self.delegate starRateView:self starDidChange:starCount];
    }
}

- (void)setIsSingleShow:(BOOL)isSingleShow {
    _isSingleShow = isSingleShow;
    
    if (isSingleShow) {
        [self removeGestureRecognizer:self.gesture];
    }
}

#pragma mark - setUp UI
- (void)buildDataAndUI {
    
    if (!self.foregroundStarView && !self.backgroundStarView) {
        _scorePercent = 0;//默认为0
        _hasAnimation = NO;//默认为NO
        _allowIncompleteStar = NO;//默认为NO
        _isSingleShow = NO;//默认为NO
        
        self.foregroundStarView = [self createStarViewWithImage:FOREGROUND_STAR_IMAGE_NAME];
        self.backgroundStarView = [self createStarViewWithImage:BACKGROUND_STAR_IMAGE_NAME];
        [self addSubview:self.backgroundStarView];
        [self addSubview:self.foregroundStarView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
        tapGesture.numberOfTapsRequired = 1;
        self.gesture = tapGesture;
        [self addGestureRecognizer:tapGesture];
    }
}

- (UIView *)createStarViewWithImage:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.tag = i+99;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)userTapRateView:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    CGFloat starScore = self.allowIncompleteStar ? realStarScore : ceilf(realStarScore);
    self.scorePercent = starScore;
}
@end

