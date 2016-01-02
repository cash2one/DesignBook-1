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

NSString *const VERSION_SQL_1_0_2 = @"CREATE TABLE IF NOT EXISTS `subject` (`access_url`	TEXT,`addtime`	TEXT,`author_id`	TEXT,`cat_id`	TEXT,`cat_name`	TEXT,`cover_img`	TEXT,`cover_img_new`	TEXT,`goods_number`	TEXT,`hit_number`	TEXT,`img_path`	TEXT,`is_published`	TEXT,`is_show_list`	TEXT,`publish_time`	TEXT,`publish_type`	TEXT,`taid`	TEXT,`topic_name`	TEXT,`topic_url`	TEXT,`author_name`	TEXT,`nav_title`	TEXT);";

NSString *const VERSION_SQL_1_0_3 = @"INSERT INTO `version_info`(`database_version`) VALUES ('1.0');";

NSString *const VERSION_SQL_1_0_4 = @"CREATE TABLE IF NOT EXISTS `third_login` (`accessSecret`	TEXT,`accessToken`	TEXT,`expirationDate`	TEXT,`iconURL`	TEXT,`platformName`	TEXT,`profileURL`	TEXT,`userName`	TEXT,`usid`	TEXT,`type`	TEXT,`user_id`	TEXT,PRIMARY KEY(user_id));";

@end
