//
//  CaseViewController.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CaseViewController.h"
#import "CaseScrollViewController.h"
#import "CaseMainView.h"
#import "Parsing.h"
#import "Case.h"
#import "Banner.h"

@interface CaseViewController ()<RequestUtilDelegate,CaseMainViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,strong)RequestUtil * requestUtil;

@property(nonatomic,weak)CaseMainView * mainView;

@property(nonatomic,assign)BOOL isHiddenStateBar;

@property(nonatomic,strong)NSMutableArray * jiexiArray;
@property(nonatomic,strong)NSMutableArray * casesArray;
@property(nonatomic,strong)NSMutableArray * bannerArray;

@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self loadMainView];
    [self downloadData];
}

- (void)loadMainView{
    CaseMainView * mainView=[[CaseMainView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    [self.view addSubview:mainView];
    mainView.mainViewDelegate=self;
    self.mainView=mainView;
}

- (void)loadNavigationBar{
    UIBarButtonItem * bbir=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_case_search"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem=bbir;
}

#pragma mark - mainView代理
- (void)itemSelectedWithMainView:(CaseMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中一项%ld",indexPath.row);
}

- (void)seeAllCasesWithMainView:(CaseMainView *)mainView{
    NSLog(@"查看全部案例");
}

- (void)refreshWithMainView:(CaseMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView{
    NSLog(@"刷新");
}

- (void)guidePageViewTouchWithIndex:(NSInteger)index{
    
    Banner * banner = self.bannerArray[index];
    if(banner.Id==0){
        WebViewController * con=[[WebViewController alloc]init];
        [self.navigationController pushViewController:con animated:YES];
        con.requestUrl=[NSString stringWithFormat:@"%@?%@",banner.url,DEVICE_INFO];
        con.isHiddenShare=YES;
    }else{
        CaseScrollViewController * con=[[CaseScrollViewController alloc]init];
        [self.navigationController pushViewController:con animated:YES];
        con.Id=banner.Id;
    }
}

- (void)scrollViewTouchWithIndex:(NSInteger)index{
    Parsing * parsing=self.jiexiArray[index];
    
    CaseScrollViewController * con=[[CaseScrollViewController alloc]init];
    [self.navigationController pushViewController:con animated:YES];
    con.Id=parsing.Id;
}

- (void)caseMainView:(CaseMainView *)mainView andScrollViewIsUp:(BOOL)isUp{
    if(isUp && !self.isHiddenStateBar && self.mainView.contentOffset.y>0){
        self.isHiddenStateBar=YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBarHidden=YES;
            [AppDelegate getTabbar].hidden=YES;
            self.mainView.y=0;
            self.mainView.height=HEIGHT;
        }];
    }else if(!isUp && self.isHiddenStateBar && self.mainView.contentOffset.y>0){
        self.isHiddenStateBar=NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBarHidden=NO;
            [AppDelegate getTabbar].hidden=NO;
            self.mainView.y=64;
            self.mainView.height=HEIGHT-64-49;
        }];
    }
}

#pragma mark - 下载数据
- (void)downloadData{
    
    //先从数据库取
    [self.alertView show];
    NSString * urlStr=CASE_LIST_URL;
    [self.requestUtil asyncThirdLibWithUrl:urlStr andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    if(statusCode==200 && !error){
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dataDict = dict[@"data"];
        
        //存储导数据库
        if(dataDict[@"jiexi"]){
            for (NSDictionary * dict in dataDict[@"jiexi"]) {
                [self.jiexiArray addObject:[Parsing parsingWithDict:dict]];
            }
        }
        if(dataDict[@"cases"]){
            for (NSDictionary * dict in dataDict[@"cases"]) {
                [self.casesArray addObject:[Case caseWithDict:dict]];
            }
        }
        if(dataDict[@"banner"]){
            for (NSDictionary * dict in dataDict[@"banner"]) {
                [self.bannerArray addObject:[Banner bannerWithDict:dict]];
            }
        }
        self.mainView.jiexiArray=self.jiexiArray;
        self.mainView.bannerArray=self.bannerArray;
        self.mainView.casesArray=self.casesArray;
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

- (NSMutableArray *)jiexiArray{
    if(_jiexiArray==nil){
        _jiexiArray=[[NSMutableArray alloc]init];
    }
    return _jiexiArray;
}

- (NSMutableArray *)casesArray{
    if(_casesArray==nil){
        _casesArray=[[NSMutableArray alloc]init];
    }
    return _casesArray;
}

- (NSMutableArray *)bannerArray{
    if(_bannerArray==nil){
        _bannerArray=[[NSMutableArray alloc]init];
    }
    return _bannerArray;
}

#pragma mark - 系统协议方法
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.87f green:0.19f blue:0.19f alpha:1.00f];
    [AppDelegate getTabbar].hidden=NO;
}

- (BOOL)prefersStatusBarHidden{
    return self.isHiddenStateBar;
}

@end
