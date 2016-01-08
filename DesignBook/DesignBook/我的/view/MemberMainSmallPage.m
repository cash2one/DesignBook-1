//
//  MemberMainSmallPage.m
//  DesignBook
//
//  Created by 陈行 on 16-1-7.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "MemberMainSmallPage.h"
#import "QRCodeGenerator.h"

@interface MemberMainSmallPage()

@property (weak, nonatomic) IBOutlet UILabel *spaceTagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sjsUrlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@end

@implementation MemberMainSmallPage

- (void)setMemberInfo:(MemberInfo *)memberInfo{
    _memberInfo=memberInfo;
    self.spaceTagsLabel.text=memberInfo.spaceTags;
    self.sjsUrlLabel.text=memberInfo.sjsUrl;
    self.smallImageView.image=[QRCodeGenerator qrImageForString:memberInfo.sjsUrl imageSize:self.smallImageView.frame.size.width];
}

@end
