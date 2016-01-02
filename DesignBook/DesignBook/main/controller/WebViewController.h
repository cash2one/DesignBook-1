//
//  WebViewController.h
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property(nonatomic,copy)NSString * requestUrl;

@property(nonatomic,copy)NSString * titleName;

@property(nonatomic,weak)UIImage * shareImage;

/**
 *  默认为false不隐藏
 */
@property(nonatomic,assign)BOOL isHiddenShare;

@end
