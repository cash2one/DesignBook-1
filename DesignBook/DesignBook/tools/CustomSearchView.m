//
//  CustomSearchBar.m
//  TestSearchViewController
//
//  Created by 陈行 on 16-1-9.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CustomSearchView.h"

#define SELFWIDTH self.frame.size.width
#define SELFHEIGHT self.frame.size.height

@interface CustomSearchView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *filterArray;
@property (nonatomic, strong) NSMutableArray *searchArray;

@property(nonatomic,weak)UITextField * searchTextField;

@property(nonatomic,assign)CGRect oldFrame;

@end



@implementation CustomSearchView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.oldFrame=frame;
        [self loadSearchView];
    }
    return self;
}


- (void)loadSearchView{
    
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH, SELFHEIGHT) style:UITableViewStyleGrouped];
    tableView.dataSource=self;
    tableView.delegate=self;
    self.tableView= tableView;
    [self addSubview:tableView];
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH, 64)];
    headerView.backgroundColor=[UIColor whiteColor];
    UITextField * tf=[[UITextField alloc]initWithFrame:CGRectMake(8, 27, SELFWIDTH-16-70, 30)];
    tf.backgroundColor=[UIColor colorWithRed:0.92f green:0.91f blue:0.92f alpha:1.00f];
    tf.borderStyle=UITextBorderStyleRoundedRect;
    tf.clearButtonMode=UITextFieldViewModeWhileEditing;
    tf.delegate=self;
    [tf becomeFirstResponder];
    tf.returnKeyType=UIReturnKeySearch;
    tf.font=[UIFont systemFontOfSize:14];
    UIImageView * imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_find_search"]];
    imageView.frame=CGRectMake(8, 0, 15, 15);
    tf.leftView=imageView;
    tf.leftViewMode=UITextFieldViewModeAlways;
    self.searchTextField=tf;
    [headerView addSubview:tf];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(SELFWIDTH-70, 27, 70, 30);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancleBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn];
    
    self.tableView.tableHeaderView=headerView;
    
}

#pragma mark - tableView的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!self.filterArray || self.filterArray.count==0){
        self.filterArray=self.searchArray;
    }
    if(self.filterArray.count>5){
        return 5;
    }else{
        return self.filterArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"UITableViewCell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.textLabel.text = [self.filterArray objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
    self.searchTextField.text=self.filterArray[indexPath.row];
    [self.delegate customSearchBar:self andSearchValue:self.filterArray[indexPath.row]];
    [self.searchArray removeAllObjects];
    [self.filterArray removeAllObjects];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.searchArray.count?44:0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(self.searchArray.count==0){
        return nil;
    }
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor whiteColor];
    btn.frame=CGRectMake(0, 0, 375, 44);
    [btn setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(clearBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)clearBtnTouch{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"searchText"];
    [self.searchArray removeAllObjects];
    [self.filterArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - searchbar协议方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.placeholder=@"搜索案例/图片/问答/设计师";
    self.searchArray=[self getSearchArrayByUserDefaults];
    [self.tableView reloadData];
    self.frame=self.oldFrame;
    self.tableView.frame=self.oldFrame;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.placeholder=@"搜索案例/图片/问答...";
    CGRect frame = self.frame;
    frame.size.height=64;
    self.frame=frame;
    self.tableView.frame=frame;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *filterString = textField.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", filterString];
    self.filterArray = [NSMutableArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self setSearchArrayByUserDefaults:textField.text];
    self.searchArray=nil;
    self.filterArray=nil;
    [self.tableView reloadData];
    [self endEditing:YES];
    [self.delegate customSearchBar:self andSearchValue:textField.text];
    return YES;
}

- (void)cancleBtnTouch:(UIButton *)btn{
    [self.delegate customSearchBar:self andCancleBtn:btn];
}

#pragma mark - 懒加载
- (NSMutableArray *)getSearchArrayByUserDefaults{
    NSUserDefaults * def=[NSUserDefaults standardUserDefaults];
    return [def objectForKey:SEARCHTEXT];
}

- (void)setSearchArrayByUserDefaults:(NSString *)value{
    NSUserDefaults * def=[NSUserDefaults standardUserDefaults];
    NSMutableArray * array = [def objectForKey:SEARCHTEXT];
    if(array==nil){
        array=[[NSMutableArray alloc]init];
        [array addObject:value];
    }else{
        for (NSString * tmpVal in array) {
            if([tmpVal isEqualToString:value]){
                return;
            }
        }
        [array addObject:value];
    }
    [def setObject:array forKey:SEARCHTEXT];
}

@end
