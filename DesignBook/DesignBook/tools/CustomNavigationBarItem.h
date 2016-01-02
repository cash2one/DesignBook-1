//
//  CustomNavigationBarItem.h
//  封装-webView的一些内容
//
//  Created by 陈行 on 15-12-12.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomNavigationBarItem : NSObject
/**
 *  基本信息
 */
@property(nonatomic,assign)BOOL isLeftBtn;
@property(nonatomic,assign)NSInteger itemTag;
/**
 *  button字体
 */
@property(nonatomic,copy)NSString * title;
@property(nonatomic,strong)UIColor * normalTitleColor;
@property(nonatomic,strong)UIColor * selectedTitleColor;
/**
 *  小图表
 */
@property(nonatomic,copy)NSString * normalImageName;
@property(nonatomic,copy)NSString * selectedImageName;
/**
 *  背景图
 */
@property(nonatomic,copy)NSString * normalBgImageName;
@property(nonatomic,copy)NSString * selectedBgImageName;
/**
 *  frame
 */
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)CGFloat width;
/**
 *  sel
 */
@property(nonatomic,assign)SEL sel;
/**
 *  target
 */
@property(nonatomic,strong)id target;

+ (instancetype)navigationBarItemWithNorImageName:(NSString *)normalImageName andSelectedImageName:(NSString *)selectedImageName andIsLeftBtn:(BOOL)isLeftBtn;
- (instancetype)initWithNorImageName:(NSString *)normalImageName andSelectedImageName:(NSString *)selectedImageName andIsLeftBtn:(BOOL)isLeftBtn;


@end
