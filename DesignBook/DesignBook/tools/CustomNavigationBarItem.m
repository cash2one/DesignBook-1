//
//  CustomNavigationBarItem.m
//  封装-webView的一些内容
//
//  Created by 陈行 on 15-12-12.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CustomNavigationBarItem.h"

@implementation CustomNavigationBarItem

+ (instancetype)navigationBarItemWithNorImageName:(NSString *)normalImageName andSelectedImageName:(NSString *)selectedImageName andIsLeftBtn:(BOOL)isLeftBtn{
    return [[self alloc]initWithNorImageName:normalImageName andSelectedImageName:selectedImageName andIsLeftBtn:isLeftBtn];
}
- (instancetype)initWithNorImageName:(NSString *)normalImageName andSelectedImageName:(NSString *)selectedImageName andIsLeftBtn:(BOOL)isLeftBtn{
    if(self=[super init]){
        self.normalImageName=normalImageName;
        self.selectedImageName=selectedImageName;
        self.isLeftBtn=isLeftBtn;
    }
    return self;
}

@end
