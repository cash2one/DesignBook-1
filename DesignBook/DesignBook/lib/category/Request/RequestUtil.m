//
//  RequestUtil.m
//  比颜值
//
//  Created by 陈行 on 15-11-19.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "RequestUtil.h"
#import "AFNetworking.h"


@implementation RequestUtil

- (void)asyncSessionWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters andMethod:(RequestMethod)method andTimeoutInterval:(NSInteger)timeoutInterval{
    
    NSURL * url=[NSURL URLWithString:urlString];
    
    NSString * params=[self stringWithParameters:parameters];
    NSData * paramData=[params dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
    request.HTTPBody=paramData;
    if(method==RequestMethodPost){
        request.HTTPMethod=@"POST";
    }else{
        request.HTTPMethod=@"GET";
    }
    NSURLSession * session=[NSURLSession sharedSession];
    
    NSURLSessionTask * task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse * res=(NSHTTPURLResponse *)response;
        [self.delegate response:response andError:error andData:data andStatusCode:res.statusCode andURLString:urlString];
    }];
    [task resume];
}

- (void)asyncThirdLibWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters andMethod:(RequestMethod)method andTimeoutInterval:(NSInteger)timeoutInterval{
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval=timeoutInterval;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if(method==RequestMethodPost){
        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSHTTPURLResponse * res=(NSHTTPURLResponse *)operation.response;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate response:operation.response andError:nil andData:responseObject andStatusCode:res.statusCode andURLString:urlString];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse * res=(NSHTTPURLResponse *)operation.response;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate response:operation.response andError:error andData:nil andStatusCode:res.statusCode andURLString:urlString];
            });
        }];
    }else{
        [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSHTTPURLResponse * res=(NSHTTPURLResponse *)operation.response;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate response:operation.response andError:nil andData:responseObject andStatusCode:res.statusCode andURLString:urlString];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse * res=(NSHTTPURLResponse *)operation.response;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate response:operation.response andError:error andData:nil andStatusCode:res.statusCode andURLString:urlString];
            });
        }];
    }
}

/**
 *  把参数按照key=value&key1=value1的格式进行拼接
 *
 *  @param parameters 参数
 *
 *  @return key=value&key1=value1
 */
- (NSString *)stringWithParameters:(NSDictionary *)parameters{
    int i=0;
    NSMutableString * paramsStr=[NSMutableString string];
    for(NSString * key in [parameters allKeys]){
        if(i!=0){
            [paramsStr appendString:@"&"];
        }
        [paramsStr appendFormat:@"%@=%@",key,parameters[key]];
        i++;
    }
    return paramsStr;
}

+ (NSDictionary *)getParamsWithString:(NSString *)value{
    NSMutableDictionary * dict=[NSMutableDictionary new];
    
    NSArray * array=[value componentsSeparatedByString:@"&"];
    for (NSString * keyValue in array) {
        NSArray * tmpKeyValueArr=[keyValue componentsSeparatedByString:@"="];
        NSString * key=tmpKeyValueArr[0];
        NSString * value=tmpKeyValueArr[1];
        value=value.length?value:@"";
        [dict setObject:value forKey:key];
    }
    return dict;
}

@end
