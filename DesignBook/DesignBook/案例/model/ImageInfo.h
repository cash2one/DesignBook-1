//
//  ImageInfo.h
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageInfo : NSObject

@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,assign)NSInteger width;
@property(nonatomic,assign)NSInteger height;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * comment;
@property(nonatomic,copy)NSString * imgUrl;


+ (instancetype)imageInfoWithDict:(NSDictionary *)dict;

@end
