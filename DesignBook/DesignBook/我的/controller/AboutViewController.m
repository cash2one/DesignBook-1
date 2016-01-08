//
//  AboutViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-8.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (instancetype)init{
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"AboutViewController" bundle:nil];
    AboutViewController * con =[sb instantiateViewControllerWithIdentifier:@"AboutViewController"];
    return con;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self loadNavigationBar];
    [self createTableHeaderView];
}

- (void)createTableHeaderView{
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    headerView.backgroundColor=[UIColor colorWithRed:0.92f green:0.91f blue:0.92f alpha:1.00f];
    
    UIImageView * iv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AppIcon60x60"]];
    iv.frame=CGRectMake((WIDTH-50)*0.5, 50, 50, 50);
    iv.layer.masksToBounds=YES;
    iv.layer.cornerRadius=5.f;
    [headerView addSubview:iv];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 115, WIDTH, 20)];
    label.text=@"设计本V2.2.0";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    
    UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 140+15, WIDTH, 20)];
    label2.text=@"www.shejiben.com";
    label2.textColor=[UIColor lightGrayColor];
    label2.textAlignment=NSTextAlignmentCenter;
    label2.font=[UIFont systemFontOfSize:10];
    [headerView addSubview:label2];
    self.tableView.tableHeaderView=headerView;
}

- (void)loadNavigationBar{
    self.navigationItem.title=@"关于设计本";
    UIBarButtonItem * bbil=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousViewCon)];
    self.navigationItem.leftBarButtonItem=bbil;
}

- (void)backToPreviousViewCon{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
@end
