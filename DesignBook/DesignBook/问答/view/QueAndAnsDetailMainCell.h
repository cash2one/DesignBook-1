//
//  QueAndAnsDetailMainCell.h
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface QueAndAnsDetailMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UIButton *praiseNumBtn;

@property(nonatomic,strong)Comment * comment;

@end
