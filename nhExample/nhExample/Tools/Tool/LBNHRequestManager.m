//
//  LBNHRequestManager.m
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHRequestManager.h"
#import "AFNetworking.h"


/**
 AFHTTPSessionManager 的分类 提供一个单例方法
 */
@interface AFHTTPSessionManager (Shared)
+(instancetype)sharedInstance;
@end

@implementation AFHTTPSessionManager (Shared)

static AFHTTPSessionManager *instance;
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [AFHTTPSessionManager manager];
            instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript", @"text/html", nil];
        }
    });
    return instance;
}

@end


@implementation LBNHRequestManager
/**
 Get请求数据
 */
+(NSURLSessionTask *)GET:(NSString *)url
        parameters:(id)parameters
        responseSerializerType:(LBResponseSerializerType)type
        successHandler:(void(^)(id response, NSURLSessionDataTask *task))sucessHandler
        failureHandler:(void (^)(NSError *error, NSURLSessionDataTask *task))failureHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedInstance];
    //1.设置请求头的cookier
    [manager.requestSerializer setValue:[self cookie] forHTTPHeaderField:@"Cookie"];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //2.判断设置的响应类型 不是JSON和default默认的才设置响应类型
    if (type!=LBResponseSerializerTypeDefault && type != LBResponseSerializerTypeJSON) {
        manager.responseSerializer = [self responseWithSerializerType:type];
    }
    
    //  https证书设置
    
//    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    policy.allowInvalidCertificates = YES;
//    manager.securityPolicy  = policy;
    
    NSURLSessionTask *task = [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucessHandler) {
            sucessHandler(responseObject, task);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureHandler) {
            failureHandler(error, task);
        }
    }];
    return task;
}



/**
 post 请求数据
 */
+(NSURLSessionTask *)POST:(NSString *)url
        parameters:(id)parameters
        responseSerializerType:(LBResponseSerializerType)type
        successHandler:(void(^)(id response, NSURLSessionDataTask *task))sucessHandler
        failureHandler:(void (^)(NSError *error, NSURLSessionDataTask *task))failureHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedInstance];
    [manager.requestSerializer setValue:[self cookie] forHTTPHeaderField:@"Cookie"];
    if (type != LBResponseSerializerTypeDefault && type != LBResponseSerializerTypeJSON) {
        manager.responseSerializer = [self responseWithSerializerType:type];
    }
    NSURLSessionTask *task = [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucessHandler) {
            sucessHandler(responseObject, task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureHandler) {
            failureHandler(error, task);
        }
    }];
    return task;
}


/**
 post 上传数据
 */
+(NSURLSessionTask *)POST:(NSString *)url
        parameters:(id)parameters
        responseSerializerType:(LBResponseSerializerType)type
        constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
        successHandler:(void (^)(id response, NSURLSessionDataTask *task))sucessHandler
        failureHandler:(void(^)(NSError *error, NSURLSessionDataTask *task))failureHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedInstance];
    if (type != LBResponseSerializerTypeDefault && type !=LBResponseSerializerTypeJSON) {
        manager.responseSerializer = [self responseWithSerializerType:type];
    }
    
    NSURLSessionTask *task = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sucessHandler(responseObject, task);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureHandler(error, task);
    }];
    return task;
}


/**
 根据设置的类型获取响应的类型
 */
+(AFHTTPResponseSerializer *)responseWithSerializerType:(LBResponseSerializerType)type{
    switch (type) {
        case LBResponseSerializerTypeDefault:
            return [AFJSONResponseSerializer serializer];
            break;
        case LBResponseSerializerTypeJSON:
            return [AFJSONResponseSerializer serializer];
            break;
        case LBResponseSerializerTypeXML:
            return [AFXMLParserResponseSerializer serializer];
            break;
        case LBResponseSerializerTypePlist:
            return [AFPropertyListResponseSerializer serializer];
            break;
        case LBResponseSerializerTypeCompound:
            return [AFCompoundResponseSerializer serializer];
            break;
        case LBResponseSerializerTypeImage:
            return [AFImageResponseSerializer serializer];
            break;
        case LBResponseSerializerTypeData:
            return [AFHTTPResponseSerializer serializer];
            break;
            
        default:
            return [AFJSONResponseSerializer serializer];
            break;
    }
}
+ (NSString *)cookie {
    
    return @"_ga=GA1.2.732729183.1467731127; install_id=5316804410; login_flag=319157cead347271ef233ba429923e3b; qh[360]=1; sessionid=b391787a2cd16be0f914259f0cf829a4; sid_guard=\"b391787a2cd16be0f914259f0cf829a4|1473218826|2591916|Fri\054 07-Oct-2016 03:25:42 GMT\"; sid_tt=b391787a2cd16be0f914259f0cf829a4; uuid=\"w:9ce15113cb34468795d7aff3edddd670";
    //    return @"_ga=GA1.2.732729183.1467731127; _gat=1; install_id=5316804410; login_flag=6d73da485d989508161f8b6f61690e76; qh[360]=1; sessionid=b31de1961dba84970b3a1b0e3ce5d822; sid_guard=\"b31de1961dba84970b3a1b0e3ce5d822|1472634640|2591918|Fri\054 30-Sep-2016 09:09:18 GMT\"; sid_tt=b31de1961dba84970b3a1b0e3ce5d822; uuid=\"w:9ce15113cb34468795d7aff3edddd670";
    //    return @"_ga=GA1.2.732729183.1467731127; install_id=5316804410; login_flag=6d73da485d989508161f8b6f61690e76; qh[360]=1; sessionid=b31de1961dba84970b3a1b0e3ce5d822; sid_guard=\"b31de1961dba84970b3a1b0e3ce5d822|1472634640|2591918|Fri\054 30-Sep-2016 09:09:18 GMT\"; sid_tt=b31de1961dba84970b3a1b0e3ce5d822; uuid=\"w:9ce15113cb34468795d7aff3edddd670";
}

#pragma mark 取消所有请求
+(void)cancelAllRequests{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    //获取他的操作线程 取消所有执行的任务
    [manager.operationQueue cancelAllOperations];
}
@end
