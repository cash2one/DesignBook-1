//
//  Banner.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "Banner.h"
#import "NSObject+KVC.h"

@implementation Banner

+ (instancetype)bannerWithDict:(NSDictionary *)dict{
    Banner * banner = [self objectWithDict:dict];
    if(banner.memberInfo!=nil){
        NSDictionary * memInfoDict = (NSDictionary *)banner.memberInfo;
        banner.memberInfo=[MemberInfo memberInfoWithDict:memInfoDict];
    }
    return banner;
}

@end
