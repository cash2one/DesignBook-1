//
//  VersionConst.m
//  比颜值
//
//  Created by 陈行 on 15-12-1.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "VersionConst.h"

@implementation VersionConst

NSString *const APPVERSION_PLIST=@"AppVersion.plist";

NSString *const VERSION_0=@"0";
NSString *const VERSION_1_0 = @"1.0";
//创建version表
NSString *const VERSION_SQL_1_0_1 = @"CREATE TABLE IF NOT EXISTS `version_info` (`database_version`	TEXT NOT NULL);";

NSString *const VERSION_SQL_1_0_2 = @"INSERT INTO `version_info`(`database_version`) VALUES ('1.0');";

NSString *const VERSION_SQL_1_0_3 = @"CREATE TABLE `Cases` (`id`	INTEGER,`uid`	INTEGER,`counts`	INTEGER,`hits`	INTEGER,`price`	INTEGER,`area`	INTEGER,`isCollect`	INTEGER,`imgNum`	INTEGER,`commentNum`	INTEGER,`name`	TEXT,`nick`	TEXT,`facePic`	TEXT,`imgUrl`	TEXT,`styleName`	TEXT,`priceName`	TEXT,`areaName`	TEXT,`spaceName`	TEXT,`comment`	TEXT,`feeRand`	TEXT,`phoneNum400`	TEXT,`extensionNum`	TEXT,`shareUrl`	TEXT);";

NSString *const VERSION_SQL_1_0_4 = @"CREATE TABLE `Parsing` (`Id`	INTEGER,`title`	TEXT,`imgUrl`	TEXT,`needLogin`	TEXT,`imgTitle1`	TEXT,`imgTitle2`	TEXT);";

NSString *const VERSION_SQL_1_0_5 = @"CREATE TABLE `Banner` (`Id`	INTEGER,`hits`	INTEGER,`needLogin`	INTEGER,`title`	TEXT,`imgUrl`	TEXT,`url`	TEXT,`module`	TEXT,`name`	TEXT,`comment`	TEXT,`shareUrl`	TEXT);";

NSString *const VERSION_SQL_1_0_6 = @"CREATE TABLE `PictureInfo` (`id`	INTEGER,`name`	TEXT,`imgUrl`	TEXT);";


@end
