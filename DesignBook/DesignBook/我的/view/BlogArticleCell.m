//
//  BlogArticleCell.m
//  DesignBook
//
//  Created by 陈行 on 16-1-7.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "BlogArticleCell.h"

@interface BlogArticleCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;

@end

@implementation BlogArticleCell

- (void)setBlogArticle:(BlogArticle *)blogArticle{
    _blogArticle=blogArticle;
    self.titleLabel.text=blogArticle.title;
    self.descLabel.text=blogArticle.desc;
    self.createTimeLabel.text=blogArticle.createTime;
    [self.readBtn setTitle:[NSString stringWithFormat:@"%ld",blogArticle.hits] forState:UIControlStateNormal];
}

@end
