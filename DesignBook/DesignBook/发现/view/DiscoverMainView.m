//
//  DiscoverMainView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-2.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "DiscoverMainView.h"
#import "UIButton+RefreshLocation.h"
#import "UIView+Frame.h"

@interface DiscoverMainView()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)UIView * leftBtn;
@property(nonatomic,weak)UIView * rightBtn;

@end

@implementation DiscoverMainView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        self.dataSource=self;
        self.delegate=self;
        [self createTableHeaderView];
    }
    return self;
}

- (void)createTableHeaderView{
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 108)];
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 8, WIDTH*0.5-0.5, 100);
    
    UIView * viewLeft=[[UIView alloc]initWithFrame:CGRectMake(0, 8, WIDTH*0.5-0.5, 100)];
    [self btnWithTitle:@"找设计师\n85万设计师任你挑选" andImage:[UIImage imageNamed:@"ico_find_designer"] andView:viewLeft];
    [headerView addSubview:viewLeft];
    self.leftBtn=viewLeft;
    
    UIView * viewRight=[[UIView alloc]initWithFrame:CGRectMake(WIDTH*0.5+0.5, 8, WIDTH*0.5-0.5, 100)];
    [self btnWithTitle:@"申请设计\n快速找到满意设计师" andImage:[[UIImage imageNamed:@"ico_find_demand"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] andView:viewRight];
    [headerView addSubview:viewRight];
    self.rightBtn=viewRight;
    
    self.tableHeaderView=headerView;
}

- (void)btnWithTitle:(NSString *)title andImage:(UIImage *)image andView:(UIView *)view{
    view.backgroundColor=[UIColor whiteColor];
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake((view.width-30)*0.5, 15, 30, 30)];
    imageView.image=image;
    [view addSubview:imageView];
    
    CGFloat labelY=CGRectGetMaxY(imageView.frame);
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, labelY, view.width, view.height-labelY)];
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=2;
    
    //NSMutableAttributedString 设置label文字不同样式显示
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:title];
    NSDictionary * attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blackColor]};
    [attString addAttributes:attributes1 range:NSMakeRange(0, 4)];
    NSDictionary * attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor grayColor]};
    [attString addAttributes:attributes2 range:NSMakeRange(4, title.length-4)];
    label.attributedText = attString;
    
    [view addSubview:label];
    
    UITapGestureRecognizer * tgr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnTouch:)];
    [view addGestureRecognizer:tgr];
}

- (void)btnTouch:(UITapGestureRecognizer *)tgr{
    if(self.leftBtn==tgr.view){
        [self.mainViewDelegate btnTouchAndIndex:0];
    }else{
        [self.mainViewDelegate btnTouchAndIndex:1];
    }
}

#pragma mark - tableView的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[[UITableViewCell alloc]init];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section==0){
        if(indexPath.row==0){
            cell.textLabel.text=@"同城设计师";
            cell.imageView.image=[UIImage imageNamed:@"ico_find_citywide"];
        }else{
            cell.textLabel.text=@"热门设计师";
            cell.imageView.image=[UIImage imageNamed:@"ico_find_hot"];
        }
    }else{
        cell.textLabel.text=@"装修设计顾问";
        cell.imageView.image=[UIImage imageNamed:@"ico_find_phone"];
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    view.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;
    [self reloadData];
}
@end
