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
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentHeightCons;

@end

@implementation CaseScrollMainCell

- (void)setImageInfo:(ImageInfo *)imageInfo{
    _imageInfo=imageInfo;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageInfo.imgUrl] placeholderImage:[UIImage imageNamed:@"default_logo"]];
    CGSize size=CGSizeMake(WIDTH-16, MAXFLOAT);
    size=[imageInfo.comment boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.commentLabel.font} context:nil].size;
    self.commentHeightCons.constant=size.height;
    self.commentLabel.text=imageInfo.comment;
}

@end
