//
//  MineViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-2.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "MineViewController.h"
#import "MineSettingViewController.h"
#import "MineMainView.h"

@interface MineViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containView;

@property(nonatomic,weak)UITableView * tableView;

@end

@implementation MineViewController
- (instancetype)init{
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"MineViewController" bundle:nil];
    MineViewController * con =[sb instantiateViewControllerWithIdentifier:@"MineViewController"];
    return con;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView=self.containView.subviews[0];
    self.tableView.rowHeight=44;
    self.tableView.delegate=self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        [self.navigationController pushViewController:[[MineSettingViewController alloc]init] animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - 系统协议方法
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
}

@end
