//
//  CaseAllMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CaseAllMainView.h"
#import "CaseMainCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+RefreshLocation.h"

@interface CaseAllMainView()<UITableViewDataSource,UITableViewDelegate>



@end

@implementation CaseAllMainView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource=self;
        self.delegate=self;
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        self.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page=0;
            [self.mainViewDelegate refreshWithMainView:self andRefreshComponent:self.mj_header];
        }];
        self.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.mainViewDelegate refreshWithMainView:self andRefreshComponent:self.mj_footer];
        }];
    }
    return self;
}


#pragma mark - tableView的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.casesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"CaseMainCell";
    CaseMainCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.cases=self.casesArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mainViewDelegate itemSelectedWithMainView:self andIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

#pragma mark - 传递数据
- (void)setCasesArray:(NSMutableArray *)casesArray{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    _casesArray=casesArray;
    [self reloadData];
}


@end
