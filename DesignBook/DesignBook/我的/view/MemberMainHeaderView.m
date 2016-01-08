//
//  MemberMainHeaderView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-7.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "MemberMainHeaderView.h"
#import "UIImageView+WebCache.h"

@interface MemberMainHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *goodLevelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rzImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *chenCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRangeLabel;

@property (weak, nonatomic) IBOutlet UILabel *yuyueNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *qiandanNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *pingjiaNumLabel;

@end

@implementation MemberMainHeaderView

- (void)awakeFromNib{
    self.headerImageView.layer.masksToBounds=YES;
    self.headerImageView.layer.cornerRadius=self.headerImageView.frame.size.width*0.5;
    
    self.goodLevelImageView.layer.masksToBounds=YES;
    self.goodLevelImageView.layer.cornerRadius=self.goodLevelImageView.frame.size.height*0.5;
    self.goodLevelImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
    self.goodLevelImageView.layer.borderWidth=2.f;
    
    self.rzImageView.layer.masksToBounds=YES;
    self.rzImageView.layer.cornerRadius=self.rzImageView.frame.size.height*0.5;
    self.rzImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
    self.rzImageView.layer.borderWidth=2.f;
    
    [self.phoneBtn addTarget:self action:@selector(phoneBtnTouch) forControlEvents:UIControlEventTouchUpInside];
}

- (void)phoneBtnTouch{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-680-8509,7788"]];
}

- (void)setMemberInfo:(MemberInfo *)memberInfo{
    _memberInfo=memberInfo;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:memberInfo.facePic] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.nickLabel.text=memberInfo.nick;
    if(memberInfo.shen.length && memberInfo.city.length){
        self.chenCityLabel.text=[NSString stringWithFormat:@"%@ · %@",memberInfo.shen,memberInfo.city];
    }else{
        self.chenCityLabel.text=@"城市未知";
    }
    if(memberInfo.feeRand.length){
        self.priceRangeLabel.text=[NSString stringWithFormat:@"设计收费：%@",memberInfo.feeRand];
    }else if (memberInfo.priceRange.length){
        self.priceRangeLabel.text=[NSString stringWithFormat:@"设计收费：%@",memberInfo.priceRange];
    }else{
        self.priceRangeLabel.text=@"设计收费：价格面议";
    }
    self.yuyueNumLabel.text=[NSString stringWithFormat:@"%ld\n预约",memberInfo.yuyueNum];
    self.qiandanNumLabel.text=[NSString stringWithFormat:@"%ld\n签单",memberInfo.qiandanNum];
    self.pingjiaNumLabel.text=[NSString stringWithFormat:@"%ld\n评价",memberInfo.appraiseNum];
    
    self.goodLevelImageView.hidden=NO;
    self.rzImageView.hidden=NO;
    if (memberInfo.goodlevel==6 || memberInfo.goodlevel==0){
        if(memberInfo.rz==1){
            self.goodLevelImageView.image=[UIImage imageNamed:@"ico_v_proprietor"];
        }else{
            self.goodLevelImageView.hidden=YES;
        }
        self.rzImageView.hidden=YES;
    }else{
        if(memberInfo.goodlevel==4){
            self.goodLevelImageView.image=[UIImage imageNamed:@"ico_e"];
        }else if (memberInfo.goodlevel==2){
            self.goodLevelImageView.image=[UIImage imageNamed:@"ico_n"];
        }else if(memberInfo.goodlevel==5){
            self.goodLevelImageView.image=[UIImage imageNamed:@"ico_f"];
        }else{
            self.goodLevelImageView.hidden=YES;
        }
        if(!memberInfo.rz){
            self.rzImageView.hidden=YES;
        }
    }
}

@end
