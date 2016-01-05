//
//  CaseAllViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CaseAllViewController.h"
#import "CaseDetailViewController.h"
#import "CustomDropDownListView.h"
#import "CaseAllMainView.h"
#import "TFilterTypeList.h"
#import "Case.h"

@interface CaseAllViewController ()<RequestUtilDelegate,CustomDropDownListViewDelegate,CaseAllMainViewDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,strong)RequestUtil * requestUtil;

@property(nonatomic,weak) CaseAllMainView * mainView;
//家装
@property(nonatomic,strong)CasesHome * casesHome;
@property(nonatomic,strong)NSMutableArray * homeArray;
@property(nonatomic,weak)UIView * homeHeaderView;


//工装
@property(nonatomic,strong)CasesPublic * casesPublic;
@property(nonatomic,strong)NSMutableArray * pubArray;
@property(nonatomic,weak)UIView * publicHeaderView;

//按钮集合
@property(nonatomic,strong)NSMutableArray * btnArray;
@property(nonatomic,strong)NSMutableArray * dropListViewArray;
@property(nonatomic,strong)NSMutableArray * expandArray;
@property(nonatomic,strong)NSMutableArray * indexArray;


@property(nonatomic,assign)BOOL isSelectedPublic;

@end

@implementation CaseAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [self loadMainView];
    [self loadNavigationBar];
    [self downloadData];
}

#pragma mark - 初始化
- (void)loadMainView{
    CaseAllMainView * mainView=[[CaseAllMainView alloc]initWithFrame:CGRectMake(0, 64+44, WIDTH, HEIGHT-108)];
    mainView.mainViewDelegate=self;
    self.mainView=mainView;
    [self.view addSubview:mainView];
    
    CGFloat homeW=WIDTH/3;
    CGFloat homeH=44;
    UIView * homeHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 44)];
    homeHeadView.backgroundColor=[UIColor whiteColor];
    self.homeHeaderView=homeHeadView;
    [self.view addSubview:homeHeadView];
    
    
    CGFloat publicW=WIDTH/2;
    CGFloat publicH=44;
    UIView * publicHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 44)];
    publicHeadView.backgroundColor=[UIColor whiteColor];
    self.publicHeaderView=publicHeadView;
    publicHeadView.hidden=YES;
    [self.view addSubview:publicHeadView];
    
    NSArray * frameArray=@[NSStringFromCGRect(CGRectMake(0, 0, homeW, homeH)),NSStringFromCGRect(CGRectMake(homeW, 0, homeW, homeH)),NSStringFromCGRect(CGRectMake(homeW*2, 0, homeW, homeH)),NSStringFromCGRect(CGRectMake(0, 0, publicW, publicH)),NSStringFromCGRect(CGRectMake(publicW, 0, publicW, publicH))];
    
    NSArray * titleArray=@[self.casesHome.style,self.casesHome.type,self.casesHome.area,self.casesPublic.type,self.casesHome.area];
    
    for(int i=0;i<5;i++){
        CGRect frame=CGRectFromString(frameArray[i]);
        NSArray * dataArray=titleArray[i];
        Filter * filter=dataArray [0];
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i;
        [self.btnArray addObject:btn];
        
        NSMutableArray * tmpArr=[NSMutableArray new];
        for (Filter * filter in dataArray) {
            [tmpArr addObject:filter.name];
        }
        CustomDropDownListView * view = [CustomDropDownListView dropDownListViewWithDataArray:tmpArr andFrame:CGRectMake(0, 108,WIDTH, 300)];
        [self.view addSubview:view];
        [self.dropListViewArray addObject:view];
        view.mainViewDelegate=self;
        [view setBtnStyle:btn andTitle:filter.name andFrame:frame];
        [btn addTarget:self action:@selector(headerBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.expandArray addObject:@(0)];
        [self.indexArray addObject:@(0)];
        if(i<3){
            [homeHeadView addSubview:btn];
        }else{
            [publicHeadView addSubview:btn];
        }
    }
}

- (void)loadNavigationBar{
    UIBarButtonItem * bbil=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPrevious)];
    self.navigationItem.leftBarButtonItem=bbil;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    UISegmentedControl * seg=[[UISegmentedControl alloc]initWithItems:@[@"家装",@"工装"]];
    seg.frame=CGRectMake(0, 35, 120, 29);
    seg.selectedSegmentIndex=0;
    self.navigationItem.titleView=seg;
    seg.layer.borderColor = [UIColor whiteColor].CGColor;
    
    seg.layer.borderWidth = 2;
    seg.tintColor = [UIColor colorWithRed:0.852 green:0.000 blue:0.009 alpha:1.000];
    seg.backgroundColor = [UIColor lightGrayColor];
    
    NSDictionary *dic =@{NSForegroundColorAttributeName:[UIColor blackColor]};
    
    [seg setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    NSDictionary *dict =@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [seg setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    seg.layer.cornerRadius = 15;
    seg.layer.masksToBounds = YES;
    [seg addTarget:self action:@selector(segTouch:) forControlEvents:UIControlEventValueChanged];
}
- (void)segTouch:(UISegmentedControl *)seg{
    for (UIButton * btn in self.btnArray) {
        btn.selected=NO;
    }
    for (UIView * view in self.dropListViewArray) {
        view.hidden=YES;
    }
    if(seg.selectedSegmentIndex==0){
        self.homeHeaderView.hidden=NO;
        self.publicHeaderView.hidden=YES;
        self.isSelectedPublic=NO;
        if(self.homeArray.count){
            self.mainView.casesArray=self.homeArray;
            self.mainView.page=self.homeArray.count/10;
        }else{
            self.mainView.page=0;
            [self downloadData];
        }
    }else{
        self.homeHeaderView.hidden=YES;
        self.publicHeaderView.hidden=NO;
        self.isSelectedPublic=YES;
        if(self.pubArray.count){
            self.mainView.casesArray=self.pubArray;
            self.mainView.page=self.pubArray.count/10;
        }else{
            self.mainView.page=0;
            [self downloadData];
        }
    }
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

#pragma mark - mainView代理
- (void)itemSelectedWithMainView:(CaseAllMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    CaseDetailViewController * con=[[CaseDetailViewController alloc]init];
    [self.navigationController pushViewController:con animated:YES];
    if(self.isSelectedPublic){
        con.cases=self.pubArray[indexPath.row];
    }else{
        con.cases=self.homeArray[indexPath.row];
    }
}

- (void)refreshWithMainView:(CaseAllMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView{
    if(baseView==mainView.mj_header){
        if(self.isSelectedPublic){
            self.pubArray=nil;
        }else{
            self.homeArray=nil;
        }
    }
    [self downloadData];
}


#pragma mark - 下拉列表每一项点击事件
- (void)itemSelectedWithMainView:(CustomDropDownListView *)mainView andIndexPath:(NSIndexPath *)indexPath andBtn:(UIButton *)btn{
    [self headerBtnTouch:btn];
    self.mainView.page=0;
    NSInteger index = [self.btnArray indexOfObject:btn];
    self.indexArray[index]=@(indexPath.item);
    if(index<3){
        self.homeArray=nil;
    }else{
        self.pubArray=nil;
    }
    [self downloadData];
}

#pragma mark - 下载数据
- (void)downloadData{
    [self.alertView show];
    //先从数据库取
    NSString * urlString;
    if(self.isSelectedPublic){
        Filter * filter1=self.casesPublic.type[[self.indexArray[3] integerValue]];
        Filter * filter2=self.casesPublic.area[[self.indexArray[4] integerValue]];
        urlString=[NSString stringWithFormat:CASE_ALL_PUBLIC_URL,self.mainView.page+1,filter1.Id,filter2.Id];
    }else{
        ;
        Filter * filter1=self.casesHome.style[[self.indexArray[0] integerValue]];
        Filter * filter2=self.casesHome.type[[self.indexArray[1] integerValue]];
        Filter * filter3=self.casesHome.area[[self.indexArray[2] integerValue]];
        urlString=[NSString stringWithFormat:CASE_ALL_HOME_URL,self.mainView.page+1,filter1.Id,filter2.Id,filter3.Id];
    }
    [self.requestUtil asyncThirdLibWithUrl:urlString andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    if(statusCode==200 && !error){
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray * fashionUserArray = dict[@"data"];
        if(self.isSelectedPublic){
            for (NSDictionary * dict in fashionUserArray) {
                [self.pubArray addObject:[Case caseWithDict:dict]];
            }
            self.mainView.casesArray=self.pubArray;
        }else{
            for (NSDictionary * dict in fashionUserArray) {
                [self.homeArray addObject:[Case caseWithDict:dict]];
            }
            self.mainView.casesArray=self.homeArray;
        }
        
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

- (CasesHome *)casesHome{
    if(_casesHome==nil){
        _casesHome=[TFilterTypeList sharedTFilterTypeList].casesHome;
    }
    return _casesHome;
}

- (CasesPublic *)casesPublic{
    if(_casesPublic==nil){
        _casesPublic=[TFilterTypeList sharedTFilterTypeList].casesPublic;
    }
    return _casesPublic;
}

- (NSMutableArray *)homeArray{
    if(_homeArray==nil){
        _homeArray=[[NSMutableArray alloc]init];
    }
    return _homeArray;
}

- (NSMutableArray *)pubArray{
    if (_pubArray==nil) {
        _pubArray=[[NSMutableArray alloc]init];
    }
    return _pubArray;
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
