//
//  QueAndAnsMainCell.m
//  DesignBook
//
//  Created by 陈行 on 16-1-2.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "QueAndAnsMainCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"

@interface QueAndAnsMainCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *createTimeBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation QueAndAnsMainCell

- (void)awakeFromNib{
    self.createTimeBtn.userInteractionEnabled=NO;
    self.readBtn.userInteractionEnabled=NO;
    self.commentBtn.userInteractionEnabled=NO;
}

- (void)setQueAndAns:(QueAndAns *)queAndAns{
    _queAndAns=queAndAns;
    if(queAndAns.imgUrl.length){
        self.iconImageView.frame=CGRectMake(WIDTH-70-8, 10, 70, 70);
        self.titleLabel.width=WIDTH-16-78;
        self.readBtn.x=CGRectGetMinX(self.iconImageView.frame)-self.readBtn.width-8;
        self.commentBtn.x=CGRectGetMinX(self.readBtn.frame)-8-self.commentBtn.width;
    }else{
        self.iconImageView.frame=CGRectZero;
        self.titleLabel.width=WIDTH-16;
        self.readBtn.x=WIDTH-self.readBtn.width-8;
        self.commentBtn.x=CGRectGetMinX(self.readBtn.frame)-8-self.commentBtn.width;
    }
    self.titleLabel.text=queAndAns.title;
    [self.createTimeBtn setTitle:queAndAns.createTime forState:UIControlStateNormal];
    [self.readBtn setTitle:[NSString stringWithFormat:@"%ld",queAndAns.hits] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",queAndAns.comments] forState:UIControlStateNormal];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:queAndAns.imgUrl] placeholderImage:[UIImage imageNamed:@"default_logo"]];
}

@end
