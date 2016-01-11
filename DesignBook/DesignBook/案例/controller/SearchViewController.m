//
//  SearchViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-9.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "SearchViewController.h"
#import "CaseDetailViewController.h"
#import "PictureDetailViewController.h"
#import "QueAnsDetailViewController.h"
#import "MemberViewController.h"
#import "SearchMainView.h"
#import "CustomSearchView.h"
#import "Case.h"
#import "ImageInfo.h"
#import "QueAndAns.h"
#import "MemberInfo.h"

@interface SearchViewController ()<CustomSearchViewDelegate,RequestUtilDelegate,SearchMainViewDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,strong)RequestUtil * requestUtil;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)NSArray * actionArray;

@property(nonatomic,copy)NSString * searchText;

@property(nonatomic,weak)SearchMainView * mainView;

@end

@implementation SearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self loadMainView];
    [self loadSearchView];
}

#pragma mark - 初始加载
- (void)loadSearchView{
    CustomSearchView * searchView=[[CustomSearchView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 400)];
    searchView.delegate=self;
    [self.view addSubview:searchView];
}

- (void)loadMainView{
    SearchMainView * mainView=[[SearchMainView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    mainView.delegate=self;
    self.mainView=mainView;
    [self.view addSubview:mainView];
}

- (void)searchMainView:(SearchMainView *)mainView andSliderBtnIndex:(NSInteger)index{
    NSInteger count = [self.dataArray[index] count];
    if(count>0){
        self.mainView.dataArray=self.dataArray;
        return;
    }
    [self downloadData];
}

- (void)refreshWithMainView:(SearchMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView  andScrollView:(UIScrollView *)scrollView{
    if(scrollView.mj_header == baseView){
        self.dataArray[self.mainView.currentSliderIndex]=[NSMutableArray new];
    }
    [self downloadData];
}

- (void)itemSelectedWithMainView:(SearchMainView *)mainView andIndexPath:(NSIndexPath *)indexPath andCurrentBtnIndex:(NSInteger)index{
    if(index==0){
        CaseDetailViewController * con=[CaseDetailViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.cases=self.dataArray[index][indexPath.row];
    }else if (index==1){
        PictureDetailViewController * con=[PictureDetailViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.dataArray=self.dataArray[index];
        con.indexPath=indexPath;
    }else if (index==2){
        QueAnsDetailViewController * con=[QueAnsDetailViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.queAndAns=self.dataArray[index][indexPath.row];
    }else if (index==3){
        MemberViewController * con=[MemberViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.memberInfo=self.dataArray[index][indexPath.row];
    }
}

#pragma mark - 下载数据
- (void)downloadData{
    
    [self.alertView show];
    
    NSString * urlString = [self.searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * urlStr=[NSString stringWithFormat:SEARCH_LIST_URL,self.actionArray[self.mainView.currentSliderIndex],urlString,1l];
    
    [self.requestUtil asyncThirdLibWithUrl:urlStr andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    if(statusCode==200 && !error){
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray * dataArray = dict[@"data"];
        for (NSDictionary * tmpDict in dataArray) {
            NSObject * obj;
            if(self.mainView.currentSliderIndex==0){
                obj=[Case caseWithDict:tmpDict];
            }else if (self.mainView.currentSliderIndex==1){
                obj=[ImageInfo imageInfoWithDict:tmpDict];
            }else if (self.mainView.currentSliderIndex==2){
                obj=[QueAndAns queAndAnsWithDict:tmpDict];
            }else{
                obj=[MemberInfo memberInfoWithDict:tmpDict];
            }
            [self.dataArray[self.mainView.currentSliderIndex] addObject:obj];
        }
        self.mainView.dataArray=self.dataArray;
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

- (NSMutableArray *)dataArray{
    if(_dataArray==nil){
        _dataArray=[NSMutableArray new];
        [_dataArray addObject:[NSMutableArray new]];
        [_dataArray addObject:[NSMutableArray new]];
        [_dataArray addObject:[NSMutableArray new]];
        [_dataArray addObject:[NSMutableArray new]];
    }
    return _dataArray;
}

- (NSArray *)actionArray{
    if(_actionArray==nil){
        _actionArray=@[@"cases",@"images",@"ask", @"designer"];
    }
    return _actionArray;
}

#pragma mark - CustomSearchView协议事件
- (void)customSearchBar:(CustomSearchView *)searchView andCancleBtn:(UIButton *)cancleBtn{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)customSearchBar:(CustomSearchView *)searchView andSearchValue:(NSString *)searchValue{
    self.searchText=searchValue;
    [self downloadData];
}

#pragma mark - 系统协议方法
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    [AppDelegate getTabbar].hidden=YES;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
}

@end
