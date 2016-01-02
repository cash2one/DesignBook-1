//
//  CustomTabbarItem.m
//  封装-webView的一些内容
//
//  Created by 陈行 on 15-12-12.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CustomTabbarItem.h"

@implementation CustomTabbarItem

+ (CustomTabbarItem *)tabbarItemWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

- (CustomTabbarItem *)initWithDict:(NSDictionary *)dict{
    if(self=[super init]){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


+ (instancetype)tabbarItemWithTitle:(NSString *)title{
    return [[self alloc]initWithTitle:title];
}
- (instancetype)initWithTitle:(NSString *)title{
    if(self=[super init]){
        self.title=title;
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@---->%@",key,value);
}

@end
