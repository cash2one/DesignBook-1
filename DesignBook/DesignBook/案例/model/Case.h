//
//  Case.h
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageInfo.h"

@interface Case : NSObject

@property(nonatomic,assign)NSInteger id;
@property(nonatomic,assign)NSInteger uid;
@property(nonatomic,assign)NSInteger counts;
@property(nonatomic,assign)NSInteger hits;
@property(nonatomic,assign)NSInteger price;
@property(nonatomic,assign)NSInteger area;
@property(nonatomic,assign)NSInteger isCollect;
@property(nonatomic,assign)NSInteger imgNum;
@property(nonatomic,assign)NSInteger commentNum;

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic,copy)NSString * facePic;
@property(nonatomic,copy)NSString * imgUrl;
@property(nonatomic,copy)NSString * styleName;
@property(nonatomic,copy)NSString * priceName;
@property(nonatomic,copy)NSString * areaName;
@property(nonatomic,copy)NSString * spaceName;
@property(nonatomic,copy)NSString * comment;
@property(nonatomic,copy)NSString * feeRand;
@property(nonatomic,copy)NSString * phoneNum400;
@property(nonatomic,copy)NSString * extensionNum;
@property(nonatomic,copy)NSString * shareUrl;

@property(nonatomic,strong)NSArray * imgList;


+ (instancetype)caseWithDict:(NSDictionary *)dict;

@end
