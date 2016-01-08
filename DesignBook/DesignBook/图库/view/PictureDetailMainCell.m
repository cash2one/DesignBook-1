//
//  PictureDetailMainCell.m
//  DesignBook
//
//  Created by 陈行 on 16-1-8.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "PictureDetailMainCell.h"
#import "UIImageView+WebCache.h"

@interface PictureDetailMainCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nextLabel;

@end

@implementation PictureDetailMainCell

- (void)awakeFromNib {
    self.headerImageView.userInteractionEnabled=YES;
    self.headerImageView.layer.masksToBounds=YES;
    self.headerImageView.layer.cornerRadius=self.headerImageView.frame.size.width*0.5;
}

- (void)setData:(id)data{
    if([[data class]isSubclassOfClass:[PictureCol class]]){
        PictureCol * col=data;
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:col.facePic] placeholderImage:[UIImage imageNamed:@"default_logo"]];
        self.headerImageView.tag=col.colId;
        [self setLabelStyleFont:13 andTextColor:[UIColor blackColor] andTitle:[NSString stringWithFormat:@"%@收藏图片到%@",col.nick,col.name] andLabel:self.titleLabel];
        [self setLabelStyleFont:12 andTextColor:[UIColor grayColor] andTitle:col.createTime andLabel:self.nextLabel];
    }else{
        QueAndAns * que=data;
        self.headerImageView.tag=que.Id;
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:que.facePic] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
        [self setLabelStyleFont:12 andTextColor:[UIColor grayColor] andTitle:[NSString stringWithFormat:@"%@提出了一个问题",que.nick] andLabel:self.titleLabel];
        [self setLabelStyleFont:13 andTextColor:[UIColor blackColor] andTitle:que.title andLabel:self.nextLabel];
    }
}
- (void)setLabelStyleFont:(NSInteger)font andTextColor:(UIColor *)color andTitle:(NSString *)title andLabel:(UILabel*)label{
    label.text=title;
    label.font=[UIFont systemFontOfSize:font];
    label.textColor=color;
}
@end
