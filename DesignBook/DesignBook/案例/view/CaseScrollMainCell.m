//
//  CaseScrollMainCell.m
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CaseScrollMainCell.h"
#import "UIImageView+WebCache.h"

@interface CaseScrollMainCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation CaseScrollMainCell

- (void)setImageInfo:(ImageInfo *)imageInfo{
    _imageInfo=imageInfo;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageInfo.imgUrl] placeholderImage:[UIImage imageNamed:@"default_logo"]];
}

@end
