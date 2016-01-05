//
//  Comment.m
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "Comment.h"
#import "NSObject+KVC.h"

@implementation Comment

+ (instancetype)commentWithDict:(NSDictionary *)dict{
    return [self objectWithDict:dict];
}

@end
