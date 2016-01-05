//
//  Case.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "Case.h"
#import "NSObject+KVC.h"
#import "SQLiteManager.h"
#import "NSString+NilToNULL.h"

@implementation Case

+ (instancetype)caseWithDict:(NSDictionary *)dict{
    Case * cases =[self objectWithDict:dict];

    if(cases.imgList){
        NSMutableArray * imgTmpArr=[[NSMutableArray alloc]init];
        for (NSDictionary * imgDict in cases.imgList) {
            [imgTmpArr addObject:[ImageInfo imageInfoWithDict:imgDict]];
        }
        if(imgTmpArr.count){
            cases.imgList=imgTmpArr;
        }else{
            cases.imgList=nil;
        }
    }
    return cases;
}

- (BOOL)saveSelf{
    return [[SQLiteManager shareSQLiteManager]insertWithSQL:@"INSERT INTO `Cases`(`id`,`uid`,`counts`,`hits`,`name`,`nick`,`facePic`,`imgUrl`,`styleName`,`priceName`,`areaName`,`spaceName`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);" andArgumentsInArray:@[@(self.id),@(self.uid),@(self.counts),@(self.hits),[NSString nilToNull:self.name],[NSString nilToNull:self.nick],[NSString nilToNull:self.facePic],[NSString nilToNull:self.imgUrl],[NSString nilToNull:self.styleName],[NSString nilToNull:self.priceName],[NSString nilToNull:self.areaName],[NSString nilToNull:self.spaceName]]];
}

@end
