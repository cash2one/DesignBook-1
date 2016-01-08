//
//  DisSearchDesMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-6.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@class DisSearchDesMainView;

@protocol DisSearchDesMainViewDelegate <NSObject>

- (void)itemSelectedWithMainView:(DisSearchDesMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

- (void)refreshWithMainView:(DisSearchDesMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView;

@end

@interface DisSearchDesMainView : UITableView

@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,weak)id<DisSearchDesMainViewDelegate>mainViewDelegate;

@end
