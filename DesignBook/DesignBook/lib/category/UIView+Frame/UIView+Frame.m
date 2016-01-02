//
//  UIView+Frame.m
//  侧滑栏
//
//  Created by 陈行 on 15-11-4.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x=x;
    self.frame=rect;
}
- (void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y=y;
    self.frame=rect;
}
-(void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width=width;
    self.frame=rect;
}
- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height=height;
    self.frame=rect;
}

- (CGFloat)x{
    return self.frame.origin.x;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (CGFloat)width{
    return self.frame.size.width;
}
- (CGFloat)height{
    return self.frame.size.height;
}

@end
