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

@property(nonatomic,assign)NSInteger fansNum;
@property(nonatomic,assign)NSInteger yuyueNum;
@property(nonatomic,assign)NSInteger qiandanNum;
@property(nonatomic,assign)NSInteger appraiseNum;
@property(nonatomic,assign)NSInteger goodAppraise;
@property(nonatomic,assign)NSInteger isFocus;
@property(nonatomic,copy)NSString * phoneNum400;
@property(nonatomic,copy)NSString * extensionNum;
@property(nonatomic,copy)NSString * feeRand;
@property(nonatomic,copy)NSString * haopinglv;
@property(nonatomic,copy)NSString * shen;
@property(nonatomic,copy)NSString * city;
@property(nonatomic,copy)NSString * spaceTags;
@property(nonatomic,copy)NSString * sjsUrl;
@property(nonatomic,copy)NSString * priceRange;
@property(nonatomic,copy)NSString * priceUnit;


@property(nonatomic,assign)NSInteger nowStep;
@property(nonatomic,assign)NSInteger loveStyle;

@property(nonatomic,strong)NSArray * caseList;

+ (instancetype)memberInfoWithDict:(NSDictionary *)dict;

@end
