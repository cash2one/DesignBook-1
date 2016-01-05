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

@interface QueAndAnsDetailMainView : UITableView

@property(nonatomic,strong)QueAndAns * queAndAns;

@property(nonatomic,strong)NSArray * commentArray;

@end
