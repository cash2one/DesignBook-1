//
//  CustomNavigationBar.h
//  封装-webView的一些内容
//
//  Created by 陈行 on 15-12-12.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationBarItem.h"
#import "Masonry.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CustomNavigationBar : UIView

/**
 *  设置背景
 */
@property(nonatomic,copy)NSString * backgroundImageName;
@property(nonatomic,weak,readonly)UIImageView * bgImageView;
/**
 *  设置中间标题
 */
@property(nonatomic,copy)NSString * title;
@property(nonatomic,strong)UIColor * titleColor;
@property(nonatomic,weak,readonly)UILabel * titleLabel;
@property(nonatomic,weak)UIView * titleView;
/**
 *  设置左右两侧的按钮
 */
@property(nonatomic,strong)NSArray * navBarItemArray;

+ (CustomNavigationBar *)navigationBarWithBackgroundImageName:(NSString *)backgroundImageName andTitle:(NSString *)title  andNavBarItemArray:(NSArray *)navBarItemArray;

- (CustomNavigationBar *)initWithBackgroundImageName:(NSString *)backgroundImageName andTitle:(NSString *)title andNavBarItemArray:(NSArray *)navBarItemArray;

@end
