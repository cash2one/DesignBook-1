//
//  PicCollectionViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-8.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "PicCollectionViewController.h"
#import "PictureDetailViewController.h"
#import "PicCollectionMainView.h"
#import "ImageInfo.h"

@interface PicCollectionViewController ()<RequestUtilDelegate,PicStorageMainViewDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,weak)PicCollectionMainView * mainView;

@property(nonatomic,strong)RequestUtil * requestUtil;

@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation PicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainView];
    [self loadNavigationBar];
    [self downloadData];
}
#pragma mark - 初始化
- (void)loadMainView{
    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc]init];
    PicCollectionMainView * mainView=[[PicCollectionMainView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) collectionViewLayout:layout];
    mainView.mainViewDelegate=self;
    self.mainView=mainView;
    [self.view addSubview:mainView];
}
- (void)loadNavigationBar{
    UIBarButtonItem * bbil=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousViewCon)];
    self.navigationItem.leftBarButtonItem=bbil;
    
    
    
    self.navigationItem.title=self.pictureCol.name;
}

- (void)backToPreviousViewCon{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)itemSelectedWithMainView:(PicCollectionMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    PictureDetailViewController * con=[PictureDetailViewController new];
    [self.navigationController pushViewController:con animated:YES];
    con.dataArray=self.dataArray;
    con.indexPath=indexPath;
}

- (void)refreshWithMainView:(PicCollectionMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView{
    if(baseView==mainView.mj_header){
        self.dataArray=nil;
    }
    [self downloadData];
}


#pragma mark - 下载数据
- (void)downloadData{
    [self.alertView show];
    //先从数据库取
    NSString * urlString=[NSString stringWithFormat:PICTURE_COL_URL,self.pictureCol.colId,self.mainView.page+1];
    [self.requestUtil asyncThirdLibWithUrl:SERVER_URL andParameters:[RequestUtil getParamsWithString:urlString] andMethod:RequestMethodPost andTimeoutInterval:10];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    if(statusCode==200 && !error){
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray * dataArray = dict[@"data"];
        for (NSDictionary * dataDict in dataArray) {
            [self.dataArray addObject:[ImageInfo imageInfoWithDict:dataDict]];
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
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    [AppDelegate getTabbar].hidden=YES;
}

@end
