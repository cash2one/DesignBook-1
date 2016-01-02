//
//  CustomWebProgressView.m
//  良仓
//
//  Created by 陈行 on 15-12-17.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CustomWebProgressView.h"

@interface CustomWebProgressView()

@property(nonatomic,weak)WKWebView *webView;

@property(nonatomic,assign)double oldEstimatedProgress;

@end

@implementation CustomWebProgressView

+ (CustomWebProgressView *)progressViewAndFrame:(CGRect)frame andWebView:(WKWebView *)webView{
    return [[self alloc]initWithFrame:frame andWebView:webView];
}

- (instancetype)initWithFrame:(CGRect)frame andWebView:(WKWebView *)webView
{
    frame.origin.x=-[UIScreen mainScreen].bounds.size.width;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor greenColor];
        self.hidden=YES;
        
        self.webView=webView;
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)setEstimatedProgress:(CGFloat)estimatedProgress{
    _estimatedProgress=estimatedProgress;
    self.hidden=NO;
    if(estimatedProgress==1){
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.frame;
            rect.origin.x=0;
            self.frame=rect;
        } completion:^(BOOL finished) {
            CGRect rect = self.frame;
            rect.origin.x=-[UIScreen mainScreen].bounds.size.width;
            self.frame=rect;
            self.hidden=YES;
            _oldEstimatedProgress=0;
        }];
    }else{
        if(_estimatedProgress>=_oldEstimatedProgress){
            [UIView animateWithDuration:0.25 animations:^{
                CGRect rect = self.frame;
                rect.origin.x=(estimatedProgress-1)*[UIScreen mainScreen].bounds.size.width;
                self.frame=rect;
            } completion:^(BOOL finished) {
                _oldEstimatedProgress=estimatedProgress;
            }];
        }
    }
}

- (void)freeWebProgressView{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"estimatedProgress"]){
        double progress = [change[@"new"] doubleValue];
        self.estimatedProgress=progress;
    }
}

@end
