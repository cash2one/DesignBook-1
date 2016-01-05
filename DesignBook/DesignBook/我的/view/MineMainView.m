//
//  MineMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "MineMainView.h"
#import "UIView+Frame.h"

@interface MineMainView()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation MineMainView

- (void)awakeFromNib{
    self.headerImageView.layer.masksToBounds=YES;
    self.headerImageView.layer.cornerRadius=self.headerImageView.width*0.5;
}

@end
