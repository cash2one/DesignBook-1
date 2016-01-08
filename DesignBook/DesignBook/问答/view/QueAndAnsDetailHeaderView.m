//
//  QueAndAnsDetailHeaderView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-6.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "QueAndAnsDetailHeaderView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"

@interface QueAndAnsDetailHeaderView()



@end

@implementation QueAndAnsDetailHeaderView

-(void)awakeFromNib{
    self.titleLabel.width=WIDTH-16;
    self.descLabel.width=WIDTH-16;
    self.picsImageView.width=WIDTH-16;
    self.readBtn.x=WIDTH-8-self.readBtn.width;
}

- (void)setQueAndAns:(QueAndAns *)queAndAns{
    _queAndAns=queAndAns;
    NSString * title=[NSString stringWithFormat:@"      %@",queAndAns.title];
    
    CGSize size=CGSizeMake(WIDTH-16, HEIGHT);
    size=[title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    self.titleLabel.text=title;
    self.titleLabel.height=size.height;
    
    size=CGSizeMake(WIDTH-16, HEIGHT);
    self.descLabel.y=CGRectGetMaxY(self.titleLabel.frame)+8;
    if(queAndAns.desc.length){
        size=[queAndAns.desc boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.descLabel.font} context:nil].size;
        self.descLabel.height=size.height;
    }else{
        self.descLabel.height=0;
    }
    self.descLabel.text=queAndAns.desc;
    
    self.picsImageView.y=CGRectGetMaxY(self.descLabel.frame)+8;
    if(queAndAns.pics.count){
        self.picsImageView.height=200;
        [self.picsImageView sd_setImageWithURL:[NSURL URLWithString:queAndAns.pics[0]] placeholderImage:[UIImage imageNamed:@"default_logo"]];
    }else{
        self.picsImageView.height=0;
    }
    
    self.nickCreateTimeLabel.y=CGRectGetMaxY(self.picsImageView.frame)+8;
    self.readBtn.y=self.nickCreateTimeLabel.y;
    self.nickCreateTimeLabel.text=[NSString stringWithFormat:@"%@  %@",queAndAns.nick,queAndAns.createTime];
    [self.readBtn setTitle:[NSString stringWithFormat:@" %ld",queAndAns.hits] forState:UIControlStateNormal];
    self.frame=CGRectMake(0, 0, WIDTH, CGRectGetMaxY(self.nickCreateTimeLabel.frame)+8);
}

@end
