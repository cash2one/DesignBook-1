//
//  PicCollectionMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-8.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@class PicCollectionMainView;

@protocol PicStorageMainViewDelegate <NSObject>

-(void)itemSelectedWithMainView:(PicCollectionMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

- (void)refreshWithMainView:(PicCollectionMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView;

@end

@interface PicCollectionMainView : UICollectionView

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,weak)id<PicStorageMainViewDelegate>mainViewDelegate;

@end
