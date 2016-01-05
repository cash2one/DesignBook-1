//
//  QueAndAns.h
//  DesignBook
//
//  Created by 陈行 on 16-1-2.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueAndAns : NSObject

@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,assign)NSInteger uid;
@property(nonatomic,assign)NSInteger hits;
@property(nonatomic,assign)NSInteger comments;

@property(nonatomic,copy)NSString * createTime;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * imgUrl;
@property(nonatomic,copy)NSString * desc;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic,copy)NSString * facePic;
@property(nonatomic,copy)NSString * shareUrl;

@property(nonatomic,strong)NSArray * pics;

+ (instancetype)queAndAnsWithDict:(NSDictionary *)dict;

@end
