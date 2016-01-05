//
//  Banner.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "Banner.h"
#import "NSObject+KVC.h"
#import "SQLiteManager.h"
#import "NSString+NilToNULL.h"

@implementation Banner

+ (instancetype)bannerWithDict:(NSDictionary *)dict{
    Banner * banner = [self objectWithDict:dict];
    if(banner.memberInfo!=nil){
        NSDictionary * memInfoDict = (NSDictionary *)banner.memberInfo;
        banner.memberInfo=[MemberInfo memberInfoWithDict:memInfoDict];
    }else{
        banner.memberInfo=nil;
    }
    
    if(banner.imgList){
        NSMutableArray * tmpArr=[[NSMutableArray alloc]init];
        for (NSDictionary * imageDict in banner.imgList) {
            [tmpArr addObject:[ImageInfo imageInfoWithDict:imageDict]];
        }
        banner.imgList=tmpArr.count?tmpArr:nil;
    }else{
        banner.imgList=nil;
    }
    return banner;
}

- (BOOL)saveSelf{
    return [[SQLiteManager shareSQLiteManager]insertWithSQL:@"INSERT INTO `Banner`(`Id`,`hits`,`needLogin`,`title`,`imgUrl`,`url`,`module`,`name`,`comment`,`shareUrl`) VALUES (?,?,?,?,?,?,?,?,?,?);" andArgumentsInArray:@[@(self.Id),@(self.hits),@(self.needLogin),[NSString nilToNull:self.title],[NSString nilToNull:self.imgUrl],[NSString nilToNull:self.url],[NSString nilToNull:self.module],[NSString nilToNull:self.name],[NSString nilToNull:self.comment],[NSString nilToNull:self.shareUrl]]];
}



@end
