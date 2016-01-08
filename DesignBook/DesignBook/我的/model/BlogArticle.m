//
//  BlogArticle.m
//  DesignBook
//
//  Created by 陈行 on 16-1-7.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "BlogArticle.h"
#import "NSObject+KVC.h"

@implementation BlogArticle

+ (instancetype)blogArticleWithDict:(NSDictionary *)dict{
    return [self objectWithDict:dict];
}

@end
