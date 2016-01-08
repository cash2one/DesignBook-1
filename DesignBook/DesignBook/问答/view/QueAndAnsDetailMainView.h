//
//  QueAndAnsDetailMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueAndAns.h"
#import "Comment.h"

@class QueAndAnsDetailMainView;

@protocol QueAndAnsDetailMainViewDelegate <NSObject>
- (void)praiseNumBtnTouchWithIndex:(NSInteger)index;

- (void)headerImageViewBtnTouchWithIndex:(NSInteger)index;

@end

@interface QueAndAnsDetailMainView : UITableView

@property(nonatomic,strong)QueAndAns * queAndAns;

@property(nonatomic,strong)NSArray * commentArray;

@property(nonatomic,weak)id<QueAndAnsDetailMainViewDelegate>mainViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame andQueAndAns:(QueAndAns *)queAndAns;

@end
