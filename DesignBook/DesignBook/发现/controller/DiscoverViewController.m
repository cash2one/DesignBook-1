//
//  DiscoverViewController.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DisSearchDesViewController.h"
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

- (void)loadMainView{
    DiscoverMainView *mainView=[[DiscoverMainView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    mainView.mainViewDelegate=self;
    self.mainView=mainView;
    [self.view addSubview:mainView];
    
    UIButton * cancleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.frame=CGRectMake(WIDTH-60, 28, 60, 28);
    [cancleBtn addTarget:self action:@selector(cancleBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
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
}

- (void)btnTouchAndIndex:(NSInteger)index{
    if(index==0){
        [self.navigationController pushViewController:[DisSearchDesViewController new] animated:YES];
    }else{
        WebViewController * con = [WebViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.requestUrl=@"http://m.shejiben.com/appZb?systemversion=9.0&uid=0&channel=appstore&idfa=89645ED5-2C23-4C4F-AE9F-D67A77D36477&t8t_device_id=AD9C8E68-5378-4D13-B0F5-97A500D6842E&appostype=2&version=2.2&to8to_token=&appid=30&appversion=2.2.0";
    }
}

#pragma mark - search框协议方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.1 animations:^{
        textField.width=WIDTH-76;
    }];
    textField.placeholder=@"搜索案例/图片/问答/设计师";
    self.mainView.hidden=YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.1 animations:^{
        textField.width=WIDTH-16;
    }];
    textField.placeholder=@"搜索案例/图片/问答...";
    self.mainView.hidden=NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}


- (void)cancleBtnTouch:(UIButton *)btn{
    self.mainView.hidden=NO;
    [self.view endEditing:YES];
}

#pragma mark - 系统协议方法
- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden=YES;
}

@end
