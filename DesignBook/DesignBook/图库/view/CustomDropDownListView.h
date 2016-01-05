//
//  CustomDropDownListView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-4.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Filter.h"

@class CustomDropDownListView;

@protocol CustomDropDownListViewDelegate <NSObject>

-(void)itemSelectedWithMainView:(CustomDropDownListView *)mainView andIndexPath:(NSIndexPath *)indexPath andBtn:(UIButton *)btn;

@end

@interface CustomDropDownListView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,weak)id<CustomDropDownListViewDelegate>mainViewDelegate;

+ (instancetype)dropDownListViewWithDataArray:(NSArray *)dataArray andFrame:(CGRect)frame;



- (void)setBtnStyle:(UIButton *)btn andTitle:(NSString *)title andFrame:(CGRect)frame;



@end
