//
//  VersionConst.h
//  比颜值
//
//  Created by 陈行 on 15-12-1.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionConst : NSObject

/**
 *
 */
extern NSString *const APPVERSION_PLIST;
/**
 *  版本信息
 */
extern NSString *const VERSION_0;
extern NSString *const VERSION_1_0;
/**
 *  0->1更新以下sql命令
 */
/**
 *  创建数据库版本信息
 */
extern NSString *const VERSION_SQL_1_0_1;
/**
 *  插入数据库版本信息
 */
extern NSString *const VERSION_SQL_1_0_2;
/**
 *  创建case表
 */
extern NSString *const VERSION_SQL_1_0_3;
/**
 *  创建parsing表
 */
extern NSString *const VERSION_SQL_1_0_4;
/**
 *  创建banner表
 */
extern NSString *const VERSION_SQL_1_0_5;
/**
 *  创建banner表
 */
extern NSString *const VERSION_SQL_1_0_6;

@end
