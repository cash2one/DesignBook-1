//
//  QueAndAnsDetailMainCell.m
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "QueAndAnsDetailMainCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"

@interface QueAndAnsDetailMainCell()
@property (weak, nonatomic) IBOutlet UIImageView *designerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickWidthConst;

@end

@implementation QueAndAnsDetailMainCell

- (void)awakeFromNib {
    self.headerImageView.layer.masksToBounds=YES;
    self.headerImageView.layer.cornerRadius=self.headerImageView.width*0.5;
    self.praiseNumBtn.layer.borderWidth=1.f;
    self.praiseNumBtn.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.praiseNumBtn.layer.masksToBounds=YES;
    self.praiseNumBtn.layer.cornerRadius=self.praiseNumBtn.height*0.5;
    
    self.replyBtn.layer.borderWidth=1.f;
    self.replyBtn.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.replyBtn.layer.masksToBounds=YES;
    self.replyBtn.layer.cornerRadius=self.replyBtn.height*0.5;
}

- (void)setComment:(Comment *)comment{
    _comment=comment;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:comment.facePic] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    CGSize size=CGSizeMake(WIDTH, 21);
    size=[comment.nick boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.nickLabel.font} context:nil].size;
    self.nickWidthConst.constant=size.width;
    self.nickLabel.text=comment.nick;
    if(comment.identity){
        self.designerImageView.hidden=NO;
    }else{
        self.designerImageView.hidden=YES;
    }
    
    self.createTimeLabel.text=comment.createTime;
    self.contentLabel.text=comment.content;
    [self.praiseNumBtn setTitle:[NSString stringWithFormat:@"%ld",comment.praiseNum] forState:UIControlStateNormal];
}

@end
