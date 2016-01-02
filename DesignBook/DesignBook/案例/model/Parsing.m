//
//  Parsing.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "Parsing.h"
#import "NSObject+KVC.h"

@implementation Parsing

+ (instancetype)parsingWithDict:(NSDictionary *)dict{
    return [self objectWithDict:dict];
}

@end
