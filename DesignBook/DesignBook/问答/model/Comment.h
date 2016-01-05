//
//  Comment.h
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property(nonatomic,assign)NSInteger uid;
@property(nonatomic,assign)NSInteger answerId;
@property(nonatomic,assign)NSInteger identity;
@property(nonatomic,assign)NSInteger praiseNum;
@property(nonatomic,assign)NSInteger toUid;

@property(nonatomic,copy)NSString * nick;
@property(nonatomic,copy)NSString * facePic;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * createTime;
@property(nonatomic,copy)NSString * imgUrl;
@property(nonatomic,copy)NSString * toNick;

+ (instancetype)commentWithDict:(NSDictionary *)dict;


@end
