//
//  BlogArticle.h
//  DesignBook
//
//  Created by 陈行 on 16-1-7.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogArticle : NSObject

@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,assign)NSInteger hits;

@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * desc;
@property(nonatomic,copy)NSString * createTime;

+ (instancetype)blogArticleWithDict:(NSDictionary *)dict;

@end
