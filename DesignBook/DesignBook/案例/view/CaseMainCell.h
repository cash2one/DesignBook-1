//
//  CaseMainCell.h
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Case.h"

@interface CaseMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property(nonatomic,strong)Case * cases;

@end
