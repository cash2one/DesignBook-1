//
//  MemberMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-7.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "MemberMainView.h"
#import "MemberMainHeaderView.h"
#import "MemberMainSmallPage.h"
#import "UIView+Frame.h"
#import "CaseMainCell.h"
#import "BlogArticleCell.h"

@interface MemberMainView()<UITableViewDataSource,UITableViewDelegate,CustomSliderViewDelegate,UIScrollViewDelegate>

@property(nonatomic,assign)NSInteger currentBtnIndex;

@property(nonatomic,weak)MemberMainHeaderView * headerView;

@property(nonatomic,weak)MemberMainSmallPage * smallPage;

@property(nonatomic,weak)UIImageView * sjsPageControl;

@end

@implementation MemberMainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource=self;
        self.delegate=self;
        [self createTableHeaderView];
        
        self.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.mainViewDelegate refreshWithMainView:self andRefreshComponent:self.mj_footer];
        }];
    }
    return self;
}

- (void)createTableHeaderView{
    UIScrollView * scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 314)];
    scrollView.contentSize=CGSizeMake(WIDTH*2, 0);
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    scrollView.showsHorizontalScrollIndicator=NO;
    self.tableHeaderView=scrollView;
    
    MemberMainHeaderView *headerView=[[[NSBundle mainBundle]loadNibNamed:@"MemberMainHeaderView" owner:nil options:nil] lastObject];
    [headerView.onlineBtn addTarget:self action:@selector(onlineBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    headerView.frame=CGRectMake(0, 0, scrollView.width, scrollView.height);
    [scrollView addSubview:headerView];
    self.headerView=headerView;
    
    MemberMainSmallPage * smallPage=[[[NSBundle mainBundle]loadNibNamed:@"MemberMainSmallPage" owner:nil options:nil] lastObject];
    smallPage.frame=CGRectMake(WIDTH, 0, WIDTH, scrollView.height);
    [scrollView addSubview:smallPage];
    self.smallPage=smallPage;
    
    UIImageView * imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sjsPageCtrl"]];
    imageView.frame=CGRectMake(0, 0, 26, 6);
    imageView.center=scrollView.center;
    imageView.y=293;
    self.sjsPageControl=imageView;
    [self addSubview:imageView];
}

- (void)onlineBtnTouch:(UIButton *)btn{
    [self.mainViewDelegate onlineBtnTouch:btn];
}

#pragma mark - tableView的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.currentBtnIndex==2){
        return 0;
    }
    return [self.dataArray[self.currentBtnIndex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.currentBtnIndex==0){
        static NSString * identifier=@"CaseMainCell";
        CaseMainCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell==nil){
            UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        }
        cell.cases=[self.dataArray[self.currentBtnIndex] objectAtIndex:indexPath.row];
        cell.headerImageView.hidden=YES;
        return cell;
    }else if(self.currentBtnIndex==1){
        static NSString * identifier=@"BlogArticleCell";
        BlogArticleCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell==nil){
            UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        }
        cell.blogArticle=[self.dataArray[self.currentBtnIndex] objectAtIndex:indexPath.row];
        return cell;
    }else{
        
        
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.currentBtnIndex==0){
        return 300;
    }else{
        return 116;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mainViewDelegate itemSelectedWithMainView:self andIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CustomSliderView * sliderView=[CustomSliderView sliderViewWithItems:@[@"案例",@"博文",@"评价"] andFrame:CGRectMake(0, 0, WIDTH, 44)];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView!=self){
        BOOL b= scrollView.contentOffset.x+WIDTH*0.5>WIDTH;
        if(b){
            self.sjsPageControl.transform=CGAffineTransformMakeRotation(M_PI);
        }else{
            self.sjsPageControl.transform=CGAffineTransformIdentity;
        }
    }
}

#pragma mark - 横向按钮点击
- (void)sliderView:(CustomSliderView *)sliderView andIndex:(NSInteger)index andBtnArray:(NSArray *)btnArray{
    self.page=0;
    self.currentBtnIndex=index;
    [self.mainViewDelegate sliderView:sliderView andIndex:index andBtnArray:btnArray];
}

#pragma mark - 设置数据源
- (void)setMemberInfo:(MemberInfo *)memberInfo{
    _memberInfo=memberInfo;
    self.headerView.memberInfo=memberInfo;
    self.smallPage.memberInfo=memberInfo;
}

- (void)setDataArray:(NSArray *)dataArray{
    [self.mj_footer endRefreshing];
    if(dataArray.count){
        _dataArray=dataArray;
        self.page++;
        [self reloadData];
    }
}


@end
