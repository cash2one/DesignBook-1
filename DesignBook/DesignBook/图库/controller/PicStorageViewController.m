//
//  PicStorageViewController.m
//  DesignBook
//
//  Created by 陈行 on 15-12-31.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "PicStorageViewController.h"
#import "PictureDetailViewController.h"
#import "UIButton+RefreshLocation.h"
#import "CustomDropDownListView.h"
#import "PicStorageMainView.h"
#import "TFilterTypeList.h"
#import "ImageInfo.h"


@interface PicStorageViewController ()<RequestUtilDelegate,CustomDropDownListViewDelegate,PicStorageMainViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,strong)RequestUtil * requestUtil;

//@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,weak)PicStorageMainView * mainView;

//家装
@property(nonatomic,strong)WorksHome * worksHome;
@property(nonatomic,assign)NSInteger homeSpaceIndex;
@property(nonatomic,assign)NSInteger homeStyleIndex;

//工装
@property(nonatomic,strong)WorksPublic * worksPublic;
@property(nonatomic,assign)NSInteger publicSpaceIndex;

@property(nonatomic,strong)NSMutableArray * homeArray;

@property(nonatomic,strong)NSMutableArray * pubArray;

@property(nonatomic,weak)UIView * homeHeaderView;

@property(nonatomic,strong)NSArray * btnArray;
@property(nonatomic,strong)NSArray * dropListViewArray;
@property(nonatomic,strong)NSMutableArray * expandArray;

@property(nonatomic,assign)BOOL isSelectedPublic;

@end

@implementation PicStorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self loadMainView];
    [self downloadData];
    [self loadNavigationBar];
}

#pragma mark - 初始化
- (void)loadMainView{
    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc]init];
    PicStorageMainView * mainView=[[PicStorageMainView alloc]initWithFrame:CGRectMake(0, 108, WIDTH, HEIGHT-108-49) collectionViewLayout:layout];
    mainView.mainViewDelegate=self;
    self.mainView=mainView;
    [self.view addSubview:mainView];
    UISwipeGestureRecognizer * sgr1=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(sgr:)];
    sgr1.delegate=self;
    sgr1.direction=UISwipeGestureRecognizerDirectionDown;
    [mainView addGestureRecognizer:sgr1];
    
    UISwipeGestureRecognizer * sgr2=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(sgr:)];
    sgr2.delegate=self;
    sgr2.direction=UISwipeGestureRecognizerDirectionUp;

    
    UIView * homeHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 44)];
    homeHeadView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:homeHeadView];
    
    Filter * hSpaceFilter = self.worksHome.space[0];
    UIButton * hSpaceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    hSpaceBtn.tag=0;
    [homeHeadView addSubview:hSpaceBtn];
    
    Filter * hStyleFilter = self.worksHome.style[0];
    UIButton * hStyleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    hStyleBtn.tag=1;
    [homeHeadView addSubview:hStyleBtn];
    
    Filter * pSpaceFilter = self.worksPublic.space[0];
    UIButton * pSpaceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    pSpaceBtn.tag=2;
    pSpaceBtn.hidden=YES;
    
    NSMutableArray * arr1=[NSMutableArray new];
    
    for (Filter * filter in self.worksHome.space) {
        [arr1 addObject:filter.name];
    }
    
    NSMutableArray * arr2=[NSMutableArray new];
    
    for (Filter * filter in self.worksHome.style) {
        [arr2 addObject:filter.name];
    }
    
    NSMutableArray * arr3=[NSMutableArray new];
    
    for (Filter * filter in self.worksPublic.space) {
        [arr3 addObject:filter.name];
    }
    
    CustomDropDownListView * view1 = [CustomDropDownListView dropDownListViewWithDataArray:arr1 andFrame:CGRectMake(0, 108,WIDTH, 300)];
    view1.mainViewDelegate=self;
    CustomDropDownListView * view2 = [CustomDropDownListView dropDownListViewWithDataArray:arr2 andFrame:CGRectMake(0, 108,WIDTH, 300)];
    view2.mainViewDelegate=self;
    CustomDropDownListView * view3 = [CustomDropDownListView dropDownListViewWithDataArray:arr3 andFrame:CGRectMake(0, 108,WIDTH,300)];
    view3.mainViewDelegate=self;
    
    
    [view1 setBtnStyle:hSpaceBtn andTitle:hSpaceFilter.name andFrame:CGRectMake(0, 0, WIDTH*0.5, 44)];
    [view2 setBtnStyle:hStyleBtn andTitle:hStyleFilter.name andFrame:CGRectMake(WIDTH*0.5, 0, WIDTH*0.5, 44)];
    [view3 setBtnStyle:pSpaceBtn andTitle:pSpaceFilter.name andFrame:CGRectMake(0, 64, WIDTH, 44)];
    
    [pSpaceBtn addTarget:self action:@selector(headerBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [hSpaceBtn addTarget:self action:@selector(headerBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [hStyleBtn addTarget:self action:@selector(headerBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    [self.view addSubview:homeHeadView];
    [self.view addSubview:pSpaceBtn];
    self.homeHeaderView=homeHeadView;
    self.expandArray=[NSMutableArray arrayWithArray:@[@(0),@(0),@(0)]];
    self.btnArray=@[hSpaceBtn,hStyleBtn,pSpaceBtn];
    self.dropListViewArray=@[view1,view2,view3];
}

- (void)itemSelectedWithMainView:(PicStorageMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    PictureDetailViewController * con=[PictureDetailViewController new];
    [self.navigationController pushViewController:con animated:YES];
    if(self.isSelectedPublic){
        con.dataArray=self.pubArray;
    }else{
        con.dataArray=self.homeArray;
    }
    con.indexPath=indexPath;
}

- (void)refreshWithMainView:(PicStorageMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView{
    if(baseView==mainView.mj_header){
        if(self.isSelectedPublic){
            self.pubArray=nil;
        }else{
            self.homeArray=nil;
        }
    }
    
    [self downloadData];
}

- (void)headerBtnTouch:(UIButton *)btn{
    for (int i=0; i<self.expandArray.count; i++) {
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
    self.mainView.page=0;
    if(btn.tag==0){
        self.homeArray=nil;
        self.homeSpaceIndex=indexPath.item;
    }else if(btn.tag==1){
        self.homeArray=nil;
        self.homeStyleIndex=indexPath.item;
    }else{
        self.pubArray=nil;
        self.publicSpaceIndex=indexPath.item;
    }
    [self downloadData];
}

- (void)loadNavigationBar{
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
        [self.btnArray[2] setHidden:YES];
        self.isSelectedPublic=NO;
        if(self.homeArray.count){
            self.mainView.dataArray=self.homeArray;
            self.mainView.page=self.homeArray.count/20;
        }else{
            self.mainView.page=0;
            [self downloadData];
        }
    }else{
        self.homeHeaderView.hidden=YES;
        [self.btnArray[2] setHidden:NO];
        self.isSelectedPublic=YES;
        if(self.pubArray.count){
            self.mainView.dataArray=self.pubArray;
            self.mainView.page=self.pubArray.count/20;
        }else{
            self.mainView.page=0;
            [self downloadData];
        }
    }
}

#pragma mark - 下载数据
- (void)downloadData{
    [self.alertView show];
    //先从数据库取
    NSString * urlString;
    if(self.isSelectedPublic){
        Filter * filter=self.worksPublic.space[self.publicSpaceIndex];
        
        urlString=[NSString stringWithFormat:PIC_PUBLIC_LIST_URL,self.mainView.page+1,filter.Id];
    }else{
        Filter * filter1=self.worksHome.space[self.homeSpaceIndex];
        Filter * filter2=self.worksHome.style[self.homeStyleIndex];
        urlString=[NSString stringWithFormat:PIC_HOME_LIST_URL,self.mainView.page+1,filter1.Id,filter2.Id];
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
                [self.pubArray addObject:[ImageInfo imageInfoWithDict:dict]];
            }
            self.mainView.dataArray=self.pubArray;
        }else{
            for (NSDictionary * dict in fashionUserArray) {
                ImageInfo * info =[ImageInfo imageInfoWithDict:dict];
                [self.homeArray addObject:info];
            }
            self.mainView.dataArray=self.homeArray;
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

- (WorksHome *)worksHome{
    if(_worksHome==nil){
        _worksHome=[TFilterTypeList sharedTFilterTypeList].worksHome;
    }
    return _worksHome;
}

- (WorksPublic *)worksPublic{
    if(_worksPublic==nil){
        _worksPublic=[TFilterTypeList sharedTFilterTypeList].worksPublic;
    }
    return _worksPublic;
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
#pragma mark - 手势协议方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UICollectionView class]]) {
        return YES;
    }
    return NO;
}
- (void)sgr:(UISwipeGestureRecognizer *)sgr{
    if(sgr.direction==UISwipeGestureRecognizerDirectionUp){
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBarHidden=YES;
            [AppDelegate getTabbar].hidden=YES;
            self.homeHeaderView.hidden=YES;
            [self.btnArray[2] setHidden:YES];
            self.mainView.y=0;
            self.mainView.height=HEIGHT;
        }];
    }else if(sgr.direction==UISwipeGestureRecognizerDirectionDown){
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBarHidden=NO;
            [AppDelegate getTabbar].hidden=NO;
            self.mainView.y=64+44;
            self.mainView.height=HEIGHT-64-49-44;
            if(self.isSelectedPublic){
                [self.btnArray[2] setHidden:NO];
            }else{
                self.homeHeaderView.hidden=NO;
            }
        }];
    }
}
#pragma mark - 系统协议方法
- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden=NO;
    [AppDelegate getTabbar].hidden=NO;
}
@end
