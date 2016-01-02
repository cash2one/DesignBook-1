//
//  CustomTabbar.h
//  封装-webView的一些内容
//
//  Created by 陈行 on 15-12-12.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabbarItem.h"
#import "Masonry.h"
@class CustomTabbar;

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@protocol CustomTabbarDelegate <NSObject>

- (void)tabbar:(CustomTabbar *)tabbar andIndex:(NSInteger)index;

@end

@interface CustomTabbar : UIView

@property(nonatomic,weak)UITabBarController * tbc;

@property(nonatomic,strong)NSArray * itemArray;

@property(nonatomic,copy)NSString * backgroundImageName;

@property(nonatomic,weak,readonly)UIImageView * backgroundImageView;
/**
 *  normal状态下的小标题的颜色
 */
@property(nonatomic,strong)UIColor * normalColor;
/**
 *  选中状态下的小标题颜色
 */
@property(nonatomic,strong)UIColor * selectedColor;

@property(nonatomic,assign)NSInteger currentIndex;

+ (CustomTabbar *)tabbarWithTabbarItemArray:(NSArray *)itemArray andTabbarController:(UITabBarController *)tbc;

- (CustomTabbar *)initWithTabbarItemArray:(NSArray *)itemArray andTabbarController:(UITabBarController *)tbc;

@end
