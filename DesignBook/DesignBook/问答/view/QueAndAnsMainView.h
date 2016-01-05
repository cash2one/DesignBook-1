//
//  QueAndAnsMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-2.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSliderView.h"
#import "MJRefresh.h"

@class QueAndAnsMainView;

@protocol QueAndAnsMainViewDelegate <NSObject>

- (void)itemSelectedWithMainView:(QueAndAnsMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

- (void)refreshWithMainView:(QueAndAnsMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView;

- (void)sliderView:(CustomSliderView *)sliderView andIndex:(NSInteger)index andBtnArray:(NSArray *)btnArray;

@end

@interface QueAndAnsMainView : UITableView

@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,weak)id<QueAndAnsMainViewDelegate> mainViewDelegate;

@end
