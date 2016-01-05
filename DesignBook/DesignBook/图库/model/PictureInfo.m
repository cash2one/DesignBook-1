//
//  PictureInfo.m
//  DesignBook
//
//  Created by 陈行 on 16-1-4.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "PictureInfo.h"
#import "MJExtension.h"
#import "SQLiteManager.h"

@implementation PictureInfo

+ (instancetype)pictureInfoWithDict:(NSDictionary *)dict{
    return [self objectWithKeyValues:dict];
}

- (BOOL)saveSelf{
    return [[SQLiteManager shareSQLiteManager]insertWithSQL:@"insert into PictureInfo(id,name,imgUrl) value(?,?,?)" andArgumentsInArray:@[@(self.Id),self.name,self.imgUrl]];
}

@end
