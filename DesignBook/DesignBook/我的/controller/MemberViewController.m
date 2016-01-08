//
//  MemberViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-7.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "MemberViewController.h"
#import "CaseDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MemberMainView.h"
#import "BlogArticle.h"
#import "Case.h"

@interface MemberViewController ()<RequestUtilDelegate,MemberMainViewDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,strong)RequestUtil * requestUtil;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,weak)MemberMainView * mainView;

@property(nonatomic,copy)UIColor * oldNavColor;

@property(nonatomic,assign)UIStatusBarStyle statusBarStyle;

@property(nonatomic,assign)NSInteger sliderCurrentIndex;

@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainView];
    [self loadNavigationBar];
    [self downloadMemInfoData];
    [self downloadListData];
}

#pragma mark - 初始加载
- (void)loadMainView{
    MemberMainView * mainView=[[MemberMainView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    [self.view addSubview:mainView];
    mainView.memberInfo=self.memberInfo;
    mainView.mainViewDelegate=self;
    self.mainView=mainView;
}

- (void)loadNavigationBar{
    self.navigationItem.title=self.memberInfo.nick;
    
    UIBarButtonItem * bbir=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_find_designer_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareWebView)];
    self.navigationItem.rightBarButtonItem=bbir;
    
    UIBarButtonItem * bbil=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousViewCon)];
    self.navigationItem.leftBarButtonItem=bbil;
    
}

- (void)shareWebView{
    UIImageView * imageview=[[UIImageView alloc]init];
    [imageview sd_setImageWithURL:[NSURL URLWithString:self.memberInfo.facePic]];
    NSString * shareText=[NSString stringWithFormat:@"在设计本找到室内设计师%@，作品很不错，推荐给大家%@",self.memberInfo.nick,self.memberInfo.sjsUrl];
    [UMSocialSnsService presentSnsController:self appKey:KUMengKey shareText:shareText shareImage:imageview.image shareToSnsNames:@[UMShareToSina,UMShareToQQ,UMShareToWechatSession,UMShareToRenren] delegate:nil];
}

- (void)backToPreviousViewCon{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - mainView代理
- (void)itemSelectedWithMainView:(MemberMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    if(self.sliderCurrentIndex==0){
        CaseDetailViewController * con=[CaseDetailViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.cases=[self.dataArray[0] objectAtIndex:indexPath.row];
    }
}

- (void)sliderView:(CustomSliderView *)sliderView andIndex:(NSInteger)index andBtnArray:(NSArray *)btnArray{
    self.sliderCurrentIndex=index;
    [self downloadListData];
}

- (void)refreshWithMainView:(MemberMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView{
    [self downloadListData];
}

- (void)onlineBtnTouch:(UIButton *)btn{
    NSLog(@"在线预约");
}


#pragma mark - 下载数据

- (void)downloadMemInfoData{
    //先从数据库取
    NSString * param=[NSString stringWithFormat:MEMBERINFO_DETAIL_URL,self.memberInfo.uid];
    
    [self.requestUtil asyncThirdLibWithUrl:SERVER_URL andParameters:[RequestUtil getParamsWithString:param] andMethod:RequestMethodPost andTimeoutInterval:10];
}
- (void)downloadListData{
    if(self.sliderCurrentIndex==0){
        [self downloadMemCaseListData];
    }else if (self.sliderCurrentIndex==1){
        [self downloadMemActicleData];
    }else{
        [self downloadMemTradeCommData];
    }
}

- (void)downloadMemCaseListData{
    //案例
    NSString * param=[NSString stringWithFormat:MEMBERINFO_CASELIST_URL,self.mainView.page+1,self.memberInfo.uid];
    [self.requestUtil asyncThirdLibWithUrl:SERVER_URL andParameters:[RequestUtil getParamsWithString:param] andMethod:RequestMethodPost andTimeoutInterval:10];
}

- (void)downloadMemActicleData{
    //博文
    NSString * param=[NSString stringWithFormat:MEMBERINFO_ARTICLE_URL,self.mainView.page+1,self.memberInfo.uid];
    [self.requestUtil asyncThirdLibWithUrl:SERVER_URL andParameters:[RequestUtil getParamsWithString:param] andMethod:RequestMethodPost andTimeoutInterval:10];
}

- (void)downloadMemTradeCommData{
    //评价
    NSString * param=[NSString stringWithFormat:MEMBERINFO_TRADECOMMENT_URL,self.memberInfo.uid,self.mainView.page+1];
    [self.requestUtil asyncThirdLibWithUrl:SERVER_URL andParameters:[RequestUtil getParamsWithString:param] andMethod:RequestMethodPost andTimeoutInterval:10];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    if(statusCode==200 && !error){
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if(dict[@"data"]==[NSNull null]){
            self.mainView.dataArray=self.dataArray;
            return;
        }
        
        if([[dict[@"data"] class]isSubclassOfClass:[NSArray class]]){
            NSArray * dataArray = dict[@"data"];
            for (NSDictionary * dataDict in dataArray) {
                NSObject * obj;
                if(self.sliderCurrentIndex==0){
                    obj=[Case caseWithDict:dataDict];
                }else if (self.sliderCurrentIndex==1){
                    obj=[BlogArticle blogArticleWithDict:dataDict];
                }
                
                [self.dataArray[self.sliderCurrentIndex] addObject:obj];
            }
            self.mainView.dataArray=self.dataArray;
            return;
        }
        if(self.sliderCurrentIndex==2){
            
            
            return;
        }
        
        NSDictionary * memberInfoDict=dict[@"data"];
        self.memberInfo=[MemberInfo memberInfoWithDict:memberInfoDict];
        self.mainView.memberInfo=self.memberInfo;
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
        [_dataArray addObject:[NSMutableArray new]];
        [_dataArray addObject:[NSMutableArray new]];
        [_dataArray addObject:[NSMutableArray new]];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.oldNavColor = self.navigationController.navigationBar.barTintColor;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    [AppDelegate getTabbar].hidden=YES;
    self.statusBarStyle=[UIApplication sharedApplication].statusBarStyle;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor=self.oldNavColor;
    [UIApplication sharedApplication].statusBarStyle=self.statusBarStyle;
}

@end
