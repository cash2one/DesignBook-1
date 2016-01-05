//
//  NSString+NilToNULL.m
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "NSString+NilToNULL.h"

@implementation NSString (NilToNULL)

+ (NSString *)nilToNull:(NSString *)value{
    if(value && value.length){
        return value;
    }
    return @"NULL";
}

@end
