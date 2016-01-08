//
//  QueAndAnsMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-2.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "QueAndAnsMainView.h"
#import "QueAndAnsMainCell.h"
#import "UIView+Frame.h"
#import "QueAndAns.h"

@interface QueAndAnsMainView()<UITableViewDataSource,UITableViewDelegate,CustomSliderViewDelegate,UIScrollViewDelegate>

@property(nonatomic,assign)NSInteger currentBtnIndex;

@property(nonatomic,weak)UIButton * wangBtn;

@end

@implementation QueAndAnsMainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource=self;
        self.delegate=self;
        [self createTableHeaderView];
        self.rowHeight=90;
        
        self.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page=0;
            [self.mainViewDelegate refreshWithMainView:self andRefreshComponent:self.mj_header];
        }];
        
        self.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.mainViewDelegate refreshWithMainView:self andRefreshComponent:self.mj_footer];
        }];
    }
    return self;
}

- (void)createTableHeaderView{
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    
    UIImageView * iv=[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"bg_qa"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    iv.frame=CGRectMake(0, 0, WIDTH, 200);
    [headerView addSubview:iv];
    
    UIImageView * bgFontIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_font"]];
    bgFontIV.contentMode=UIViewContentModeScaleAspectFit;
    bgFontIV.frame=CGRectMake(0, 64, WIDTH, 64);
    [headerView addSubview:bgFontIV];
    
    UIButton * wangBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wangBtn.backgroundColor=[UIColor colorWithRed:0.87f green:0.19f blue:0.19f alpha:1.00f];
    [wangBtn setTitle:@"我要提问" forState:UIControlStateNormal];
    [wangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wangBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    wangBtn.frame=CGRectMake((WIDTH-100)*0.5, 200-60, 100, 30);
    wangBtn.layer.masksToBounds=YES;
    wangBtn.layer.cornerRadius=3.f;
    self.wangBtn=wangBtn;
    [headerView addSubview:wangBtn];
    
    self.tableHeaderView=headerView;
}

#pragma mark - tableView的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"QueAndAnsMainCell";
    QueAndAnsMainCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.queAndAns=self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mainViewDelegate itemSelectedWithMainView:self andIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CustomSliderView * sliderView=[CustomSliderView sliderViewWithItems:@[@"最近活跃",@"最新提问",@"等待回答"] andFrame:CGRectMake(0, 200, WIDTH, 44)];
    [sliderView setSelectedBtn:self.currentBtnIndex];
    sliderView.horiLine.backgroundColor=[UIColor colorWithRed:0.87f green:0.19f blue:0.19f alpha:1.00f];
    sliderView.selectedTitleColor=[UIColor colorWithRed:0.87f green:0.19f blue:0.19f alpha:1.00f];
    sliderView.delegate=self;
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, sliderView.height-1, WIDTH, 1)];
    view.backgroundColor=[UIColor lightGrayColor];
    [sliderView addSubview:view];
    [sliderView bringSubviewToFront:sliderView.horiLine];
    return sliderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void)refreshBtnTitle{
    if(self.wangBtn.width<55){
        [self.wangBtn setTitle:@"提问" forState:UIControlStateNormal];
        self.wangBtn.hidden=YES;
    }else if(self.wangBtn.width>=55&&self.wangBtn.width<=65){
        [self.wangBtn setTitle:@"...提问" forState:UIControlStateNormal];
        self.wangBtn.hidden=NO;
    }else if(self.wangBtn.width>65&&self.wangBtn.width<=80){
        [self.wangBtn setTitle:@"...要提问" forState:UIControlStateNormal];
    }else if(self.wangBtn.width>80){
        [self.wangBtn setTitle:@"我要提问" forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static CGFloat oldOffset;
    CGFloat offset = scrollView.contentOffset.y;
    if(offset<=0)return;
    if(offset>=oldOffset){//上拉
        if(offset<=112){
            self.wangBtn.x=(WIDTH-100)*0.5+(((WIDTH-66)-(WIDTH-100)*0.5)*offset/112);
            self.wangBtn.width=100-(100-50)*offset/112;
        }
    }else{//下滑
        if(offset<=112){
            self.wangBtn.x=(WIDTH-100)*0.5+(((WIDTH-66)-(WIDTH-100)*0.5)*offset/112);
            self.wangBtn.width=100-(100-50)*offset/112;
        }else if(offset<=112+28+64){
            self.wangBtn.width=55;
        }
    }
    [self refreshBtnTitle];
    oldOffset=offset;
}

- (void)sliderView:(CustomSliderView *)sliderView andIndex:(NSInteger)index andBtnArray:(NSArray *)btnArray{
    self.page=0;
    self.currentBtnIndex=index;
    [self.mainViewDelegate sliderView:sliderView andIndex:index andBtnArray:btnArray];
}
#pragma mark - 设置数据源
- (void)setDataArray:(NSArray *)dataArray{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    if(dataArray.count){
        _dataArray=dataArray;
        self.page++;
        [self reloadData];
    }
}


@end
