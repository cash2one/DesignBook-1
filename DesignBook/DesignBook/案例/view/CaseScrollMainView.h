//
//  CaseScrollMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Banner.h"
@class CaseScrollMainView;

@protocol CaseScrollMainViewDelegate <NSObject>

- (void)itemSelectedWithMainView:(CaseScrollMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

- (void)headerImageViewTouch;

@end

@interface CaseScrollMainView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)Banner  * banner;

@property(nonatomic,strong)UIImage * shareImage;

@property(nonatomic,weak)id<CaseScrollMainViewDelegate>mainViewDelegate;

@end
