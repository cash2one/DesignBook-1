//
//  MineViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-2.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "MineViewController.h"
#import "MineMainView.h"
#import "MineTableView.h"

@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UIView *containView;

@property(nonatomic,weak)MineTableView * tableView;

@end

@implementation MineViewController
- (instancetype)init{
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"MineViewController" bundle:nil];
    MineViewController * con =[sb instantiateViewControllerWithIdentifier:@"MineViewController"];
    return con;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView=self.containView.subviews[0];
}



- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
}

@end
