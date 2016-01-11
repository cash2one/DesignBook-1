//
//  SearchMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-9.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "SearchMainView.h"
#import "CustomSliderView.h"
#import "CaseMainCell.h"
#import "QueAndAnsMainCell.h"
#import "DisSearchDesMainCell.h"
#import "PicStorageMainCell.h"
#import "UIImageView+WebCache.h"

@interface SearchMainView()<CustomSliderViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)NSArray * contentViewArray;

@end

@implementation SearchMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSliderView];
        [self createContentView];
    }
    return self;
}

- (void)createSliderView{
    CustomSliderView * sliderView=[CustomSliderView sliderViewWithItems:@[@"案例",@"图片",@"问答",@"设计师"] andFrame:CGRectMake(0, 0, WIDTH, 40)];
    sliderView.delegate=self;
    sliderView.horiLine.hidden=YES;
    sliderView.selectedTitleColor=[UIColor redColor];
    [self addSubview:sliderView];
}

- (void)createContentView{
    CGRect frame=CGRectMake(0, 40, WIDTH, HEIGHT-40-64);
    
    UITableView * tableView1=[[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    tableView1.dataSource=self;
    tableView1.delegate=self;
    [self addSubview:tableView1];
    
    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc]init];
    UICollectionView * collectionView2=[[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    collectionView2.backgroundColor=[UIColor whiteColor];
    collectionView2.dataSource=self;
    collectionView2.delegate=self;
    [self addSubview:collectionView2];
    
    UITableView * tableView3=[[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    tableView3.dataSource=self;
    tableView3.delegate=self;
    [self addSubview:tableView3];
    
    UITableView * tableView4=[[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    tableView4.dataSource=self;
    tableView4.delegate=self;
    [self addSubview:tableView4];
    
    self.contentViewArray=@[tableView1,collectionView2,tableView3,tableView4];
    for (UIScrollView * sv in self.contentViewArray) {
        sv.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page=0;
            [self.delegate refreshWithMainView:self andRefreshComponent:sv.mj_header andScrollView:sv];
        }];
        sv.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.delegate refreshWithMainView:self andRefreshComponent:sv.mj_footer andScrollView:sv];
        }];
    }
}

- (void)sliderView:(CustomSliderView *)sliderView andIndex:(NSInteger)index andBtnArray:(NSArray *)btnArray{
    self.currentSliderIndex=index;
    [self.delegate searchMainView:self andSliderBtnIndex:index];
}

#pragma mark - tableView的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[self.currentSliderIndex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.currentSliderIndex==0){
        static NSString * identifier=@"CaseMainCell";
        CaseMainCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell==nil){
            UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        }
        cell.cases=self.dataArray[self.currentSliderIndex][indexPath.row];
        return cell;
    }else if (self.currentSliderIndex==2){
        static NSString * identifier=@"QueAndAnsMainCell";
        QueAndAnsMainCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell==nil){
            UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        }
        cell.queAndAns=self.dataArray[self.currentSliderIndex][indexPath.row];
        return cell;
    }else if (self.currentSliderIndex==3){
        static NSString * identifier=@"DisSearchDesMainCell";
        DisSearchDesMainCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell==nil){
            UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        }
        cell.memberInfo=self.dataArray[self.currentSliderIndex][indexPath.row];
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.currentSliderIndex==0){
        return 300;
    }else if (self.currentSliderIndex==2){
        return 90;
    }else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate itemSelectedWithMainView:self andIndexPath:indexPath andCurrentBtnIndex:self.currentSliderIndex];
}

#pragma mark - 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArray[1] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageInfo * info=self.dataArray[1][indexPath.item];
    static NSString * identifier=@"PicStorageMainCell";
    
    UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
    
    [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    
    PicStorageMainCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:info.imgUrl] placeholderImage:[UIImage imageNamed:@"default_logo"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate itemSelectedWithMainView:self andIndexPath:indexPath andCurrentBtnIndex:self.currentSliderIndex];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 8, 0, 8);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(0.5*(WIDTH-24), 0.5*(WIDTH-24));
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}


#pragma mark - 设置数据源
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;
    UIScrollView * sv=self.contentViewArray[self.currentSliderIndex];
    [sv.mj_header endRefreshing];
    [sv.mj_footer endRefreshing];
    NSInteger count = [self.dataArray[self.currentSliderIndex] count];
    if(count%20==0){
        self.page=count/20;
    }else{
        self.page=count/20+1;
        [sv.mj_footer endRefreshingWithNoMoreData];
        
    }
    [self.contentViewArray[self.currentSliderIndex] reloadData];
    [self bringSubviewToFront:self.contentViewArray[self.currentSliderIndex]];
}


@end
