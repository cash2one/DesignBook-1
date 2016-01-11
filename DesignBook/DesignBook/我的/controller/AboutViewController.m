//
//  AboutViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-8.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "AboutViewController.h"
#import "WebViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (instancetype)init{
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"AboutViewController" bundle:nil];
    AboutViewController * con =[sb instantiateViewControllerWithIdentifier:@"AboutViewController"];
    return con;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self loadNavigationBar];
    [self createTableHeaderView];
}

- (void)createTableHeaderView{
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    headerView.backgroundColor=[UIColor colorWithRed:0.92f green:0.91f blue:0.92f alpha:1.00f];
    
    UIImageView * iv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AppIcon60x60"]];
    iv.frame=CGRectMake((WIDTH-50)*0.5, 50, 50, 50);
    iv.layer.masksToBounds=YES;
    iv.layer.cornerRadius=5.f;
    [headerView addSubview:iv];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 115, WIDTH, 20)];
    label.text=@"设计本V2.2.0";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    
    UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 140+15, WIDTH, 20)];
    label2.text=@"www.shejiben.com";
    label2.textColor=[UIColor lightGrayColor];
    label2.textAlignment=NSTextAlignmentCenter;
    label2.font=[UIFont systemFontOfSize:10];
    [headerView addSubview:label2];
    self.tableView.tableHeaderView=headerView;
}

- (void)loadNavigationBar{
    self.navigationItem.title=@"关于设计本";
    UIBarButtonItem * bbil=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"ico_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousViewCon)];
    self.navigationItem.leftBarButtonItem=bbil;
}

- (void)backToPreviousViewCon{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:@"shejiben"];
        UIAlertView * av=[[UIAlertView alloc]initWithTitle:@"微信号已复制成功，请在微信搜索并关注设计本" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }else if (indexPath.row==1){
        WebViewController * con=[WebViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.requestUrl=@"http://weibo.com/to8tosjs?systemversion=9.0&uid=5606734&channel=appstore&idfa=89645ED5-2C23-4C4F-AE9F-D67A77D36477&t8t_device_id=AD9C8E68-5378-4D13-B0F5-97A500D6842E&appostype=2&version=2.2&to8to_token=5606734_22a7c47f84f4f5af346f5b1ece70e8c4&appid=30&appversion=2.2.0";
        con.isHiddenShare=YES;
    }else if (indexPath.row==2){
        WebViewController * con=[WebViewController new];
        [self.navigationController pushViewController:con animated:YES];
        con.requestUrl=@"http://user.qzone.qq.com/49672282?systemversion=9.0&uid=5606734&channel=appstore&idfa=89645ED5-2C23-4C4F-AE9F-D67A77D36477&t8t_device_id=AD9C8E68-5378-4D13-B0F5-97A500D6842E&appostype=2&version=2.2&to8to_token=5606734_22a7c47f84f4f5af346f5b1ece70e8c4&appid=30&appversion=2.2.0";
        con.isHiddenShare=YES;
    }else if (indexPath.row==3){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4006-808-509,9999"]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
@end
