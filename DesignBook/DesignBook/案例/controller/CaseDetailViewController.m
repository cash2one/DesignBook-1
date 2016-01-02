//
//  CaseDetailViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "CaseDetailMainView.h"

@interface CaseDetailViewController ()<RequestUtilDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,strong)RequestUtil * requestUtil;

@property(nonatomic,weak)CaseDetailMainView * mainView;

@end

@implementation CaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainView];
    [self loadNavigationBar];
    [self downloadData];
}

#pragma mark - 初始化
- (void)loadMainView{
    CaseDetailMainView * mainView=[[CaseDetailMainView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    self.mainView=mainView;
    [self.view addSubview:mainView];
}

- (void)loadNavigationBar{
    
    UIImage * backImage=[[UIImage imageNamed:@"ico_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * shareImage=[[UIImage imageNamed:@"ico_share_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton * backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(0, 20, 50, 44);
    backBtn.backgroundColor=[UIColor clearColor];
    [backBtn addTarget:self action:@selector(backToPreviousViewCon) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    UIButton * shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake(WIDTH-50, 20, 50, 44);
    shareBtn.backgroundColor=[UIColor clearColor];
    [shareBtn addTarget:self action:@selector(shareWebView) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:shareImage forState:UIControlStateNormal];
    [self.view addSubview:shareBtn];
    
}

- (void)applyCustomDesignBtnTouch:(UIButton *)btn{
    NSLog(@"申请定制设计");
}

- (void)backToPreviousViewCon{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareWebView{
    [UMSocialSnsService presentSnsController:self appKey:KUMengKey shareText:self.cases.name shareImage:self.mainView.shareImage shareToSnsNames:@[UMShareToSina,UMShareToQQ,UMShareToWechatSession,UMShareToRenren] delegate:nil];
}



#pragma mark - 下载数据
- (void)downloadData{
    
    //先从数据库取
    [self.alertView show];
    NSString * urlStr=[NSString stringWithFormat:CASE_DETAIL_URL,self.cases.id];
    [self.requestUtil asyncThirdLibWithUrl:urlStr andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    if(statusCode==200 && !error){
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dataDict = dict[@"data"];
        
        self.cases=[Case caseWithDict:dataDict];
        self.mainView.cases=self.cases;
    }else{
        NSLog(@"%@",error);
        UIAlertView * av=[[UIAlertView alloc]initWithTitle:@"数据请求失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }
}
#pragma mark - 懒加载
- (UIAlertView *)alertView{
    if(_alertView==nil){
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"正在加载中..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        alertView.width=50;
        alertView.height=50;
        alertView.center=self.view.center;
        [self.view addSubview:_alertView];
        _alertView=alertView;
    }
    return _alertView;
}
- (RequestUtil *)requestUtil{
    if(_requestUtil==nil){
        _requestUtil=[[RequestUtil alloc]init];
        _requestUtil.delegate=self;
    }
    return _requestUtil;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    [AppDelegate getTabbar].hidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    [AppDelegate getTabbar].hidden=NO;
}



@end
