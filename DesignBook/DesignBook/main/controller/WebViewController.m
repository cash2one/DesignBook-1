//
//  WebViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "WebViewController.h"
#import "CustomWebProgressView.h"
#import <WebKit/WebKit.h>
#import "UMSocial.h"
#import "AppDelegate.h"

@interface WebViewController ()

@property(nonatomic,weak)WKWebView * webView;

@property(nonatomic,weak)CustomWebProgressView * webProgressView;

@property(nonatomic,assign)BOOL isNavigationShow;
@property(nonatomic,assign)BOOL isTabbarShow;
@property(nonatomic,copy)UIColor * oldNavBgColor;
@property(nonatomic,assign)UIStatusBarStyle statusBarStyle;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [self loadNavicationBar];
    [self loadWebView];
    [self loadWebProgressView];

}

- (void)loadNavicationBar{
    self.navigationItem.title=self.titleName;
    
    UIBarButtonItem * lbbi=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousViewCon)];
    
    self.navigationItem.leftBarButtonItem=lbbi;
    
    if(!self.isHiddenShare){
        UIBarButtonItem * r1bbi=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_share_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareWebView)];
        
        self.navigationItem.rightBarButtonItems=@[r1bbi];
    }
}

- (void)backToPreviousViewCon{
    [self.webProgressView freeWebProgressView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareWebView{
    [UMSocialSnsService presentSnsController:self appKey:KUMengKey shareText:self.requestUrl shareImage:self.shareImage shareToSnsNames:@[UMShareToSina,UMShareToQQ,UMShareToWechatSession,UMShareToRenren] delegate:nil];
}

- (void)loadWebView{
    WKWebView * webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    [self.view addSubview:webView];
    self.webView= webView;
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]];
    [webView loadRequest:request];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView) {
            self.navigationItem.title = self.webView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

- (void)loadWebProgressView{
    CustomWebProgressView * pv=[CustomWebProgressView progressViewAndFrame:CGRectMake(0, 64, WIDTH, 2) andWebView:self.webView];
    pv.backgroundColor=[UIColor redColor];
    [self.view addSubview:pv];
    self.webProgressView=pv;
}

#pragma mark - view代理
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=self.isTabbarShow;
    self.navigationController.navigationBarHidden=self.isNavigationShow;
    self.navigationController.navigationBar.barTintColor=self.oldNavBgColor;
    [AppDelegate getTabbar].hidden=NO;
    
    [UIApplication sharedApplication].statusBarStyle=self.statusBarStyle;
    
    [self.webView removeObserver:self forKeyPath:@"title"];
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    
    //记录原来的信息
    self.isNavigationShow = self.navigationController.navigationBarHidden;
    self.isTabbarShow = self.tabBarController.tabBar.hidden;
    self.oldNavBgColor=self.navigationController.navigationBar.barTintColor;
    self.statusBarStyle=[UIApplication sharedApplication].statusBarStyle;
    
    //设置现在要处的状态
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    [AppDelegate getTabbar].hidden=YES;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    
    [super viewDidAppear:animated];
}

@end
