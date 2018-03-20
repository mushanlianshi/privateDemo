//
//  LBNHBaseRequest.h
//  nhExample
//
//  Created by liubin on 17/3/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 请求成功与否的回调   block优先级高于代理
 */
typedef void(^LBBaseRequestSuccessHandler)(BOOL success, id response, NSString *message);

@protocol LBNHBaseRequestDelegate <NSObject>

-(void)requestSuccessResponse:(BOOL)success response:(id)response message:(NSString *)message;

@end

/**
 封装了请求的基类  请求继承此类  如果方法不够可以子类自己实现
 */
@interface LBNHBaseRequest : NSObject


/** 请求的连接 */
@property (nonatomic, copy) NSString *lb_url;

/** 代理  */
@property (nonatomic, weak) id<LBNHBaseRequestDelegate> delegate;


/** post请求 */
@property (nonatomic, assign) BOOL isPost;

/** 请求的block回调 */
@property (nonatomic, copy) LBBaseRequestSuccessHandler requestHandler;

/** 图片数组 */
@property (nonatomic, copy) NSArray<UIImage *> *lb_imagesArray;

/** 标识  用来取消用的 */
@property (nonatomic, copy) NSString *identifer;


/** 构造方法 */
+(instancetype)lb_request;
+(instancetype)lb_requestWithUrl:(NSString *)url;
+(instancetype)lb_requestWithUrl:(NSString *)url isPost:(BOOL)isPost;
+(instancetype)lb_requestWithUrl:(NSString *)url isPost:(BOOL)isPost delegate:(id<LBNHBaseRequestDelegate>)delegate;




/** 开始请求，如果设置了代理，不需要block回调*/
-(void)lb_sendRequest;

/** 开始请求，没有设置代理，或者设置了代理，需要block回调，block回调优先级高于代理*/
-(void)lb_sendRequestWithHandler:(LBBaseRequestSuccessHandler )requestHander;

/** 封装了取消的方法  一些在返回中持有VC 导致VC延时释放  在不需要请求的时候可以取消请求  */
- (void)cancelAllRequest;

/** 根据标识取消 */
- (void)cancelRequestWithIdentifier:(NSString *)identifier;

@end
