//
//  ImageInfo.m
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "ImageInfo.h"
#import "NSObject+KVC.h"

@implementation ImageInfo

+ (instancetype)imageInfoWithDict:(NSDictionary *)dict{
    ImageInfo * imageInfo = [self objectWithDict:dict];
    if(imageInfo.memberInfo){
        id dict=imageInfo.memberInfo;
        imageInfo.memberInfo=[MemberInfo memberInfoWithDict:dict];
    }
    if([[imageInfo.colList class]isSubclassOfClass:[NSArray class]]){
        NSMutableArray * array=[NSMutableArray new];
        for (NSDictionary * dict in imageInfo.colList) {
            [array addObject:[PictureCol pictureColWithDict:dict]];
        }
        imageInfo.colList=array.count?array:nil;
    }
    
    if([[imageInfo.askList class]isSubclassOfClass:[NSArray class]]){
        NSMutableArray * array=[NSMutableArray new];
        for (NSDictionary * dict in imageInfo.askList) {
            [array addObject:[QueAndAns queAndAnsWithDict:dict]];
        }
        imageInfo.askList=array.count?array:nil;
    }
    
    return imageInfo;
}

@end
