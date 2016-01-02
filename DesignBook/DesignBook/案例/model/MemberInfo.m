//
//  MemberInfo.m
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "MemberInfo.h"
#import "NSObject+KVC.h"

@implementation MemberInfo

+ (instancetype)memberInfoWithDict:(NSDictionary *)dict{
    return [self objectWithDict:dict];
}

@end
