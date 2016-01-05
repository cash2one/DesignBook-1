//
//  CaseViewController.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CaseViewController.h"
#import "CaseScrollViewController.h"
#import "CaseDetailViewController.h"
#import "CaseAllViewController.h"
#import "CaseMainView.h"
#import "Parsing.h"
#import "Case.h"
#import "Banner.h"

@interface CaseViewController ()<RequestUtilDelegate,CaseMainViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,strong)RequestUtil * requestUtil;

@property(nonatomic,weak)CaseMainView * mainView;

@property(nonatomic,strong)NSMutableArray * jiexiArray;
@property(nonatomic,strong)NSMutableArray * casesArray;
@property(nonatomic,strong)NSMutableArray * bannerArray;

@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [self loadMainView];
    [self downloadData];
    [self loadNavigationBar];
}

#pragma mark - 初始加载
- (void)loadMainView{
    CaseMainView * mainView=[[CaseMainView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    [self.view addSubview:mainView];
    mainView.mainViewDelegate=self;
    self.mainView=mainView;
    UISwipeGestureRecognizer * sgr1=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(sgr:)];
    sgr1.delegate=self;
    sgr1.direction=UISwipeGestureRecognizerDirectionDown;
    [mainView addGestureRecognizer:sgr1];
    
    UISwipeGestureRecognizer * sgr2=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(sgr:)];
    sgr2.delegate=self;
    sgr2.direction=UISwipeGestureRecognizerDirectionUp;
    [mainView addGestureRecognizer:sgr2];
}

- (void)loadNavigationBar{
    UIBarButtonItem * bbir=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_case_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem=bbir;
    
    UIImageView * imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AppIcon40x40"]];
    imageView.frame = CGRectMake(8, 20, 44, 44);
    UIBarButtonItem * bbil=[[UIBarButtonItem alloc]initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItem=bbil;
    
}



- (void)sgr:(UISwipeGestureRecognizer *)sgr{
    if(sgr.direction==UISwipeGestureRecognizerDirectionUp){
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBarHidden=YES;
            [AppDelegate getTabbar].hidden=YES;
            self.mainView.y=0;
            self.mainView.height=HEIGHT;
        }];
    }else if(sgr.direction==UISwipeGestureRecognizerDirectionDown){
        [AppDelegate getTabbar].hidden=NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBarHidden=NO;
            self.mainView.y=64;
            self.mainView.height=HEIGHT-64-49;
        }];
    }
}



#pragma mark - mainView代理
- (void)itemSelectedWithMainView:(CaseMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    CaseDetailViewController * con=[[CaseDetailViewController alloc]init];
    [self.navigationController pushViewController:con animated:YES];
    con.cases=self.casesArray[indexPath.row];
}

- (void)seeAllCasesWithMainView:(CaseMainView *)mainView{
    [self.navigationController pushViewController:[CaseAllViewController new] animated:YES];
}

- (void)refreshWithMainView:(CaseMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView{
    if(baseView==mainView.mj_header){
        [SQLiteManager deleteWithTableName:@"cases" andClass:nil andParams:nil];
        [SQLiteManager deleteWithTableName:nil andClass:[Parsing class] andParams:nil];
        [SQLiteManager deleteWithTableName:nil andClass:[Banner class] andParams:nil];
        [self downloadData];
    }
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

#pragma mark - 下载数据
- (void)downloadData{
    NSArray * caseArray = [SQLiteManager queryAllWithTableName:@"cases" andClass:[Case class]];
    NSArray * parsingArray = [SQLiteManager queryAllWithTableName:nil andClass:[Parsing class]];
    NSArray * bannerArray = [SQLiteManager queryAllWithTableName:nil andClass:[Banner class]];
    if(parsingArray.count&&bannerArray.count){
        self.casesArray=(NSMutableArray *)caseArray;
        self.jiexiArray=(NSMutableArray *)parsingArray;
        self.bannerArray=(NSMutableArray *)bannerArray;
        self.mainView.jiexiArray=self.jiexiArray;
        self.mainView.bannerArray=self.bannerArray;
        self.mainView.casesArray=self.casesArray;
        return;
    }
    
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
                Parsing * p=[Parsing parsingWithDict:dict];
                [SQLiteManager insertToTableName:nil andObject:p];
                [self.jiexiArray addObject:p];
            }
        }
        if(dataDict[@"cases"]){
            for (NSDictionary * dict in dataDict[@"cases"]) {
                Case * cases =[Case caseWithDict:dict];
                [cases saveSelf];
                [self.casesArray addObject:cases];
            }
        }
        if(dataDict[@"banner"]){
            for (NSDictionary * dict in dataDict[@"banner"]) {
                Banner * b =[Banner bannerWithDict:dict];
                [b saveSelf];
                [self.bannerArray addObject:b];
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
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.87f green:0.23f blue:0.20f alpha:1.00f];
    [AppDelegate getTabbar].hidden=NO;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
}
#pragma mark - 手势协议方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}
@end
