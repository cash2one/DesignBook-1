//
//  AppVersionInfo.h
//  良仓
//
//  Created by 陈行 on 15-12-23.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppVersionInfo : NSObject

@property(nonatomic,copy)NSString *appName;

@property(nonatomic,copy)NSString * appVersion;

+ (instancetype)appVersionInfoWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
