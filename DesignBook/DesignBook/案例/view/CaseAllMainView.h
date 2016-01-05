//
//  CaseAllMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@class CaseAllMainView;

@protocol CaseAllMainViewDelegate <NSObject>

- (void)itemSelectedWithMainView:(CaseAllMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

- (void)refreshWithMainView:(CaseAllMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView;

@end

@interface CaseAllMainView : UITableView

@property(nonatomic,strong)NSMutableArray * casesArray;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,weak)id<CaseAllMainViewDelegate> mainViewDelegate;

@end
