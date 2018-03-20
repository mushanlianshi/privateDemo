//
//  LBNHBaseRequest.m
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBNHBaseRequest.h"
#import "LBNHRequestManager.h"
#import "MJExtension.h"
#import  <objc/message.h>

static char kTaskIdentifierKey;
/**
 * 创建一个分类是为了给任务添加标识  用来删除用的
 */
@interface NSURLSessionTask (Identifier)

@property (nonatomic, copy) NSString *identifier;

@end

@implementation NSURLSessionTask (Identifier)

- (void)setIdentifier:(NSString *)identifier{
    objc_setAssociatedObject(self, &kTaskIdentifierKey, identifier, OBJC_ASSOCIATION_COPY);
}

- (NSString *)identifier{
    return objc_getAssociatedObject(self, &kTaskIdentifierKey);
}

@end


@interface LBNHBaseRequest ()

/** 任务队列 */
@property (nonatomic, strong) NSMutableArray * taskQueue;


@end

@implementation LBNHBaseRequest

char aa ='A';
void msg(){
    printf("Hello\n");
}

+(instancetype)lb_request{
    
    return  [[self alloc] init];
}
+(instancetype)lb_requestWithUrl:(NSString *)url{
    return [self lb_requestWithUrl:url isPost:NO];
}
+(instancetype)lb_requestWithUrl:(NSString *)url isPost:(BOOL)isPost{
    return [self lb_requestWithUrl:url isPost:isPost delegate:nil];
}
+(instancetype)lb_requestWithUrl:(NSString *)url isPost:(BOOL)isPost delegate:(id<LBNHBaseRequestDelegate>)delegate{
    LBNHBaseRequest *request = [self lb_request];
    request.lb_url = url;
    request.isPost = isPost;
    request.delegate = delegate;
    return request;
}

/** 开始请求，如果设置了代理，不需要block回调*/
-(void)lb_sendRequest{
    [self lb_sendRequestWithHandler:nil];
}

/** 开始请求，没有设置代理，或者设置了代理，需要block回调，block回调优先级高于代理*/
-(void)lb_sendRequestWithHandler:(LBBaseRequestSuccessHandler )requestHander{
    //1.判断请求url
    NSString *urlString = self.lb_url;
    NSDictionary *params = [self params];
    if (self.lb_url.length == 0) return;
        
    //2.判断是post还是get请求
        if (self.isPost) {
            //2.1 且图片数组为空的时候才走这一步   不为空  走下面上传图片的
            if (self.lb_imagesArray.count == 0) {
             NSURLSessionTask *dataTask = [LBNHRequestManager POST:urlString parameters:params responseSerializerType:LBResponseSerializerTypeJSON successHandler:^(id response, NSURLSessionTask *task) {
                    [self response:response handler:requestHander];
                 [self removeTask:task];
                } failureHandler:^(NSError *error ,NSURLSessionTask *task) {
                    [self removeTask:task];
                }];
                [self.taskQueue addObject:dataTask];
            }
        }else{
            NSURLSessionTask *dataTask = [LBNHRequestManager GET:urlString parameters:params responseSerializerType:LBResponseSerializerTypeJSON successHandler:^(id response, NSURLSessionTask *task) {
                [self response:response handler:requestHander];
                [self removeTask:task];
            } failureHandler:^(NSError *error, NSURLSessionTask *task) {
                NSLog(@"LBLog request error %@ ",error);
                [self removeTask:task];
            }];
            [self.taskQueue addObject:dataTask];
        }
    
    //3.是不是上传图片
    if (self.lb_imagesArray.count) {
        NSURLSessionTask *dataTask = [LBNHRequestManager POST:urlString parameters:params responseSerializerType:LBResponseSerializerTypeDefault constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSInteger index = 0;
            for (UIImage *image in self.lb_imagesArray) {
                NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat =@"yyyy-MM-dd HH:mm:ss:SSS";
                NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[dateFormatter stringFromDate:[NSDate date]],@(index)];
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.7) name:@"file" fileName:fileName mimeType:@"image/jpeg"];
                index ++;
            }
        } successHandler:^(id response, NSURLSessionTask *task) {
            [self response:response handler:requestHander];
            [self removeTask:task];
        } failureHandler:^(NSError *error, NSURLSessionTask *task) {
            [self removeTask:task];
        }];
        [self.taskQueue addObject:dataTask];
    }
}

-(void)response:(id)response handler:(LBBaseRequestSuccessHandler)handler{
    //1.重新请求 和服务端定义的字段
    if ([response[@"message"] isEqualToString:@"retry"]) {
        [self lb_sendRequestWithHandler:handler];
        return;
    }
    
    BOOL success = [response[@"message"] isEqualToString:@"success"];
    //2.判断是否有block  block优先级高于delegate
    if (handler) {
        handler(success,response[@"data"],response[@"message"]);
    }else{
        if ([self.delegate respondsToSelector:@selector(requestSuccessResponse:response:message:)]) {
            [self.delegate requestSuccessResponse:success response:response[@"data"] message:response[@"message"]];
        }
    }
    
    //发出通知   让viewController加载框消失
    [[NSNotificationCenter defaultCenter] postNotificationName:KLBNHLoadDataSucessNotification object:nil];
}

- (NSDictionary *)params {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"tag"] = @"joke";
    params[@"iid"] = @"5316804410";
    params[@"os_version"] = @"9.3.4";
    params[@"os_api"] = @"18";
    
    params[@"app_name"] = @"joke_essay";
    params[@"channel"] = @"App Store";
    params[@"device_platform"] = @"iphone";
    params[@"idfa"] = @"832E262C-31D7-488A-8856-69600FAABE36";
    params[@"live_sdk_version"] = @"120";
    
    params[@"vid"] = @"4A4CBB9E-ADC3-426B-B562-9FC8173FDA52";
    params[@"openudid"] = @"cbb1d9e8770b26c39fac806b79bf263a50da6666";
    params[@"device_type"] = @"iPhone 6 Plus";
    params[@"version_code"] = @"5.5.0";
    params[@"ac"] = @"WIFI";
    params[@"screen_width"] = @"1242";
    params[@"device_id"] = @"10752255605";
    params[@"aid"] = @"7";
    params[@"count"] = @"50";
    params[@"max_time"] = [NSString stringWithFormat:@"%.2f", [[NSDate date] timeIntervalSince1970]];
//    NSLog(@"mj_keyValues is %@ ",self.mj_keyValues);
    //添加字典
    [params addEntriesFromDictionary:self.mj_keyValues];
//    NSLog(@"params is %@ ",params);
    if ([params.allKeys containsObject:@"nh_delegate"]) {
        [params removeObjectForKey:@"nh_delegate"];
    }
    if ([params.allKeys containsObject:@"nh_isPost"]) {
        [params removeObjectForKey:@"nh_isPost"];
    }
    if ([params.allKeys containsObject:@"nh_url"]) {
        [params removeObjectForKey:@"nh_url"];
    }
    if (self.lb_imagesArray.count == 0) {
        if ([params.allKeys containsObject:@"nh_imageArray"]) {
            [params removeObjectForKey:@"nh_imageArray"];
        }
    }
    return params;
}



#pragma mark - 成功或则失败移除任务战里的任务的方法
- (void)removeTask:(NSURLSessionTask *)task{
    for (int i = 0 ; i < self.taskQueue.count; i++) {
        NSURLSessionTask *saveTask = self.taskQueue[i];
        if (task == saveTask) {
            /** 因为一般就成功或则失败 只移除一次  所以这样处理 我们break了 所以不会出现移除漏洞情况 */
            [self.taskQueue removeObject:task];
            break;
        }
    }
}


#pragma mark - 取消任务的方法
- (void)cancelRequestWithIdentifier:(NSString *)identifier{
    [self.taskQueue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionTask *task = (NSURLSessionTask *)obj;
        if ([task.identifier isEqualToString:identifier]) {
            [task cancel];
            *stop = YES;
        }
    }];
}
- (void)cancelAllRequest{
    [self.taskQueue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionTask *task = (NSURLSessionTask *)obj;
        [task cancel];
    }];
}


- (NSMutableArray *)taskQueue{
    if (!_taskQueue) {
        _taskQueue = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _taskQueue;
}


#pragma mark 懒加载dateFromatter  因为比较消耗事件  一直创建销毁耗时(上传图片过多)


@end
