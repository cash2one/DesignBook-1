//
//  DisSearchDesMainCell.m
//  DesignBook
//
//  Created by 陈行 on 16-1-6.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "DisSearchDesMainCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"

@interface DisSearchDesMainCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UILabel *shenCityLabel;

@property (weak, nonatomic) IBOutlet UILabel *yuyueNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRangeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceRangeWidthCons;
@property (weak, nonatomic) IBOutlet UIImageView *goodLevelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rzImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodLevelWidthCons;

@end

@implementation DisSearchDesMainCell

- (void)awakeFromNib {
    self.iconImageView.layer.masksToBounds=YES;
    self.iconImageView.layer.cornerRadius=self.iconImageView.width*0.5;
}

- (void)setMemberInfo:(MemberInfo *)memberInfo{
    _memberInfo=memberInfo;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:memberInfo.facePic] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.nickLabel.text=memberInfo.nick;
    self.shenCityLabel.text=[NSString stringWithFormat:@"%@  %@",memberInfo.shen,memberInfo.city];
    self.yuyueNumLabel.text=[NSString stringWithFormat:@"%ld预约  %ld签单  %ld评价",memberInfo.yuyueNum,memberInfo.qiandanNum,memberInfo.appraiseNum];
    
    CGSize size=CGSizeMake(WIDTH, 20);
    size=[memberInfo.priceRange boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.priceRangeLabel.font} context:nil].size;
    self.priceRangeWidthCons.constant=size.width;
    self.priceRangeLabel.text=memberInfo.priceRange;
    
    self.goodLevelWidthCons.constant=30;
    self.rzImageView.hidden=NO;
    
    if(memberInfo.goodlevel==5){
        self.goodLevelImageView.image=[UIImage imageNamed:@"ico_f"];
    }else if(memberInfo.goodlevel==4){
        self.goodLevelImageView.image=[UIImage imageNamed:@"ico_e"];
    }else if (memberInfo.goodlevel==6 || memberInfo.goodlevel==0){
        self.goodLevelWidthCons.constant=0;
    }else if (memberInfo.goodlevel==2){
        self.goodLevelImageView.image=[UIImage imageNamed:@"ico_n"];
    }
    
    
    if(memberInfo.rz==0){
        self.rzImageView.hidden=YES;
    }
    
    
}

@end
