//
//  PictureDetailViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-7.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "PictureDetailViewController.h"
#import "QueAnsDetailViewController.h"
#import "PicCollectionViewController.h"
#import "MemberViewController.h"
#import "PictureDetailMainView.h"

@interface PictureDetailViewController ()<RequestUtilDelegate,PictureDetailMainViewDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,strong)RequestUtil * requestUtil;

@property(nonatomic,weak)PictureDetailMainView * currentmMainView;

@property(nonatomic,strong)ImageInfo * imageInfo;

@end

@implementation PictureDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainView];
    [self loadNavigationBar];
    [self downloadData];
}

#pragma mark - 初始化
- (void)loadMainView{
    UIScrollView * scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:scrollView];
    
    PictureDetailMainView * mainView=[[PictureDetailMainView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    mainView.mainViewDelegate=self;
    self.currentmMainView=mainView;
    [scrollView addSubview:mainView];
}

- (void)memHeaderImageViewBtnTouch:(UIView *)imageView{
    MemberViewController * con=[MemberViewController new];
    [self.navigationController pushViewController:con animated:YES];
    con.memberInfo=self.imageInfo.memberInfo;
}

- (void)itemSelectedWithMainView:(PictureDetailMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    if(self.currentmMainView.sliderCurrentIndex==0){
        QueAnsDetailViewController * con=[QueAnsDetailViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.queAndAns=self.imageInfo.askList[indexPath.row];
    }else{
        PicCollectionViewController * con=[PicCollectionViewController new];
        [self.navigationController pushViewController: con animated:YES];
        con.pictureCol=self.imageInfo.colList[indexPath.row];
    }
}

- (void)loadNavigationBar{
    UIImage * backImage=[[UIImage imageNamed:@"ico_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * shareImage=[[UIImage imageNamed:@"ico_share_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton * backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(0, 0, 50, 44);
    backBtn.backgroundColor=[UIColor clearColor];
    [backBtn addTarget:self action:@selector(backToPreviousViewCon) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    UIButton * shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake(WIDTH-50, 0, 50, 44);
    shareBtn.backgroundColor=[UIColor clearColor];
    [shareBtn addTarget:self action:@selector(shareWebView) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:shareImage forState:UIControlStateNormal];
    [self.view addSubview:shareBtn];
}
- (void)backToPreviousViewCon{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareWebView{
    NSString * text=[NSString stringWithFormat:@"在设计本网站发现这张图片很不错，分享给大家%@",self.imageInfo.shareUrl];
    [UMSocialSnsService presentSnsController:self appKey:KUMengKey shareText:text shareImage:self.currentmMainView.shareImage shareToSnsNames:@[UMShareToSina,UMShareToQQ,UMShareToWechatSession,UMShareToRenren] delegate:nil];
}

#pragma mark - 下载数据
- (void)downloadData{
    [self.alertView show];
    //先从数据库取
    ImageInfo * imageInfo=self.dataArray[self.indexPath.row];
    NSString * urlString=[NSString stringWithFormat:PICTURE_DETAIL_URL,imageInfo.Id];
    [self.requestUtil asyncThirdLibWithUrl:urlString andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    if(statusCode==200 && !error){
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dataDict=dict[@"data"];
        self.dataArray[self.indexPath.row]=[ImageInfo imageInfoWithDict:dataDict];
        self.currentmMainView.imageInfo=self.imageInfo;
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

- (ImageInfo *)imageInfo{
    return self.dataArray[self.indexPath.row];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    [AppDelegate getTabbar].hidden=YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end
