//
//  Filter.m
//  DesignBook
//
//  Created by 陈行 on 16-1-4.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "Filter.h"
#import "NSObject+KVC.h"
#import "NSObject+Description.h"
#import "MJExtension.h"

@implementation Filter

- (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}

- (NSString *)description{
    return [self otherDescription];
}

@end
