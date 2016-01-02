//
//  GuidePageView.h
//  引导页-UIPageControl
//
//  Created by 陈行 on 15-11-10.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuidePageView;

@protocol GuidePageViewDelegate <NSObject>

- (void)btnTouchToOpenApp:(GuidePageView *)guidePageView;

@end

@interface GuidePageView : UIView

@property(nonatomic,strong)NSArray * imagesArray;
/*滚动视图*/
@property(nonatomic,weak)UIScrollView * scrollView;
/*小点*/
@property(nonatomic,weak)UIPageControl * pageCon;
/*背景图片*/
@property(nonatomic,weak)UIImageView * backgroundImage;
/*最后一页的开启app按钮*/
@property(nonatomic,weak)UIButton * openAppBtn;
/*最后一页的开启app按钮frame*/
@property(nonatomic,assign)CGRect openAppBtnFrame;
/*最后一页的开启app按钮是否打开*/
@property(nonatomic,assign)BOOL isOpenAppBtn;

@property(nonatomic,assign)BOOL isWebImage;


@property(nonatomic,weak)id<GuidePageViewDelegate> delegate;

+ (GuidePageView *)guidePageViewWithBackGroundImage:(NSString *)imageName andFrame:(CGRect)frame andIsWebImage:(BOOL)isWebImage;

- (GuidePageView *)initWithBackGroundImage:(NSString *)imageName andFrame:(CGRect)frame andIsWebImage:(BOOL)isWebImage;
/**
 *  设置是否自动播放，循环播放，播放间隔，只有当自动播放为true的时候其他两个才有效
 */
- (void)setAutoPlay:(BOOL)isAutoPlay andCirculationPlay:(BOOL)isCirculationPlay andTimeInterval:(NSInteger)timeInterval;
@end
