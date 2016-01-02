//
//  CustomWebTabbar.m
//  封装-webView的一些内容
//
//  Created by 陈行 on 15-12-14.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CustomWebTabbar.h"
#import "Masonry.h"

@interface CustomWebTabbar()

@property(nonatomic,strong)NSMutableArray * btnArray;

@end

@implementation CustomWebTabbar

+ (instancetype)tabbarWithTabbarItemArray:(NSArray *)itemArray andFrame:(CGRect)frame{
    return [[self alloc]initWithTabbarItemArray:itemArray andFrame:frame];
}

- (instancetype)initWithTabbarItemArray:(NSArray *)itemArray andFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        UIImageView * bgImageView=[[UIImageView alloc]initWithFrame:self.bounds];
        _backgroundImageView=bgImageView;
        [self addSubview:bgImageView];
        self.itemArray=itemArray;
    }
    return self;
}
#pragma mark - 首先设置内容
- (void)setItemArray:(NSArray *)itemArray{
    _itemArray=itemArray;
    
    int i=0;
    
    for (CustomTabbarItem * item in itemArray) {
        CGFloat btnW=WIDTH/itemArray.count;
        CGFloat btnH=49;
        CGFloat btnX=btnW*i;
        CGFloat btnY=0;
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor=[UIColor redColor];
        btn.tag=i;
        btn.frame=CGRectMake(btnX,btnY,btnW,btnH);
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        if(item.title==nil || [item.title isEqualToString:@""]){
//            [btn setBackgroundImage:[[UIImage imageNamed:item.imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//            [btn setBackgroundImage:[[UIImage imageNamed:item.selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
//            [btn setBackgroundImage:[[UIImage imageNamed:item.selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
            [btn setImage:[[UIImage imageNamed:item.imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [btn setImage:[[UIImage imageNamed:item.selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
            [btn setImage:[[UIImage imageNamed:item.selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        }else{
            [btn setTitle:item.title forState:UIControlStateNormal];
            
            if(item.imageName){
                [btn setImage:[[UIImage imageNamed:item.imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }
            if(item.selectedImageName){
                [btn setImage:[[UIImage imageNamed:item.selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
                [btn setImage:[[UIImage imageNamed:item.selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
            }
            
            if(item.imageName && item.selectedImageName){
                
                CGFloat btnH=btn.frame.size.height;
                CGFloat btnW=btn.frame.size.width;
                
                CGFloat ivX=btn.imageView.frame.origin.x;
                CGFloat ivY=btn.imageView.frame.origin.y;
                CGFloat ivW=btn.imageView.frame.size.width;
                
                CGFloat titX=btn.titleLabel.frame.origin.x;
                CGFloat titY=btn.titleLabel.frame.origin.y;
                CGFloat titW=btn.titleLabel.frame.size.width;
                CGFloat titH=btn.titleLabel.frame.size.height;
                
                CGFloat t1=-ivY;
                CGFloat l1=btnW*0.5-(ivX+ivW*0.5);
                CGFloat b1=ivY;
                CGFloat r1=-btnW*0.5+(ivX+ivW*0.5);
                btn.imageEdgeInsets=UIEdgeInsetsMake(t1,l1,b1,r1);
                
                CGFloat t2=btnH-titY-titH;
                CGFloat l2=btnW*0.5-(titX+titW*0.5);
                CGFloat b2=-btnH+titY+titH;
                CGFloat r2=-btnW*0.5+(titX+titW*0.5);
                
                btn.titleEdgeInsets=UIEdgeInsetsMake(t2,l2,b2,r2);
            }
        }
        [btn addTarget:self action:@selector(tabbarBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btnArray addObject:btn];
        i++;
    }//for end
    [self autolayoutMyTabbar];
}
#pragma mark- 设置点击item项的颜色
- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor=normalColor;
    for (UIButton * btn in self.btnArray) {
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
    }
}
- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor=selectedColor;
    for (UIButton * btn in self.btnArray) {
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
        [btn setTitleColor:selectedColor forState:UIControlStateHighlighted];
    }
}
//- (void)setNormalBgColor:(UIColor *)normalBgColor{
//    _normalBgColor=normalBgColor;
//    for (UIButton * btn in self.btnArray) {
//        [btn setBackgroundImage:[self imageWithColor:normalBgColor] forState:UIControlStateNormal];
//    }
//}
//
//- (void)setSelectedBgColor:(UIColor *)selectedBgColor{
//    _selectedBgColor=selectedBgColor;
//    for (UIButton * btn in self.btnArray) {
//        [btn setBackgroundImage:[self imageWithColor:selectedBgColor] forState:UIControlStateHighlighted];
//        [btn setBackgroundImage:[self imageWithColor:selectedBgColor] forState:UIControlStateSelected];
//    }
//}

//  颜色转换为背景图片
//- (UIImage *)imageWithColor:(UIColor *)color {
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}

#pragma mark- tabbar点击事件
- (void)tabbarBtnTouch:(UIButton *)btn{
    [self setSelectedBtnWithIndex:[self.btnArray indexOfObject:btn]];
    [self.delegate tabbar:self andIndex:[self.btnArray indexOfObject:btn] andBtnArray:self.btnArray];
}

- (void)setSelectedBtnWithIndex:(NSInteger)index{
    for (UIButton * btn in self.btnArray) {
        btn.selected=NO;
        btn.userInteractionEnabled=YES;
        btn.backgroundColor=[UIColor whiteColor];
        if(self.btnArray[index]==btn){//当前的按钮
            btn.backgroundColor=[UIColor colorWithRed:0.195 green:0.688 blue:1.000 alpha:1.000];
            btn.selected=YES;
            btn.userInteractionEnabled=NO;
        }
    }
}

#pragma mark- 设置背景图片
- (void)setBackgroundImageName:(NSString *)backgroundImageName{
    _backgroundImageName=backgroundImageName;
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    self.backgroundImageView.image=[UIImage imageNamed:backgroundImageName];
}

- (NSMutableArray *)btnArray{
    if(_btnArray==nil){
        _btnArray=[[NSMutableArray alloc]init];
    }
    return _btnArray;
}

- (void)autolayoutMyTabbar{
    for (int i=0;i<self.btnArray.count;i++){
        UIButton * btn=self.btnArray[i];
        if(i==0){
            UIButton * nextBtn=self.btnArray[i+1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(@0);
                make.left.equalTo(self).offset(0);
                make.right.equalTo(nextBtn.mas_left).offset(0);
                make.width.equalTo(nextBtn.mas_width);
            }];
        }else if (i==self.btnArray.count-1){
            UIButton * preBtn=self.btnArray[i-1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(@0);
                make.left.equalTo(preBtn.mas_right).offset(0);
                make.right.equalTo(self).offset(0);
                make.width.equalTo(preBtn.mas_width);
            }];
        }else{
            UIButton * preBtn=self.btnArray[i-1];
            UIButton * nextBtn=self.btnArray[i+1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(@0);
                make.left.equalTo(preBtn.mas_right).offset(0);
                make.right.equalTo(nextBtn.mas_left).offset(0);
                make.width.equalTo(preBtn.mas_width);
            }];
        }
    }//for end
}

@end
