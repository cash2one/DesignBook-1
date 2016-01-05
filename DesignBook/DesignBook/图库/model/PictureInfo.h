//
//  PictureInfo.h
//  DesignBook
//
//  Created by 陈行 on 16-1-4.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberInfo.h"

@interface PictureInfo : NSObject

@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,assign)NSInteger colNum;
@property(nonatomic,assign)NSInteger askNum;

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * imgUrl;
@property(nonatomic,copy)NSString * comment;
@property(nonatomic,copy)NSString * shareUrl;
@property(nonatomic,strong)MemberInfo * memberInfo;
@property(nonatomic,strong)NSArray * colList;
@property(nonatomic,strong)NSArray * askList;

+ (instancetype)pictureInfoWithDict:(NSDictionary *)dict;

//- (BOOL)saveSelf;

@end
