//
//  DisSearchDesMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-6.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "DisSearchDesMainView.h"
#import "DisSearchDesMainCell.h"

@interface DisSearchDesMainView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DisSearchDesMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.dataSource=self;
        self.delegate=self;
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"DisSearchDesMainCell";
    DisSearchDesMainCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.memberInfo=self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mainViewDelegate itemSelectedWithMainView:self andIndexPath:indexPath];
}

#pragma mark - 设置数据源
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    self.page++;
    [self reloadData];
}

@end
