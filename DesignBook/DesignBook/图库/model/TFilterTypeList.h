//
//  TFilterTypeList.h
//  DesignBook
//
//  Created by 陈行 on 16-1-4.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CasesHome.h"
#import "CoinCost.h"
#import "FindDesigner.h"
#import "WorksHome.h"
#import "WorksPublic.h"
#import "CasesPublic.h"

@interface TFilterTypeList : NSObject

@property(nonatomic,strong)NSDictionary * askType;
@property(nonatomic,strong)CasesHome * casesHome;
@property(nonatomic,strong)CoinCost * coinCost;
@property(nonatomic,strong)FindDesigner * findDesigner;
@property(nonatomic,strong)NSArray * loveStyle;
@property(nonatomic,strong)WorksHome * worksHome;
@property(nonatomic,strong)NSArray * nowStep;
@property(nonatomic,strong)WorksPublic * worksPublic;
@property(nonatomic,strong)NSArray * homeType;
@property(nonatomic,strong)CasesPublic * casesPublic;

+ (instancetype)sharedTFilterTypeList;

@end
