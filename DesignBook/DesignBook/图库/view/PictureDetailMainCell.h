//
//  PictureDetailMainCell.h
//  DesignBook
//
//  Created by 陈行 on 16-1-8.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueAndAns.h"
#import "PictureCol.h"

@interface PictureDetailMainCell : UITableViewCell

@property(nonatomic,strong)id data;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end
