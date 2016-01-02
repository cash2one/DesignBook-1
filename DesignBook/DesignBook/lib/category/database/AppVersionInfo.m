//
//  AppVersionInfo.m
//  良仓
//
//  Created by 陈行 on 15-12-23.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "AppVersionInfo.h"

@implementation AppVersionInfo

+ (instancetype)appVersionInfoWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if([key isEqualToString:@"appName"]){
//        self.appName=value;
//    }else if ([key isEqualToString:@"appVersion"]){
//        self.appVersion=value;
//    }
}

@end
