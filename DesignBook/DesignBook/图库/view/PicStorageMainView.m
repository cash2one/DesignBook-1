//
//  PicStorageMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-4.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "PicStorageMainView.h"
#import "PicStorageMainCell.h"
#import "UIImageView+WebCache.h"

@interface PicStorageMainView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>



@end

@implementation PicStorageMainView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
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

#pragma mark - 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PictureInfo * info=self.dataArray[indexPath.item];
    static NSString * identifier=@"PicStorageMainCell";
    
    UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
    
    [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    
    PicStorageMainCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:info.imgUrl] placeholderImage:[UIImage imageNamed:@"default_logo"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.mainViewDelegate itemSelectedWithMainView:self andIndexPath:indexPath];
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


- (void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;
    self.page++;
    [self reloadData];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

@end
