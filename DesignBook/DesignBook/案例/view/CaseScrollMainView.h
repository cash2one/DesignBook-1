//
//  CaseScrollMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Banner.h"


@interface CaseScrollMainView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)Banner  * banner;

@property(nonatomic,strong)UIImage * shareImage;

@end
