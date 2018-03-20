//
//  LBNHRequestManager.h
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
/**
 响应的格式
 */
typedef NS_ENUM(NSInteger, LBResponseSerializerType){
    /**
     *  默认类型 JSON  如果使用这个响应解析器类型,那么请求返回的数据将会是JSON格式
     */
    LBResponseSerializerTypeDefault,
    /**
     如果使用这个响应解析器类型,那么请求返回的数据将会是JSON格式
     */
    LBResponseSerializerTypeJSON,
    /*
     *  XML类型 如果使用这个响应解析器类型,那么请求返回的数据将会是XML格式
     */
    LBResponseSerializerTypeXML,
    /**
     *  Plist类型 如果使用这个响应解析器类型,那么请求返回的数据将会是Plist格式
     */
    LBResponseSerializerTypePlist,
    /*
     *  Compound类型 如果使用这个响应解析器类型,那么请求返回的数据将会是Compound格式
     */
    LBResponseSerializerTypeCompound,
    /**
     *  Image类型 如果使用这个响应解析器类型,那么请求返回的数据将会是Image格式
     */
    LBResponseSerializerTypeImage,
    /**
     *  Data类型 如果使用这个响应解析器类型,那么请求返回的数据将会是二进制格式
     */
    LBResponseSerializerTypeData
};

/**
 负责网络请求的工具类
 */
@interface LBNHRequestManager : NSObject

/**
  Get请求数据
 */
+(NSURLSessionTask *)GET:(NSString *)url
                     parameters:(id)parameters
                     responseSerializerType:(LBResponseSerializerType)type
                     successHandler:(void(^)(id response, NSURLSessionDataTask *task))sucessHandler
                     failureHandler:(void (^)(NSError *error, NSURLSessionDataTask *task))failureHandler;



/**
 post 请求数据
 */
+(NSURLSessionTask *)POST:(NSString *)url
                     parameters:(id)parameters
                     responseSerializerType:(LBResponseSerializerType)type
                     successHandler:(void(^)(id response, NSURLSessionDataTask *task))sucessHandler
                     failureHandler:(void (^)(NSError *error, NSURLSessionDataTask *task))failureHandler;



/**
 post 上传数据
 */
+(NSURLSessionTask *)POST:(NSString *)url
                     parameters:(id)parameters
                     responseSerializerType:(LBResponseSerializerType)type
                     constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
                     successHandler:(void (^)(id response, NSURLSessionDataTask *task))sucessHandler
                     failureHandler:(void(^)(NSError *error, NSURLSessionDataTask *task))failureHandler;

+(void)cancelAllRequests;

@end
