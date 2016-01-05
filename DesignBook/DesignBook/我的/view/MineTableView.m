//
//  MineTableView.m
//  DesignBook
//
//  Created by 陈行 on 16-1-5.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "MineTableView.h"

@interface MineTableView()<UITableViewDelegate>



@end

@implementation MineTableView

- (void)awakeFromNib{
    self.delegate=self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"row-->%ld",indexPath.row);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

@end
