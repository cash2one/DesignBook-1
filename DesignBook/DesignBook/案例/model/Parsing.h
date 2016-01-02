//
//  Parsing.h
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parsing : NSObject

@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * imgUrl;
@property(nonatomic,assign)NSInteger needLogin;

@property(nonatomic,copy)NSString * imgTitle1;
@property(nonatomic,copy)NSString * imgTitle2;

+ (instancetype)parsingWithDict:(NSDictionary *)dict;

@end
