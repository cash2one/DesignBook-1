//
//  DisSearchDesViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "DisSearchDesViewController.h"
#import "CustomDropDownListView.h"
#import "TFilterTypeList.h"

@interface DisSearchDesViewController ()<RequestUtilDelegate,CustomDropDownListViewDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,strong)RequestUtil * requestUtil;

@property(nonatomic,weak)UIView * headerView;

@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)FindDesigner * findDesigner;


//按钮集合
@property(nonatomic,strong)NSMutableArray * btnArray;
@property(nonatomic,strong)NSMutableArray * dropListViewArray;
@property(nonatomic,strong)NSMutableArray * expandArray;
@property(nonatomic,strong)NSMutableArray * indexArray;

@end

@implementation DisSearchDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigationBar];
    [self loadMainView];
}

#pragma mark - 初始化
- (void)loadMainView{
//    CaseAllMainView * mainView=[[CaseAllMainView alloc]initWithFrame:CGRectMake(0, 64+44, WIDTH, HEIGHT-108)];
//    mainView.mainViewDelegate=self;
//    self.mainView=mainView;
//    [self.view addSubview:mainView];
    
    CGFloat homeW=WIDTH/3;
    CGFloat homeH=44;
    UIView * homeHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 44)];
    homeHeadView.backgroundColor=[UIColor whiteColor];
    self.headerView=homeHeadView;
    [self.view addSubview:homeHeadView];
    
    NSArray * frameArray=@[NSStringFromCGRect(CGRectMake(0, 0, homeW, homeH)),NSStringFromCGRect(CGRectMake(homeW, 0, homeW, homeH)),NSStringFromCGRect(CGRectMake(homeW*2, 0, homeW, homeH))];
    
    NSArray * titleArray=@[self.findDesigner.hotCity,self.findDesigner.space,self.findDesigner.order];
    
    for(int i=0;i<titleArray.count;i++){
        CGRect frame=CGRectFromString(frameArray[i]);
        NSArray * dataArray=titleArray[i];
        NSString * title;
        if(i==2){
            Filter * filter=dataArray [0];
            title=filter.name;
            NSMutableArray * tmp=[NSMutableArray new];
            for (Filter * filter in dataArray) {
                [tmp addObject:filter.name];
            }
            dataArray=tmp;
        }else{
            title=dataArray[0];
        }
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i;
        [self.btnArray addObject:btn];
        
        CustomDropDownListView * view = [CustomDropDownListView dropDownListViewWithDataArray:dataArray andFrame:CGRectMake(0, 108,WIDTH, 300)];
        [self.view addSubview:view];
        [self.dropListViewArray addObject:view];
        view.mainViewDelegate=self;
        [view setBtnStyle:btn andTitle:title andFrame:frame];
        [btn addTarget:self action:@selector(headerBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.expandArray addObject:@(0)];
        [self.indexArray addObject:@(0)];
        [homeHeadView addSubview:btn];
    }
}

- (void)loadNavigationBar{
    UIBarButtonItem * bbil=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPrevious)];
    self.navigationItem.leftBarButtonItem=bbil;
}

- (void)backToPrevious{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headerBtnTouch:(UIButton *)btn{
    for (int i=0; i<self.btnArray.count; i++) {
        UIButton * currentBtn=self.btnArray[i];
        CustomDropDownListView *view=self.dropListViewArray[i];
        if(btn==currentBtn && [self.expandArray[i] isEqual:@(0)]){
            self.expandArray[i]=@(1);
            currentBtn.selected=YES;
            view.hidden=NO;
        }else{
            self.expandArray[i]=@(0);
            currentBtn.selected=NO;
            view.hidden=YES;
        }
    }
}


#pragma mark - 下拉列表每一项点击事件
- (void)itemSelectedWithMainView:(CustomDropDownListView *)mainView andIndexPath:(NSIndexPath *)indexPath andBtn:(UIButton *)btn{
    [self headerBtnTouch:btn];
//    self.mainView.page=0;
    NSInteger index = [self.btnArray indexOfObject:btn];
    self.indexArray[index]=@(indexPath.item);
    self.dataArray=nil;
    [self downloadData];
}

#pragma mark - 下载数据
- (void)downloadData{
//    [self.alertView show];
    //先从数据库取
//    NSString * urlString;
//    [self.requestUtil asyncThirdLibWithUrl:urlString andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    if(statusCode==200 && !error){
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray * dataArray = dict[@"data"];
        NSLog(@"%@",dataArray);
        
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

-(NSMutableArray *)dataArray{
    if(_dataArray==nil){
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (FindDesigner *)findDesigner{
    if(_findDesigner==nil){
        _findDesigner=[TFilterTypeList sharedTFilterTypeList].findDesigner;
    }
    return _findDesigner;
}

- (NSMutableArray *)btnArray{
    if(_btnArray==nil){
        _btnArray=[NSMutableArray new];
    }
    return _btnArray;
}

- (NSMutableArray *)dropListViewArray{
    if(_dropListViewArray==nil){
        _dropListViewArray=[NSMutableArray new];
    }
    return _dropListViewArray;
}

- (NSMutableArray *)expandArray{
    if (_expandArray==nil) {
        _expandArray=[NSMutableArray new];
    }
    return _expandArray;
}

- (NSMutableArray *)indexArray{
    if(_indexArray==nil){
        _indexArray=[NSMutableArray new];
    }
    return _indexArray;
}
#pragma mark - 系统协议方法
- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden=NO;
    [AppDelegate getTabbar].hidden=YES;
}
@end
