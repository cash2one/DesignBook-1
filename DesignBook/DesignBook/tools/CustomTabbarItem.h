//
//  CustomTabbarItem.h
//  封装-webView的一些内容
//
//  Created by 陈行 on 15-12-12.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTabbarItem : NSObject

@property(nonatomic,copy)NSString * controller;
@property(nonatomic,copy)NSString * imageName;
@property(nonatomic,copy)NSString * selectedImageName;
@property(nonatomic,copy)NSString * title;


+ (CustomTabbarItem *)tabbarItemWithDict:(NSDictionary *)dict;
- (CustomTabbarItem *)initWithDict:(NSDictionary *)dict;
+ (instancetype)tabbarItemWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title;
@end
