//
//  CustomDropDownListView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-4.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CustomDropDownListView.h"
#import "UIView+Frame.h"
#import "UIButton+RefreshLocation.h"

@interface CustomDropDownListView()

@property(nonatomic,weak)UIButton * headerBtn;

@property(nonatomic,assign)BOOL isExpand;

@property(nonatomic,strong)NSIndexPath * indexPath;

@end

@implementation CustomDropDownListView

+ (instancetype)dropDownListViewWithDataArray:(NSArray *)dataArray andFrame:(CGRect)frame{
    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing=20;
    layout.minimumInteritemSpacing=20;
    
    return [[self alloc]initWithDataArray:dataArray andFrame:frame collectionViewLayout:layout];
}

- (instancetype)initWithDataArray:(NSArray *)dataArray  andFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    NSInteger row = (dataArray.count+2)/3;
    frame.size.height=row*54+20;
    if(row*54+20>[UIScreen mainScreen].bounds.size.height-64-44-49){
        frame.size.height=[UIScreen mainScreen].bounds.size.height-64-44-49;
    }
    if(self=[super initWithFrame:frame collectionViewLayout:layout]){
        self.backgroundColor=[UIColor colorWithRed:0.92f green:0.91f blue:0.92f alpha:1.00f];
        self.dataArray=dataArray;
        self.hidden=YES;
        self.dataSource=self;
        self.delegate=self;
    }
    return self;
}

- (void)setBtnStyle:(UIButton *)btn andTitle:(NSString *)title andFrame:(CGRect)frame{
    self.headerBtn=btn;
    btn.frame=frame;
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"ico_drop_downarrow"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"ico_drop_uparrow"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn refreshRightLeft];
    btn.layer.borderWidth=1.0f;
    btn.layer.borderColor=[[UIColor lightGrayColor] CGColor];
}

#pragma mark - collectionView的协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"Cell";
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    UICollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    cell.contentView.backgroundColor=[UIColor clearColor];
    
    cell.layer.borderColor=[[UIColor whiteColor]CGColor];
    cell.layer.borderWidth=1.0f;
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, (WIDTH-80)/3, 30)];
    label.text=self.dataArray[indexPath.item];
    label.font=[UIFont systemFontOfSize:14];
    label.backgroundColor=[UIColor whiteColor];
    label.textColor=[UIColor grayColor];
    label.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    label.layer.masksToBounds=YES;
    label.layer.cornerRadius=2;
    if(indexPath.item==self.indexPath.item){
        cell.layer.borderColor=[[UIColor redColor]CGColor];
        cell.layer.borderWidth=1.0f;
        label.textColor=[UIColor redColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self refreshBtnTitle:indexPath];
    [self.mainViewDelegate itemSelectedWithMainView:self andIndexPath:indexPath andBtn:self.headerBtn];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDTH-80)/3, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition{
    [self refreshBtnTitle:indexPath];
}

- (void)refreshBtnTitle:(NSIndexPath *)indexPath{
    self.indexPath=indexPath;
    UICollectionViewCell * selectedCell = [self cellForItemAtIndexPath:indexPath];
    for (UIView * view in self.subviews) {
        if([[view class] isSubclassOfClass:[UICollectionViewCell class]]){
            UICollectionViewCell * cell = (UICollectionViewCell *)view;
            if(cell==selectedCell){
                cell.layer.borderColor=[[UIColor redColor]CGColor];
                cell.layer.borderWidth=1.0f;
                for (UILabel *label in cell.contentView.subviews) {
                    label.textColor=[UIColor redColor];
                }
            }else{
                cell.layer.borderWidth=0;
                for (UILabel *label in cell.contentView.subviews) {
                    label.textColor=[UIColor grayColor];
                }
            }
        }
    }
    [self.headerBtn setTitle:self.dataArray[indexPath.item] forState:UIControlStateNormal];
    [self.headerBtn refreshRightLeft];
}

@end
