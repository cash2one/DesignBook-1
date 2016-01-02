//
//  CaseMainView.h
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "Parsing.h"
#import "Case.h"
#import "Banner.h"

@class CaseMainView;

@protocol CaseMainViewDelegate <NSObject>

- (void)itemSelectedWithMainView:(CaseMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

- (void)seeAllCasesWithMainView:(CaseMainView *)mainView;

- (void)refreshWithMainView:(CaseMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView;

- (void)caseMainView:(CaseMainView *)mainView andScrollViewIsUp:(BOOL)isUp;

- (void)guidePageViewTouchWithIndex:(NSInteger)index;

- (void)scrollViewTouchWithIndex:(NSInteger)index;

@end

@interface CaseMainView : UITableView

@property(nonatomic,strong)NSMutableArray * jiexiArray;
@property(nonatomic,strong)NSMutableArray * casesArray;
@property(nonatomic,strong)NSMutableArray * bannerArray;

@property(nonatomic,weak)id<CaseMainViewDelegate> mainViewDelegate;

@end
