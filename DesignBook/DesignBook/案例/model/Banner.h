//
//  Banner.h
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberInfo.h"
#import "ImageInfo.h"

@interface Banner : NSObject


@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,assign)NSInteger hits;
@property(nonatomic,assign)NSInteger needLogin;

@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * imgUrl;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * module;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * comment;
@property(nonatomic,copy)NSString * shareUrl;

@property(nonatomic,strong)NSArray * imgList;
@property(nonatomic,strong)MemberInfo * memberInfo;



+ (instancetype)bannerWithDict:(NSDictionary *)dict;

- (BOOL)saveSelf;

@end
