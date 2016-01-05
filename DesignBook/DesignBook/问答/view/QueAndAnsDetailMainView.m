//
//  QueAndAnsDetailMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "QueAndAnsDetailMainView.h"
#import "QueAndAnsDetailMainCell.h"

@interface QueAndAnsDetailMainView()<UITableViewDataSource,UITableViewDelegate>



@end

@implementation QueAndAnsDetailMainView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.dataSource=self;
        self.delegate=self;
    }
    return self;
}

#pragma mark - tableView的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"QueAndAnsDetailMainCell";
    QueAndAnsDetailMainCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.comment=self.commentArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return self.queAndAns.pics.count?200+44:44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)setQueAndAns:(QueAndAns *)queAndAns{
    _queAndAns=queAndAns;
    [self reloadData];
}

@end
