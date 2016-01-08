//
//  CaseDetailMainView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Case.h"
@class CaseDetailMainView;

@protocol CaseDetailMainViewDelegate <NSObject>

- (void)itemSelectedWithMainView:(CaseDetailMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

- (void)headerImageViewTouch;

@end

@interface CaseDetailMainView : UITableView

@property(nonatomic,strong)Case * cases;

@property(nonatomic,strong)UIImage * shareImage;

@property(nonatomic,weak)id<CaseDetailMainViewDelegate>mainViewDelegate;

@end
