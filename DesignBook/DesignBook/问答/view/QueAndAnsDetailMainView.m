//
//  QueAndAnsDetailMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "QueAndAnsDetailMainView.h"
#import "QueAndAnsDetailHeaderView.h"
#import "QueAndAnsDetailMainCell.h"



@interface QueAndAnsDetailMainView()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)QueAndAnsDetailHeaderView * headerView;

@end

@implementation QueAndAnsDetailMainView

- (instancetype)initWithFrame:(CGRect)frame andQueAndAns:(QueAndAns *)queAndAns{
    _queAndAns=queAndAns;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.dataSource=self;
        self.delegate=self;
        [self createTableHeaderView];
    }
    return self;
}

- (void)createTableHeaderView{
//    QueAndAnsDetailHeaderView * headerView=[[[NSBundle mainBundle]loadNibNamed:@"QueAndAnsDetailHeaderView" owner:nil options:nil]lastObject];
//    headerView.queAndAns=self.queAndAns;
//    self.headerView=headerView;
//    self.tableHeaderView=headerView;
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
    //头像点击事件
    cell.headerImageView.tag=indexPath.row+100;
    cell.headerImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer * tgr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerImageViewWithTgr:)];
    [cell.headerImageView addGestureRecognizer:tgr];
    
    //点赞事件
    cell.praiseNumBtn.tag=indexPath.row+200;
    [cell.praiseNumBtn addTarget:self action:@selector(praiseNumBtnTouchWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)praiseNumBtnTouchWithBtn:(UIButton *)btn{
    [self.mainViewDelegate praiseNumBtnTouchWithIndex:btn.tag-200];
}

- (void)headerImageViewWithTgr:(UITapGestureRecognizer *)tgr{
    [self.mainViewDelegate headerImageViewBtnTouchWithIndex:tgr.view.tag-100];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    view.backgroundColor=[UIColor colorWithRed:0.92f green:0.91f blue:0.92f alpha:1.00f];
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor whiteColor];
    btn.frame=CGRectMake(0, 8, WIDTH, 44-8);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:[NSString stringWithFormat:@"%ld条回答",self.queAndAns.comments] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"ico_qa_answer"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets=UIEdgeInsetsMake(0, 8, 0, -8);
    btn.titleEdgeInsets=UIEdgeInsetsMake(0, 8, 0, -8);
    btn.userInteractionEnabled=NO;
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    [view addSubview:btn];
    UIView * hl=[[UIView alloc]initWithFrame:CGRectMake(0, 44-1, WIDTH, 1)];
    hl.backgroundColor=[UIColor colorWithRed:0.92f green:0.91f blue:0.92f alpha:1.00f];
    [view addSubview:hl];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)setQueAndAns:(QueAndAns *)queAndAns{
    _queAndAns=queAndAns;
    QueAndAnsDetailHeaderView * headerView=[[[NSBundle mainBundle]loadNibNamed:@"QueAndAnsDetailHeaderView" owner:nil options:nil]lastObject];
    headerView.queAndAns=self.queAndAns;
    self.tableHeaderView=headerView;
    [self reloadData];
}

@end
