//
//  RequestUtil.h
//  比颜值
//
//  Created by 陈行 on 15-11-19.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum RequestMethod{
    RequestMethodGet,//get方式请求
    RequestMethodPost,//post方式请求
}RequestMethod;


@protocol RequestUtilDelegate <NSObject>

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString;

@end

@interface RequestUtil : NSObject

@property(nonatomic,weak)id<RequestUtilDelegate>delegate;

/**
 *
 *  @param urlString       url地址
 *  @param parameters      请求参数
 *  @param method          请求方式
 *  @param timeoutInterval 超时时间
 */
//- (void)asyncWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters andMethod:(RequestMethod)method andTimeoutInterval:(NSInteger)timeoutInterval;
/**
 *  异步请求
 *
 *  @param urlString       url地址
 *  @param parameters      请求参数
 *  @param method          请求方式
 *  @param timeoutInterval 超时时间
 */
- (void)asyncSessionWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters andMethod:(RequestMethod)method andTimeoutInterval:(NSInteger)timeoutInterval;

- (void)asyncThirdLibWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters andMethod:(RequestMethod)method andTimeoutInterval:(NSInteger)timeoutInterval;

@end

