//
//  CaseScrollMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CaseScrollMainView.h"
#import "CaseScrollMainCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"

@interface CaseScrollMainView()

@property(nonatomic,assign)CGFloat headerHeight;
@property(nonatomic,assign)CGFloat commentHeight;

@property(nonatomic,weak)UIImageView * headerImageView;

@property(nonatomic,weak)UIImageView * memberImageView;
@end

@implementation CaseScrollMainView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource=self;
        self.delegate=self;
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)setheaderView{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.headerHeight)];
    UIImageView * headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    self.headerImageView=headerImageView;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.banner.imgUrl] placeholderImage:[UIImage imageNamed:@"default_logo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.shareImage=image;
    }];
    [view addSubview:headerImageView];
    
    UIImageView *memberImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH*0.5-25, 200-25, 50, 50)];
    self.memberImageView=memberImageView;
    memberImageView.layer.masksToBounds=YES;
    memberImageView.layer.cornerRadius=memberImageView.width*0.5;
    memberImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    memberImageView.layer.borderWidth = 1.0f;
    [memberImageView sd_setImageWithURL:[NSURL URLWithString:self.banner.memberInfo.facePic] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    [view addSubview:memberImageView];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 225, WIDTH, 35)];
    label.font=[UIFont systemFontOfSize:14];
    label.text=self.banner.memberInfo.nick;
    label.textColor=[UIColor grayColor];
    label.textAlignment=NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIView * hl=[[UIView alloc]initWithFrame:CGRectMake((WIDTH-150)*0.5, CGRectGetMaxY(label.frame)-1, 150, 1)];
    hl.backgroundColor=[UIColor grayColor];
    [view addSubview:hl];
    
    UILabel * commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(hl.frame)+10, WIDTH-16, self.commentHeight)];
    commentLabel.font=[UIFont systemFontOfSize:15];
    commentLabel.textColor=[UIColor darkGrayColor];
    commentLabel.numberOfLines=0;
    commentLabel.text=self.banner.comment;
    [view addSubview:commentLabel];
    self.tableHeaderView=view;
}

#pragma mark - tableView的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.banner.imgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"CaseScrollMainCell";
    CaseScrollMainCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.imageInfo=self.banner.imgList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y=scrollView.contentOffset.y;
    if(y<0){
        self.headerImageView.y=y;
        //随着y变大高度变大
        self.headerImageView.height=200-y;
        self.headerImageView.width=WIDTH-2*y;
        self.headerImageView.x=y;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat y=scrollView.contentOffset.y;
    if(y<0){
        self.headerImageView.y=y;
        //随着y变大高度变大
        self.headerImageView.height=200-y;
        self.headerImageView.width=WIDTH-2*y;
        self.headerImageView.x=y;
    }
}

#pragma mark - 设置数据源
- (void)setBanner:(Banner *)banner{
    _banner=banner;
    CGSize size=CGSizeMake(WIDTH-16, MAXFLOAT);
    size=[banner.comment boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.headerHeight=200+70+size.height;
    self.commentHeight=size.height;
    [self setheaderView];
    [self reloadData];
}

@end
