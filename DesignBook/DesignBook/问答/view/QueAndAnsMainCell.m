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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewCons;

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
        self.imageViewCons.constant=73;
    }else{
        self.imageViewCons.constant=0;
    }
    self.titleLabel.text=queAndAns.title;
    [self.createTimeBtn setTitle:queAndAns.createTime forState:UIControlStateNormal];
    [self.readBtn setTitle:[NSString stringWithFormat:@"%ld",queAndAns.hits] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",queAndAns.comments] forState:UIControlStateNormal];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:queAndAns.imgUrl] placeholderImage:[UIImage imageNamed:@"default_logo"]];
}

@end
