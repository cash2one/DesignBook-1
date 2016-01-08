//
//  PictureCol.h
//  DesignBook
//
//  Created by 陈行 on 16-1-8.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureCol : NSObject

@property(nonatomic,assign)NSInteger colId;
@property(nonatomic,assign)NSInteger uid;

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * createTime;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic,copy)NSString * facePic;

+ (instancetype)pictureColWithDict:(NSDictionary *)dict;

@end
