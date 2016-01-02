//
//  CustomWebTabbar.h
//  封装-webView的一些内容
//
//  Created by 陈行 on 15-12-14.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabbarItem.h"
@class CustomWebTabbar;

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@protocol CustomWebTabbarDelegate <NSObject>

- (void)tabbar:(CustomWebTabbar *)tabbar andIndex:(NSInteger)index andBtnArray:(NSArray *)btnArray;

@end

@interface CustomWebTabbar : UIView
/**
 *  传递来的item集合，button各类属性
 */
@property(nonatomic,strong)NSArray * itemArray;
/**
 *  背景图image
 */
@property(nonatomic,copy)NSString * backgroundImageName;
/**
 *  背景imageView
 */
@property(nonatomic,weak,readonly)UIImageView * backgroundImageView;
/**
 *  默认状态下的小标题的颜色
 */
@property(nonatomic,strong)UIColor * normalColor;
/**
 *  选中状态下的小标题颜色
 */
@property(nonatomic,strong)UIColor * selectedColor;
/**
 *  默认状态下按钮背景颜色
 */
//@property(nonatomic,strong)UIColor * normalBgColor;
/**
 *  选中状态下按钮背景颜色
 */
//@property(nonatomic,strong)UIColor * selectedBgColor;

@property(nonatomic,weak)id<CustomWebTabbarDelegate>delegate;

+ (instancetype)tabbarWithTabbarItemArray:(NSArray *)itemArray andFrame:(CGRect)frame;

- (instancetype)initWithTabbarItemArray:(NSArray *)itemArray andFrame:(CGRect)frame;

- (void)setSelectedBtnWithIndex:(NSInteger)index;
@end
