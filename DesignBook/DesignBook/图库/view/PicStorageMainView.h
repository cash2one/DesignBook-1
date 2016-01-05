//
//  PicStorageMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-4.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "PictureInfo.h"
@class PicStorageMainView;

@protocol PicStorageMainViewDelegate <NSObject>

-(void)itemSelectedWithMainView:(PicStorageMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

- (void)refreshWithMainView:(PicStorageMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView;

@end

@interface PicStorageMainView : UICollectionView

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,weak)id<PicStorageMainViewDelegate> mainViewDelegate;

@end
