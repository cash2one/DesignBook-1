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

@interface QueAndAnsViewController ()<RequestUtilDelegate,QueAndAnsMainViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,weak)QueAndAnsMainView * mainView;

@property(nonatomic,strong)RequestUtil * requestUtil;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)NSMutableArray * activeArray;

@property(nonatomic,strong)NSMutableArray * newArray;

@property(nonatomic,strong)NSMutableArray * waitArray;

@property(nonatomic,strong)NSArray * askTypeArray;

@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,weak) UIView * navView;

@property(nonatomic,assign)UISwipeGestureRecognizerDirection direction;

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
    QueAndAnsMainView * mainView=[[QueAndAnsMainView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49)];
    mainView.mainViewDelegate=self;
    [self.view addSubview:mainView];
    self.mainView=mainView;
//    UISwipeGestureRecognizer * sgr1=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(mainViewSgr:)];
//    sgr1.delegate=self;
//    sgr1.direction=UISwipeGestureRecognizerDirectionDown;
//    
//    [mainView addGestureRecognizer:sgr1];
//    
//    UISwipeGestureRecognizer * sgr2=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(mainViewSgr:)];
//    sgr2.delegate=self;
//    sgr2.direction=UISwipeGestureRecognizerDirectionUp;
//    
//    [mainView addGestureRecognizer:sgr2];
    UIPanGestureRecognizer * pgr=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(mainViewPgr:)];
    pgr.delegate=self;
    [mainView addGestureRecognizer:pgr];
}

- (void)mainViewSgr:(UISwipeGestureRecognizer *)sgr{
    self.direction=sgr.direction;
}

- (void)mainViewPgr:(UIPanGestureRecognizer *)pgr{
    static CGPoint oldPoint;
    static CGPoint changePoint;
    if (pgr.state==UIGestureRecognizerStateChanged){
        changePoint=[pgr translationInView:pgr.view];
        if(changePoint.y>oldPoint.y){
            self.direction=UISwipeGestureRecognizerDirectionDown;
        }else{
            self.direction=UISwipeGestureRecognizerDirectionUp;
        }
        oldPoint=changePoint;
    }else if (pgr.state==UIGestureRecognizerStateEnded) {
        oldPoint=CGPointZero;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    CGPoint newPoint = [change[@"new"] CGPointValue];
    CGPoint oldPoint = [change[@"old"] CGPointValue];
    if(newPoint.y>90 && newPoint.y<102 && self.direction==UISwipeGestureRecognizerDirectionUp){
        self.navView.hidden=NO;
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
        self.mainView.frame=CGRectMake(0, 64, WIDTH, HEIGHT-64-49);
        if(newPoint.y==oldPoint.y){
            newPoint.y+=64;
            self.mainView.contentOffset=newPoint;
        }
    }else if(newPoint.y>173 && newPoint.y<180 &&  self.direction==UISwipeGestureRecognizerDirectionDown){
        self.navView.hidden=YES;
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
        self.mainView.frame=CGRectMake(0, 0, WIDTH, HEIGHT-49);
        if(newPoint.y==oldPoint.y){
            newPoint.y-=64;
            self.mainView.contentOffset=newPoint;
        }
    }
}

- (void)loadNavigationBar{
    
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    view.backgroundColor=[UIColor whiteColor];
    view.hidden=YES;
    view.layer.borderWidth=1.f;
    view.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    label.text=@"问答";
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:20];
    label.textAlignment=NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIButton * wangBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wangBtn.backgroundColor=[UIColor colorWithRed:0.87f green:0.19f blue:0.19f alpha:1.00f];
    [wangBtn setTitle:@"提问" forState:UIControlStateNormal];
    [wangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wangBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    wangBtn.frame=CGRectMake(WIDTH-66, 28, 50, 28);
    wangBtn.layer.masksToBounds=YES;
    wangBtn.layer.cornerRadius=3.f;
    [view addSubview:wangBtn];
    [self.view addSubview:view];
    self.navView=view;
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
    self.navView.hidden=YES;
    self.mainView.frame=CGRectMake(0, 0, WIDTH, HEIGHT-49);
    self.mainView.contentOffset=CGPointMake(0, 0);
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
#pragma mark - 手势协议方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[QueAndAnsMainView class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer.view isKindOfClass:[QueAndAnsMainView class]]) {
        return YES;
    }
    return NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [self.mainView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.mainView removeObserver:self forKeyPath:@"contentOffset" context:nil];
}
@end
