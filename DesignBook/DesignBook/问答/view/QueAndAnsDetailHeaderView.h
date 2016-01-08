//
//  QueAndAnsDetailHeaderView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-6.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueAndAns.h"

@interface QueAndAnsDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIImageView *picsImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickCreateTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;


@property(nonatomic,strong)QueAndAns * queAndAns;

@end
