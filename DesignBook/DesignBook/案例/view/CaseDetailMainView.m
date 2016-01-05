//
//  CaseDetailMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CaseDetailMainView.h"
#import "CaseScrollMainCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"

@interface CaseDetailMainView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)CGFloat headerHeight;
@property(nonatomic,assign)CGFloat commentHeight;

@property(nonatomic,weak)UIImageView * headerImageView;
@property(nonatomic,weak)UIImageView * memberImageView;

@end

@implementation CaseDetailMainView
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
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.cases.imgUrl] placeholderImage:[UIImage imageNamed:@"default_logo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.shareImage=image;
    }];
    [view addSubview:headerImageView];
    
    UIImageView *memberImageView=[[UIImageView alloc]initWithFrame:CGRectMake(8, 200-8, 50, 50)];
    self.memberImageView=memberImageView;
    memberImageView.layer.masksToBounds=YES;
    memberImageView.layer.cornerRadius=memberImageView.width*0.5;
    memberImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    memberImageView.layer.borderWidth = 1.0f;
    [memberImageView sd_setImageWithURL:[NSURL URLWithString:self.cases.facePic] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    [view addSubview:memberImageView];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(memberImageView.frame)+8, 208, 200, 21)];
    label.text=[NSString stringWithFormat:@"设计师：%@",self.cases.nick];
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:13];
    [view addSubview:label];
    
    UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(memberImageView.frame)+8, 230, 200, 21)];
    label2.text=[NSString stringWithFormat:@"设计费用：%@",self.cases.feeRand];
    label2.textColor=[UIColor grayColor];
    label2.font=[UIFont systemFontOfSize:13];
    [view addSubview:label2];
    
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 208, WIDTH-CGRectGetMaxX(label.frame), 43)];
    [btn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"ico_qa_phone"] forState:UIControlStateNormal];
    [view addSubview:btn];
    
    UIView * sl=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 208, 1, 43)];
    sl.backgroundColor=[UIColor lightGrayColor];
    [view addSubview:sl];
    
    UIView * hl=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame)+8, WIDTH, 1)];
    hl.backgroundColor=[UIColor lightGrayColor];
    [view addSubview:hl];
    
    UILabel * commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(hl.frame)+10, WIDTH-16, self.commentHeight)];
    commentLabel.font=[UIFont systemFontOfSize:15];
    commentLabel.textColor=[UIColor darkGrayColor];
    commentLabel.numberOfLines=0;
    commentLabel.text=self.cases.comment;
    [view addSubview:commentLabel];
    self.tableHeaderView=view;
}

- (void)callPhone{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.cases.phoneNum400]]];
}

#pragma mark - tableView的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cases.imgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"CaseScrollMainCell";
    CaseScrollMainCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.imageInfo=self.cases.imgList[indexPath.row];
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
- (void)setCases:(Case *)cases{
    _cases=cases;
    CGSize size=CGSizeMake(WIDTH-16, MAXFLOAT);
    size=[cases.comment boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.headerHeight=200+70+size.height;
    self.commentHeight=size.height;
    [self setheaderView];
    [self reloadData];
    
}

@end
