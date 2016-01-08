//
//  MineSettingViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-8.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "MineSettingViewController.h"
#import "AboutViewController.h"
#import "SDImageCache.h"
#import "SQLiteManager.h"

@interface MineSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheSize;

@end

@implementation MineSettingViewController

- (instancetype)init{
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"MineSettingViewController" bundle:nil];
    MineSettingViewController * con =[sb instantiateViewControllerWithIdentifier:@"MineSettingViewController"];
    return con;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cacheSize.text=[NSString stringWithFormat:@"%.2fM",[SQLiteManager cacheSize]*1.0/1024/1024];
    self.tableView.delegate=self;
    [self loadNavigationBar];
}

- (void)loadNavigationBar{
    self.navigationItem.title=@"设置";
    UIBarButtonItem * bbil=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousViewCon)];
    self.navigationItem.leftBarButtonItem=bbil;
}

- (void)backToPreviousViewCon{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        [[SDImageCache sharedImageCache] clearDisk];
        self.cacheSize.text=[NSString stringWithFormat:@"%.2fM",[SQLiteManager cacheSize]*1.0/1024/1024];
    }else if(indexPath.section==2){
        AboutViewController * con=[[AboutViewController alloc]init];
        [self.navigationController pushViewController:con animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
}

@end
