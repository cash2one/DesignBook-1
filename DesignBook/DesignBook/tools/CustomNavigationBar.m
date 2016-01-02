//
//  CustomNavigationBar.m
//  封装-webView的一些内容
//
//  Created by 陈行 on 15-12-12.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CustomNavigationBar.h"




@interface CustomNavigationBar()

@property(nonatomic,strong)NSMutableArray * btnLeftArray;
@property(nonatomic,strong)NSMutableArray * btnRightArray;

@property(nonatomic,weak)UINavigationController * navCon;
@end

@implementation CustomNavigationBar

+ (CustomNavigationBar *)navigationBarWithBackgroundImageName:(NSString *)backgroundImageName andTitle:(NSString *)title andNavBarItemArray:(NSArray *)navBarItemArray{
    return [[self alloc]initWithBackgroundImageName:backgroundImageName andTitle:title andNavBarItemArray:navBarItemArray];
}

- (CustomNavigationBar *)initWithBackgroundImageName:(NSString *)backgroundImageName andTitle:(NSString *)title andNavBarItemArray:(NSArray *)navBarItemArray{
    if(self=[super initWithFrame:CGRectZero]){
        if(backgroundImageName)
            self.backgroundImageName=backgroundImageName;
        if(title)
            self.title=title;
        if(navBarItemArray && navBarItemArray.count!=0)
            self.navBarItemArray=navBarItemArray;
        
    }
    return self;
}

#pragma mark- 设置属性的set方法
- (void)setBackgroundImageName:(NSString *)backgroundImageName{
    _backgroundImageName=backgroundImageName;
    if(_bgImageView==nil){
        UIImageView * bgImageView=[[UIImageView alloc]init];
        [self addSubview:bgImageView];
        _bgImageView=bgImageView;
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@0);
        }];
    }
    _bgImageView.image=[UIImage imageNamed:backgroundImageName];
}

- (void)setTitle:(NSString *)title{
    _title=title;
    if(_titleLabel==nil){
        UILabel * label=[[UILabel alloc]initWithFrame:self.bounds];
        [self addSubview:label];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        _titleLabel=label;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@40);
        }];
    }
    _titleLabel.text=title;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor=titleColor;
    self.titleLabel.textColor=titleColor;
}

- (void)setTitleView:(UIView *)titleView{
    _titleView=titleView;
    [self addSubview:titleView];
    titleView.center=self.center;
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.centerX.equalTo(self);
        make.width.equalTo(@(WIDTH*2/3));
        make.top.equalTo(@0);
    }];
    
}

- (void)setNavBarItemArray:(NSArray *)navBarItemArray{
    _navBarItemArray=navBarItemArray;
    [self createButtonWithNavBarItemArray:navBarItemArray];
    [self autolayoutView];
}

#pragma mark - 创建button按钮
- (void)createButtonWithNavBarItemArray:(NSArray *)navBarItemArray{
    int li=0;
    int ri=0;
    for(CustomNavigationBarItem *item in navBarItemArray){
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        if(item.isLeftBtn){
            btn.frame=CGRectMake(55*li+10, 20, 55, 32);
            [self.btnLeftArray addObject:btn];
            li++;
        }else{
            btn.frame=CGRectMake(WIDTH-55*(ri+1)-10, 20, 55, 32);
            [self.btnRightArray addObject:btn];
            ri++;
        }
        //背景图
        if(item.normalBgImageName){
            [btn setBackgroundImage:[[UIImage imageNamed:item.normalBgImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
        if(item.selectedBgImageName){
            [btn setBackgroundImage:[[UIImage imageNamed:item.selectedBgImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[[UIImage imageNamed:item.selectedBgImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        }
        //图标图
        if (item.normalImageName) {
            [btn setImage:[[UIImage imageNamed:item.normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        }
        if (item.selectedImageName) {
            [btn setImage:[[UIImage imageNamed:item.selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateHighlighted];
            [btn setImage:[[UIImage imageNamed:item.selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateSelected];
        }
        
        //tag
        btn.tag=item.itemTag;
        if (item.normalTitleColor) {
            [btn setTitleColor:item.normalTitleColor forState:UIControlStateNormal];
        }
        if(item.selectedTitleColor){
            [btn setTitleColor:item.selectedTitleColor forState:UIControlStateHighlighted];
            [btn setTitleColor:item.selectedTitleColor forState:UIControlStateSelected];
        }
        //事件
        [btn addTarget:item.target action:item.sel forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }//for end
}
#pragma mark- 自适应
- (void)autolayoutView{
    
    for (int i=0;i<self.btnLeftArray.count;i++){
        UIButton * btn=self.btnLeftArray[i];
        if(i==0){
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@28);
                make.bottom.equalTo(@-8);
                make.left.equalTo(self).offset(8);
                make.width.equalTo(@50);
            }];
        }else{
            UIButton * preBtn=self.btnLeftArray[i-1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@28);
                make.bottom.equalTo(@-8);
                make.left.equalTo(preBtn.mas_right).offset(10);
                make.width.equalTo(@50);
            }];
        }
    }//for end
    
    for (int i=0;i<self.btnRightArray.count;i++){
        UIButton * btn=self.btnRightArray[i];
        if(i==0){
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@28);
                make.bottom.equalTo(@-8);
                make.right.equalTo(self).offset(-8);
                make.width.equalTo(@50);
            }];
        }else{
            UIButton * preBtn=self.btnRightArray[i-1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@28);
                make.bottom.equalTo(@-8);
                make.right.equalTo(preBtn.mas_left).offset(-8);
                make.width.equalTo(@50);
            }];
        }
    }//for end
    
}

#pragma mark- 懒加载
- (NSMutableArray *)btnLeftArray{
    if(_btnLeftArray==nil){
        _btnLeftArray=[[NSMutableArray alloc]init];
    }
    return _btnLeftArray;
}

- (NSMutableArray *)btnRightArray{
    if(_btnRightArray==nil){
        _btnRightArray=[[NSMutableArray alloc]init];
    }
    return _btnRightArray;
}

@end
