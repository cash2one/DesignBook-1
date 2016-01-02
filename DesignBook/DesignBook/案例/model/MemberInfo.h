//
//  MemberInfo.h
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberInfo : NSObject

@property(nonatomic,assign)NSInteger uid;
@property(nonatomic,assign)NSInteger identity;
@property(nonatomic,assign)NSInteger goodlevel;
@property(nonatomic,assign)NSInteger rz;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic,copy)NSString * facePic;
@property(nonatomic,copy)NSString * goodlevelCN;
@property(nonatomic,copy)NSString * rzCN;

+ (instancetype)memberInfoWithDict:(NSDictionary *)dict;

@end
