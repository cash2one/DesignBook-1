//
//  CustomWebProgressView.h
//  良仓
//
//  Created by 陈行 on 15-12-17.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface CustomWebProgressView : UIView

@property(nonatomic,assign)CGFloat estimatedProgress;

/**
 *  使用完毕需要调用freeWebProgressView方法进行释放
 *
 *  @param frame
 *  @param webView
 *
 */
+ (CustomWebProgressView *)progressViewAndFrame:(CGRect)frame andWebView:(WKWebView *)webView;

- (void)freeWebProgressView;

@end
