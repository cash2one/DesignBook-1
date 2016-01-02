//
//  CaseMainCell.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CaseMainCell.h"
#import "UIView+Frame.h"
#import "UIImageView+WebCache.h"

@interface CaseMainCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 140样板间 / 混搭 / 17图
@property (weak, nonatomic) IBOutlet UILabel *areaStyleCountLabel;

@end

@implementation CaseMainCell

- (void)awakeFromNib {
    self.headerImageView.layer.masksToBounds=YES;
    self.headerImageView.layer.cornerRadius=self.headerImageView.width*0.5;
    
    CALayer * layer = [self.headerImageView layer];
    layer.borderColor = [[UIColor whiteColor] CGColor];
    layer.borderWidth = 2.0f;
}

- (void)setCases:(Case *)cases{
    _cases=cases;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:cases.imgUrl] placeholderImage:[UIImage imageNamed:@"default_logo"]];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:cases.facePic] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.nameLabel.text=cases.name;
    NSMutableString * str=[[NSMutableString alloc]init];
    
    if(cases.areaName.length){
        [str appendFormat:@"%@ ",cases.areaName];
    }
    
    if(cases.styleName.length){
        if(str.length){
            [str appendFormat:@"/ %@ ",cases.styleName];
        }else{
            [str appendFormat:@"%@ ",cases.styleName];
        }
    }
    
    if(str.length){
        [str appendFormat:@"/ %ld图",cases.counts];
    }else{
        [str appendFormat:@"%ld",cases.counts];
    }
    self.areaStyleCountLabel.text=str;
}


@end
