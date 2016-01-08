//
//  PictureDetailMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-8.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "PictureDetailMainView.h"
#import "UIImageView+WebCache.h"
#import "PictureDetailMainCell.h"
#import "CustomSliderView.h"
#import "UIView+Frame.h"
#import "MJRefresh.h"

@interface PictureDetailMainView()<CustomSliderViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)UIImageView * headerImageView;

@property(nonatomic,weak)UIImageView * memberImageView;

@property(nonatomic,assign)CGFloat headerHeight;

@property(nonatomic,assign)CGFloat commentHeight;

@property(nonatomic,strong)UILabel * zhezhaoLabel;

@end

static CGFloat imageHeight=300;

@implementation PictureDetailMainView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        self.dataSource=self;
        self.delegate=self;
        self.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.mj_footer endRefreshingWithNoMoreData];
        }];
    }
    return self;
}

- (void)createHeaderView{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.headerHeight)];
    UIImageView * headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, imageHeight)];
    self.headerImageView=headerImageView;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageInfo.imgUrl] placeholderImage:[UIImage imageNamed:@"default_logo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.shareImage=image;
    }];
    [view addSubview:headerImageView];
    
    UIImageView *memberImageView=[[UIImageView alloc]initWithFrame:CGRectMake(8, imageHeight-8, 50, 50)];
    self.memberImageView=memberImageView;
    memberImageView.layer.masksToBounds=YES;
    memberImageView.layer.cornerRadius=memberImageView.width*0.5;
    memberImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    memberImageView.layer.borderWidth = 1.0f;
    [memberImageView sd_setImageWithURL:[NSURL URLWithString:self.imageInfo.memberInfo.facePic] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    UITapGestureRecognizer * tgr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(memHeaderImageViewTouch:)];
    memberImageView.userInteractionEnabled=YES;
    [memberImageView addGestureRecognizer:tgr];
    memberImageView.tag=self.imageInfo.memberInfo.uid;
    [view addSubview:memberImageView];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(memberImageView.frame)+8, imageHeight+8, 200, 21)];
    label.text=[NSString stringWithFormat:@"设计师：%@",self.imageInfo.memberInfo.nick];
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:13];
    [view addSubview:label];
    
    UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(memberImageView.frame)+8, imageHeight+30, 200, 21)];
    label2.text=[NSString stringWithFormat:@"设计费用：%@",self.imageInfo.memberInfo.feeRand];
    label2.textColor=[UIColor grayColor];
    label2.font=[UIFont systemFontOfSize:13];
    [view addSubview:label2];
    
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), imageHeight+8, WIDTH-CGRectGetMaxX(label.frame), 43)];
    [btn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"ico_qa_phone"] forState:UIControlStateNormal];
    [view addSubview:btn];
    
    UIView * sl=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame),imageHeight+8, 1, 43)];
    sl.backgroundColor=[UIColor lightGrayColor];
    [view addSubview:sl];
    
    UIView * hl=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame)+8, WIDTH, 1)];
    hl.backgroundColor=[UIColor lightGrayColor];
    [view addSubview:hl];
    
    UILabel * commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(hl.frame)+10, WIDTH-16, self.commentHeight)];
    commentLabel.font=[UIFont systemFontOfSize:15];
    commentLabel.textColor=[UIColor darkGrayColor];
    commentLabel.numberOfLines=0;
    commentLabel.text=self.imageInfo.comment;
    [view addSubview:commentLabel];
    self.tableHeaderView=view;
}

- (void)memHeaderImageViewTouch:(UITapGestureRecognizer *)tgr{
    [self.mainViewDelegate memHeaderImageViewBtnTouch:tgr.view];
}

- (void)callPhone{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.imageInfo.memberInfo.phoneNum400]]];
}

- (void)sliderView:(CustomSliderView *)sliderView andIndex:(NSInteger)index andBtnArray:(NSArray *)btnArray{
    self.sliderCurrentIndex=index;
    [self reloadData];
    [self hiddenZhezhaoLabel];
}

#pragma mark - tableView的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sliderCurrentIndex?self.imageInfo.colList.count:self.imageInfo.askList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"PictureDetailMainCell";
    PictureDetailMainCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if(self.sliderCurrentIndex==0){
        cell.data=self.imageInfo.askList[indexPath.row];
    }else{
        cell.data=self.imageInfo.colList[indexPath.row];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    headerView.backgroundColor=[UIColor colorWithRed:0.92f green:0.91f blue:0.92f alpha:1.00f];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(8, 8, WIDTH-16, 60-16);
    btn.backgroundColor=[UIColor redColor];
    [headerView addSubview:btn];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"对图片提问" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"ico_signin"] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(0, -5, 0, 5);
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=3.f;
    
    CustomSliderView * sliderView=[CustomSliderView sliderViewWithItems:@[@"问答",@"收藏"] andFrame:CGRectMake(0, 60, WIDTH, 44)];
    [headerView addSubview:sliderView];
    [sliderView setSelectedBtn:self.sliderCurrentIndex];
    sliderView.horiLine.backgroundColor=[UIColor colorWithRed:0.87f green:0.19f blue:0.19f alpha:1.00f];
    sliderView.selectedTitleColor=[UIColor colorWithRed:0.87f green:0.19f blue:0.19f alpha:1.00f];
    sliderView.delegate=self;
    UIView * hl=[[UIView alloc]initWithFrame:CGRectMake(0, sliderView.height-1, WIDTH, 1)];
    hl.backgroundColor=[UIColor lightGrayColor];
    [sliderView addSubview:hl];
    [sliderView bringSubviewToFront:sliderView.horiLine];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mainViewDelegate itemSelectedWithMainView:self andIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y=scrollView.contentOffset.y;
    if(y<0){
        self.headerImageView.y=y;
        //随着y变大高度变大
        self.headerImageView.height=imageHeight-y;
        self.headerImageView.width=WIDTH-2*y;
        self.headerImageView.x=y;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat y=scrollView.contentOffset.y;
    if(y<0){
        self.headerImageView.y=y;
        //随着y变大高度变大
        self.headerImageView.height=imageHeight-y;
        self.headerImageView.width=WIDTH-2*y;
        self.headerImageView.x=y;
    }
}

#pragma mark - 设置数据源
- (void)setImageInfo:(ImageInfo *)imageInfo{
    _imageInfo=imageInfo;
    CGSize size=CGSizeMake(WIDTH-16, MAXFLOAT);
    size=[imageInfo.comment boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.headerHeight=imageHeight+70+size.height+10;
    self.commentHeight=size.height;
    [self createHeaderView];
    [self reloadData];
    [self hiddenZhezhaoLabel];
}

- (void)hiddenZhezhaoLabel{
    self.zhezhaoLabel.y=self.headerHeight+104;
    self.zhezhaoLabel.height=HEIGHT-imageHeight-100;
    if(self.sliderCurrentIndex==0){
        if(self.imageInfo.askList.count==0){
            self.zhezhaoLabel.text=@"该图片还没有问答记录哦！";
            self.zhezhaoLabel.hidden=NO;
        }else{
            self.zhezhaoLabel.hidden=YES;
        }
    }else{
        if(self.imageInfo.colList.count==0){
            self.zhezhaoLabel.text=@"该图片还没有收藏记录哦！";
            self.zhezhaoLabel.hidden=NO;
        }else{
            self.zhezhaoLabel.hidden=YES;
        }
    }
    [self bringSubviewToFront:self.zhezhaoLabel];
}

- (UILabel *)zhezhaoLabel{
    if(_zhezhaoLabel==nil){
        _zhezhaoLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, imageHeight)];
        _zhezhaoLabel.backgroundColor=[UIColor colorWithRed:0.92f green:0.91f blue:0.92f alpha:1.00f];
        _zhezhaoLabel.textColor=[UIColor lightGrayColor];
        _zhezhaoLabel.font=[UIFont systemFontOfSize:14];
        _zhezhaoLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_zhezhaoLabel];
        _zhezhaoLabel.hidden=YES;
    }
    return _zhezhaoLabel;
}

@end
