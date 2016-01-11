//
//  DiscoverViewController.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DisSearchDesViewController.h"
#import "SearchViewController.h"
#import "WebViewController.h"
#import "DiscoverMainView.h"

@interface DiscoverViewController ()<UITextFieldDelegate,DiscoverMainViewDelegate>

@property(nonatomic,weak)UISearchBar * searchBar;
@property(nonatomic,weak)DiscoverMainView * mainView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self loadMainView];
}
#pragma mark - 初始化
- (void)loadMainView{
    DiscoverMainView *mainView=[[DiscoverMainView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    mainView.mainViewDelegate=self;
    self.mainView=mainView;
    [self.view addSubview:mainView];
    
    UIButton * cancleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.frame=CGRectMake(WIDTH-60, 28, 60, 28);
    [self.view addSubview:cancleBtn];
    
    
    UITextField * tf=[[UITextField alloc]initWithFrame:CGRectMake(8, 28, WIDTH-16, 28)];
    tf.borderStyle=UITextBorderStyleRoundedRect;
    tf.font=[UIFont systemFontOfSize:12];
    tf.delegate=self;
    tf.placeholder=@"搜索案例/图片/问答...";
    tf.backgroundColor=[UIColor colorWithRed:0.92f green:0.91f blue:0.92f alpha:1.00f];
    tf.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_find_search"]];
    tf.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:tf];
    UIImageView * iv=[[UIImageView alloc]initWithFrame:CGRectMake(8, 28, WIDTH-16, 28)];
//    iv.image=[UIImage imageNamed:@"guidance_page04"];
    [self.view addSubview:iv];
    iv.userInteractionEnabled=YES;
    UITapGestureRecognizer * tgr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFiledTouch)];
    [iv addGestureRecognizer:tgr];
}

- (void)textFiledTouch{
    SearchViewController * con=[SearchViewController new];
    [self.navigationController pushViewController:con animated:NO];
}

- (void)btnTouchAndIndex:(NSInteger)index{
    if(index==0){
        DisSearchDesViewController * con= [DisSearchDesViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.indexArray=[NSMutableArray arrayWithArray:@[@(0),@(0),@(0)]];
    }else{
        WebViewController * con = [WebViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.requestUrl=@"http://m.shejiben.com/appZb?systemversion=9.0&uid=0&channel=appstore&idfa=89645ED5-2C23-4C4F-AE9F-D67A77D36477&t8t_device_id=AD9C8E68-5378-4D13-B0F5-97A500D6842E&appostype=2&version=2.2&to8to_token=&appid=30&appversion=2.2.0";
    }
}

- (void)itemSelectedWithMainView:(DiscoverMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        DisSearchDesViewController * con= [DisSearchDesViewController new];
        [self.navigationController pushViewController:con animated:YES];
        if(indexPath.row==0){
            con.indexArray=[NSMutableArray arrayWithArray:@[@(1),@(0),@(0)]];
        }else{
            con.indexArray=[NSMutableArray arrayWithArray:@[@(0),@(0),@(3)]];
        }
    }else{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://400-680-8509,9999"]];
    }
}

#pragma mark - 系统协议方法
- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden=YES;
    [AppDelegate getTabbar].hidden=NO;
}

@end
