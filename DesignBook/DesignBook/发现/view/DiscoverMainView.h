//
//  DiscoverMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-2.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscoverMainViewDelegate <NSObject>

- (void)btnTouchAndIndex:(NSInteger)index;

@end

@interface DiscoverMainView : UITableView

@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,weak)id<DiscoverMainViewDelegate>mainViewDelegate;

@end
