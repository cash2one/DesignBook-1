//
//  MemberMainHeaderView.h
//  DesignBook
//
//  Created by 陈行 on 16-1-7.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberInfo.h"

@interface MemberMainHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *onlineBtn;

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property(nonatomic,strong)MemberInfo * memberInfo;

@end
