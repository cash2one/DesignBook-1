//
//  CaseMainView.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CaseMainView.h"
#import "CaseMainCell.h"
#import "GuidePageView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+RefreshLocation.h"


@interface CaseMainView()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,weak)GuidePageView * guidePageView;
@property(nonatomic,weak)UIScrollView * scrollView;

@end

@implementation CaseMainView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource=self;
        self.delegate=self;
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - 手势点击事件
- (void)scrollViewTgr:(UITapGestureRecognizer *)tgr{
    if(tgr.view==self.guidePageView){
        NSInteger index = self.guidePageView.scrollView.contentOffset.x/WIDTH;
        [self.mainViewDelegate guidePageViewTouchWithIndex:index];
    }else if (tgr.view==self.scrollView){
        NSInteger index  = [tgr locationInView:tgr.view].x/150;
        [self.mainViewDelegate scrollViewTouchWithIndex:index];
    }
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

- (void)seeAllCases{
    [self.mainViewDelegate seeAllCasesWithMainView:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 375)];
    
    GuidePageView * guideView = [GuidePageView guidePageViewWithBackGroundImage:nil andFrame:CGRectMake(0, 0, WIDTH, 200) andIsWebImage:YES];
    [headerView addSubview:guideView];
    self.guidePageView=guideView;
    [guideView setAutoPlay:YES andCirculationPlay:true andTimeInterval:2];
    UITapGestureRecognizer * tgr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewTgr:)];
    [guideView addGestureRecognizer:tgr];
    
    UIScrollView * scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, WIDTH, 120)];
    [headerView addSubview:scrollView];
    UITapGestureRecognizer * tgr2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewTgr:)];
    [scrollView addGestureRecognizer:tgr2];
    self.scrollView=scrollView;
    
    for (UIView * view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    self.scrollView.contentSize=CGSizeMake(150*(_jiexiArray.count-1)+140, 0);
    for (int i=0; i<_jiexiArray.count; i++) {
        Parsing * pars=_jiexiArray[i];
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(150*i, 10, 140, 100)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:pars.imgUrl] placeholderImage:[UIImage imageNamed:@"default_logo"]];
        [self.scrollView addSubview:imageView];
    }
    
    NSMutableArray * array=[[NSMutableArray alloc]init];
    for (Banner * banner in _bannerArray) {
        [array addObject:banner.imgUrl];
    }
    self.guidePageView.imagesArray=array;
    
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 320, WIDTH, 55)];
    view.backgroundColor=[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 45)];
    label.backgroundColor=[UIColor whiteColor];
    label.text=@"    热门推荐";
    label.font=[UIFont systemFontOfSize:14];
    label.layoutMargins=UIEdgeInsetsMake(0, 16, 0, 0);
    [view addSubview:label];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(WIDTH-100, 10, 100, 44);
    [btn setTitle:@"全部案例" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor colorWithRed:0.66f green:0.66f blue:0.66f alpha:1.00f] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"ico_qa_drop_rightarrow"] forState:UIControlStateNormal];
    [btn refreshRightLeft];
    [btn refreshImageViewWithTop:0 andBottom:0 andLeft:5 andRight:-5];
    [btn addTarget:self action:@selector(seeAllCases) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    [headerView addSubview:view];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, WIDTH, 44);
    [btn setTitle:@"查看全部设计案例" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(seeAllCases) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 375;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static CGFloat oldY;
    if(oldY>scrollView.contentOffset.y){
        [self.mainViewDelegate caseMainView:self andScrollViewIsUp:NO];
    }else if(oldY < scrollView.contentOffset.y){
        [self.mainViewDelegate caseMainView:self andScrollViewIsUp:YES];
    }
    oldY=scrollView.contentOffset.y;
}

#pragma mark - 传递数据
- (void)setCasesArray:(NSMutableArray *)casesArray{
    _casesArray=casesArray;
    [self reloadData];
}

@end
