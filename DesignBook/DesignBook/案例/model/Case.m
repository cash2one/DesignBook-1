//
//  Case.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "Case.h"
#import "NSObject+KVC.h"

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

@end
