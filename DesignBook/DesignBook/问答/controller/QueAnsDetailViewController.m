//
//  QueAnsDetailViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "QueAnsDetailViewController.h"
#import "NormalUserViewController.h"
#import "MemberViewController.h"
#import "QueAndAnsDetailMainView.h"
#import "UIImageView+WebCache.h"

@interface QueAnsDetailViewController ()<RequestUtilDelegate,QueAndAnsDetailMainViewDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,strong)RequestUtil * requestUtil;
@property(nonatomic,strong)NSMutableArray * commmentArray;

@property(nonatomic,weak)QueAndAnsDetailMainView * mainView;

@end

@implementation QueAnsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigationBar];
    [self loadMainView];
    [self downloadData];
}

#pragma mark - 初始加载
- (void)loadMainView{
    QueAndAnsDetailMainView * mainView=[[QueAndAnsDetailMainView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-44) andQueAndAns:self.queAndAns];
    mainView.mainViewDelegate = self;
    [self.view addSubview:mainView];
    self.mainView=mainView;
}

- (void)loadNavigationBar{
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    self.navigationItem.title=@"问答";
    
    UIBarButtonItem * lbbi=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousViewCon)];
    
    self.navigationItem.leftBarButtonItem=lbbi;
    
    UIBarButtonItem * rbbi=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_share_inNavBar_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareWebView)];
    
    self.navigationItem.rightBarButtonItem=rbbi;
    
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor redColor];
    [btn setImage:[UIImage imageNamed:@"ico_signin"] forState:UIControlStateNormal];
    [btn setTitle:@"我来回答" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    btn.frame=CGRectMake(0, HEIGHT-44, WIDTH, 44);
    [self.view addSubview:btn];
}
- (void)backToPreviousViewCon{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareWebView{
    UIImageView * imageView=[[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.queAndAns.pics[0]]];
    
    [UMSocialSnsService presentSnsController:self appKey:KUMengKey shareText:self.queAndAns.shareUrl shareImage:imageView.image shareToSnsNames:@[UMShareToSina,UMShareToQQ,UMShareToWechatSession,UMShareToRenren] delegate:nil];
}

- (void)praiseNumBtnTouchWithIndex:(NSInteger)index{
    NSLog(@"点赞%ld",index);
}

- (void)headerImageViewBtnTouchWithIndex:(NSInteger)index{
    Comment * comment = self.commmentArray[index];
    MemberInfo * memberInfo=[MemberInfo new];
    memberInfo.uid=comment.uid;
    memberInfo.facePic=comment.facePic;
    memberInfo.nick=comment.nick;
    if(comment.identity==1){
        MemberViewController * con=[MemberViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.memberInfo=memberInfo;
    }else{
        NormalUserViewController * con=[NormalUserViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.memberInfo=memberInfo;
    }
}
#pragma mark - 下载数据
- (void)downloadData{
    //先从数据库取
    [self.alertView show];
    NSString * urlStr=[NSString stringWithFormat:QUEANDANS_DETAIL_URL,self.queAndAns.Id,1l];
    [self.requestUtil asyncThirdLibWithUrl:urlStr andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    if(statusCode==200 && !error){
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dataDict = dict[@"data"];
        
        for (NSDictionary * comDict in dataDict[@"commentList"]) {
            [self.commmentArray addObject:[Comment commentWithDict:comDict]];
        }
        self.mainView.commentArray=self.commmentArray;
        
        self.queAndAns=[QueAndAns queAndAnsWithDict:dataDict[@"askInfo"]];
        self.mainView.queAndAns=self.queAndAns;
        
        
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

- (NSMutableArray *)commmentArray{
    if(_commmentArray==nil){
        _commmentArray=[NSMutableArray new];
    }
    return _commmentArray;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [AppDelegate getTabbar].hidden=YES;
    self.navigationController.navigationBarHidden=NO;
}
@end
