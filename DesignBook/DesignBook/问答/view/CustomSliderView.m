//
//  CustomSliderView.m
//  良仓
//
//  Created by 陈行 on 15-12-15.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CustomSliderView.h"

@interface CustomSliderView()



@end

@implementation CustomSliderView

+ (instancetype)sliderViewWithItems:(NSArray *)items andFrame:(CGRect)frame{
    return [[self alloc]initWithItems:items andFrame:frame];
}
- (instancetype)initWithItems:(NSArray *)items andFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        self.items=items;
        [self createHorizontalLine];
    }
    return self;
}

- (void)setItems:(NSArray *)items{
    _items=items;
    int index=0;
    NSMutableArray * array=[[NSMutableArray alloc]init];
    for (NSString * title in items) {
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [array addObject:btn];
        btn.frame=CGRectMake(self.frame.size.width/items.count*index, 0, self.frame.size.width/items.count-1, self.frame.size.height-4);
        btn.tag=index;
        [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        index++;
    }//for end
    _btnArray=array;
    [self setSelectedBtn:0];
}

- (void)btnTouch:(UIButton *)btn{
    [self setSelectedBtn:btn.tag];
    [self.delegate sliderView:self andIndex:btn.tag andBtnArray:self.btnArray];
}

- (void)createHorizontalLine{
    UIView * hl=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width/self.items.count, 2)];
    [self addSubview:hl];
    hl.backgroundColor=[UIColor orangeColor];
    self.horiLine=hl;
}

- (void)setSelectedBtn:(NSInteger)index{
    for (UIButton * btn in self.btnArray) {
        if(btn.tag==index){
            btn.selected=YES;
        }else{
            btn.selected=NO;
        }
    }
    CGRect rect=self.horiLine.frame;
    rect.origin.x=self.horiLine.frame.size.width*index;
    self.horiLine.frame=rect;
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor{
    _normalTitleColor=normalTitleColor;
    for (UIButton * btn in self.btnArray) {
        [btn setTitleColor:normalTitleColor forState:UIControlStateNormal];
    }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor{
    _selectedTitleColor=selectedTitleColor;
    for (UIButton * btn in self.btnArray) {
        [btn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }
}

@end
