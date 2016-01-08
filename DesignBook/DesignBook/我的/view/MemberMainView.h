//
//  MemberMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-7.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSliderView.h"
#import "MJRefresh.h"
#import "MemberInfo.h"

@class MemberMainView;

@protocol MemberMainViewDelegate <NSObject>

- (void)itemSelectedWithMainView:(MemberMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

- (void)sliderView:(CustomSliderView *)sliderView andIndex:(NSInteger)index andBtnArray:(NSArray *)btnArray;

- (void)refreshWithMainView:(MemberMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView;

- (void)onlineBtnTouch:(UIButton *)btn;

@end

@interface MemberMainView : UITableView

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)NSArray *  dataArray;

@property(nonatomic,strong)MemberInfo * memberInfo;

@property(nonatomic,weak)id<MemberMainViewDelegate>mainViewDelegate;

@end
