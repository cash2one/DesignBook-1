//
//  PictureDetailMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-8.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"

@class PictureDetailMainView;

@protocol PictureDetailMainViewDelegate <NSObject>

- (void)memHeaderImageViewBtnTouch:(UIView *)imageView;

-(void)itemSelectedWithMainView:(PictureDetailMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

@end

@interface PictureDetailMainView : UITableView

@property(nonatomic,strong)UIImage * shareImage;

@property(nonatomic,strong)ImageInfo * imageInfo;

@property(nonatomic,assign)NSInteger sliderCurrentIndex;

@property(nonatomic,weak)id<PictureDetailMainViewDelegate>mainViewDelegate;

@end
