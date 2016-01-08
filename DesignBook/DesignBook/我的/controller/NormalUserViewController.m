//
//  NormalUserViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-7.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "NormalUserViewController.h"
#import "UIImageView+WebCache.h"
#import "TFilterTypeList.h"

@interface NormalUserViewController ()<RequestUtilDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,strong)RequestUtil * requestUtil;

@property(nonatomic,weak)UITableView * tableView;

@property(nonatomic,copy)UIColor * oldNavColor;

@property(nonatomic,strong)NSArray * loveStyleArray;

@property(nonatomic,strong)NSArray * nowStepArray;

@end

@implementation NormalUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loveStyleArray=[TFilterTypeList sharedTFilterTypeList].loveStyle;
    self.nowStepArray=[TFilterTypeList sharedTFilterTypeList].nowStep;
    [self loadMainView];
    [self loadNavigationBar];
}

#pragma mark - 初始加载
- (void)loadMainView{
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.backgroundColor=[UIColor colorWithRed:0.92f green:0.91f blue:0.92f alpha:1.00f];
    [self.view addSubview:tableView];
    self.tableView=tableView;
}

- (void)loadNavigationBar{
    self.navigationItem.title=self.memberInfo.nick;
    
    UIBarButtonItem * bbir=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_find_designer_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem=bbir;
    
    UIBarButtonItem * bbil=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousViewCon)];
    self.navigationItem.leftBarButtonItem=bbil;
    
}

- (void)backToPreviousViewCon{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    
    if(indexPath.section==0){
        UIImageView * iv=[[UIImageView alloc]initWithFrame:CGRectMake(8, 16, 40, 40)];
        iv.layer.masksToBounds=YES;
        iv.layer.cornerRadius=iv.width*0.5;
        [iv sd_setImageWithURL:[NSURL URLWithString:self.memberInfo.facePic] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
        [cell addSubview:iv];
        
        UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(56, 20, 150, 21)];
        label1.font=[UIFont systemFontOfSize:15];
        label1.text=self.memberInfo.nick;
        label1.textColor=[UIColor blackColor];
        [cell addSubview:label1];
        
        UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(56, 41, 150, 21)];
        label2.font=[UIFont systemFontOfSize:12];
        
        if(self.memberInfo.shen.length+self.memberInfo.city.length<2){
            label2.text=@"城市未知";
        }else{
            label2.text=[NSString stringWithFormat:@"%@ %@",self.memberInfo.shen,self.memberInfo.city];
        }
        label2.textColor=[UIColor lightGrayColor];
        [cell addSubview:label2];
    }else{
        NSString * left;
        NSString * right;
        if(indexPath.row==0){
            left=@"现处于装修阶段";
            right=self.nowStepArray[self.memberInfo.nowStep];
        }else{
            left=@"喜欢的家居风格";
            right=self.loveStyleArray[self.memberInfo.loveStyle];
        }
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 150, 44)];
        label.text=left;
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=[UIColor blackColor];
        [cell addSubview:label];
        
        UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-150, 0, 142, 44)];
        label2.textAlignment=NSTextAlignmentRight;
        label2.text=right;
        label2.font=[UIFont systemFontOfSize:14];
        label2.textColor=[UIColor lightGrayColor];
        [cell addSubview:label2];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 72;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

#pragma mark - 下载数据
- (void)downloadData{
    //先从数据库取
    NSString * param=[NSString stringWithFormat:MEMBERINFO_DETAIL_URL,self.memberInfo.uid];
    
    [self.requestUtil asyncThirdLibWithUrl:SERVER_URL andParameters:[RequestUtil getParamsWithString:param] andMethod:RequestMethodPost andTimeoutInterval:10];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    if(statusCode==200 && !error){
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * memberInfoDict=dict[@"data"];
        self.memberInfo=[MemberInfo memberInfoWithDict:memberInfoDict];
        [self.tableView reloadData];
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

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.oldNavColor = self.navigationController.navigationBar.barTintColor;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    [AppDelegate getTabbar].hidden=YES;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor=self.oldNavColor;
}
@end
