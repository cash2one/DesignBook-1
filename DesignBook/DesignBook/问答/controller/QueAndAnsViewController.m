//
//  QueAndAnsViewController.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "QueAndAnsViewController.h"
#import "QueAnsDetailViewController.h"
#import "QueAndAnsMainView.h"
#import "QueAndAns.h"

@interface QueAndAnsViewController ()<RequestUtilDelegate,QueAndAnsMainViewDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,weak)QueAndAnsMainView * mainView;

@property(nonatomic,strong)RequestUtil * requestUtil;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)NSMutableArray * activeArray;

@property(nonatomic,strong)NSMutableArray * newArray;

@property(nonatomic,strong)NSMutableArray * waitArray;

@property(nonatomic,strong)NSArray * askTypeArray;

@property(nonatomic,assign)NSInteger currentIndex;

@end

@implementation QueAndAnsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMainView];
    [self loadNavigationBar];
    [self downloadData];
}
#pragma mark - 初始加载
- (void)loadMainView{
    QueAndAnsMainView * mainView=[[QueAndAnsMainView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49) style:UITableViewStyleGrouped];
    mainView.mainViewDelegate=self;
    [self.view addSubview:mainView];
    self.mainView=mainView;

}

- (void)loadNavigationBar{
    self.navigationItem.title=@"问答";
}

- (void)refreshWithMainView:(QueAndAnsMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView{
    if(baseView==mainView.mj_header){
        self.dataArray[self.currentIndex]=[[NSMutableArray alloc]init];
    }
    [self downloadData];
}

- (void)itemSelectedWithMainView:(QueAndAnsMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    QueAnsDetailViewController * con=[QueAnsDetailViewController new];
    [self.navigationController pushViewController:con animated:YES];
    con.queAndAns=[self.dataArray[self.currentIndex] objectAtIndex:indexPath.row];
}

- (void)sliderView:(id)sliderView andIndex:(NSInteger)index andBtnArray:(NSArray *)btnArray{
    self.currentIndex=index;
    if([self.dataArray[index] count]){
        self.mainView.dataArray=self.dataArray[index];
    }else{
        [self downloadData];
    }
}

#pragma mark - 下载数据
- (void)downloadData{
    //先从数据库取
    [self.alertView show];
    NSString * urlStr=[NSString stringWithFormat:QUEANDANS_ACTIVE_URL,self.askTypeArray[self.currentIndex],self.mainView.page+1];
    [self.requestUtil asyncThirdLibWithUrl:urlStr andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    if(statusCode==200 && !error){
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray * dataArray = dict[@"data"];
        
        for (NSDictionary * queAndAnsDict in dataArray) {
            [self.dataArray[self.currentIndex] addObject:[QueAndAns queAndAnsWithDict:queAndAnsDict]];
        }
        self.mainView.dataArray=self.dataArray[self.currentIndex];
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
        _dataArray=[[NSMutableArray alloc]init];
        [_dataArray addObject:self.activeArray];
        [_dataArray addObject:self.newArray];
        [_dataArray addObject:self.waitArray];
    }
    return _dataArray;
}

- (NSMutableArray *)activeArray{
    if(_activeArray == nil){
        _activeArray=[[NSMutableArray alloc]init];
    }
    return _activeArray;
}

- (NSMutableArray *)newArray{
    if(_newArray==nil){
        _newArray=[[NSMutableArray alloc]init];
    }
    return _newArray;
}

- (NSMutableArray *)waitArray{
    if(_waitArray==nil){
        _waitArray=[[NSMutableArray alloc]init];
    }
    return _waitArray;
}

- (NSArray *)askTypeArray{
    return @[@"active",@"new",@"wait"];
}

#pragma mark - 系统协议方法
- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.navigationBarHidden=YES;
    [AppDelegate getTabbar].hidden=NO;
}
@end
