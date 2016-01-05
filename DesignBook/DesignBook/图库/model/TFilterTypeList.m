//
//  TFilterTypeList.m
//  DesignBook
//
//  Created by 陈行 on 16-1-4.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "TFilterTypeList.h"
#import "MJExtension.h"
#import "NSObject+Description.h"


@implementation TFilterTypeList

static TFilterTypeList * sharedInstance;

+ (instancetype)sharedTFilterTypeList{
    if(sharedInstance==nil){
        [self getData];
    }
    return sharedInstance;
}

+ (void)getData{
    NSDictionary * dict=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TFilterTypeList.plist" ofType:nil]];
    sharedInstance=[self objectWithKeyValues:dict];
}

- (NSDictionary *)objectClassInArray{
    return @{@"loveStyle":[Filter class],@"nowStep":[Filter class],@"homeType":[Filter class]};
}

- (NSString *)description{
    return [self otherDescription];
}
@end
