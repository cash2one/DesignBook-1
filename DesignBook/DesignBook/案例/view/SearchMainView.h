//
//  SearchMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-9.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@class SearchMainView;

@protocol SearchMainViewDelegate <NSObject>

- (void)searchMainView:(SearchMainView *)mainView andSliderBtnIndex:(NSInteger)index;

- (void)refreshWithMainView:(SearchMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView andScrollView:(UIScrollView *)scrollView;

- (void)itemSelectedWithMainView:(SearchMainView *)mainView andIndexPath:(NSIndexPath *)indexPath andCurrentBtnIndex:(NSInteger)index;

@end

@interface SearchMainView : UIView

@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,assign)NSInteger currentSliderIndex;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,weak)id<SearchMainViewDelegate>delegate;

@end
