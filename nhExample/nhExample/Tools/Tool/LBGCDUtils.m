//
//  LBGCDUtils.m
//  nhExample
//
//  Created by liubin on 17/4/19.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBGCDUtils.h"

static const NSUInteger kDefaultConcurrentCount = 1; //默认/最小并发数
static const NSUInteger kGlobalConcurrentCount = 4; //默认全局队列线程并发数
static const NSUInteger kMaxConcurrentCount = 32;    //最大并发数



@interface LBGCDUtils ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic,assign) NSUInteger concurrentCount;

@end





@implementation LBGCDUtils
+(void)GCDTimer:(CGFloat)totalTime offsetTime:(CGFloat)offsetTime queue:(dispatch_queue_t)queue block:(dispatch_block_t)block{
    queue = queue ? queue : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, offsetTime * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __block NSTimeInterval offsetT = 0;
    dispatch_source_set_event_handler(timer, ^{
        if (offsetT>=totalTime) {
            dispatch_source_cancel(timer);
        }else{
            if (block) {
                block();
            }
            offsetT +=offsetTime;
        }
    });
    dispatch_resume(timer);
}

+(void)GCDAfterTime:(CGFloat)afterTime queue:(dispatch_queue_t)queue block:(dispatch_block_t)block{
    queue = queue ? queue : dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterTime * NSEC_PER_SEC)), queue, ^{
        if (block) {
            block();
        }
    });
}

+(dispatch_source_t)GCDInterValTimer:(CGFloat)intervalTime queue:(dispatch_queue_t)queue block:(dispatch_block_t)block{
    queue = queue ? queue : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, intervalTime * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (block) {
            block();
        }
    });
    dispatch_resume(timer);
    return timer;
}




#pragma mark - main queue + global queue
+ (LBGCDUtils *)mainThreadQueue {
    static LBGCDUtils *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        queue = [[LBGCDUtils alloc] initWithQueue:dispatch_get_main_queue()];
    });
    
    return queue;
}

+ (LBGCDUtils *)defaultGlobalQueue{
    
    static LBGCDUtils *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[LBGCDUtils alloc]initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                      concurrentCount:kGlobalConcurrentCount];
    });
    return queue;
}

+ (LBGCDUtils *)lowGlobalQueue{
    
    static LBGCDUtils *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[LBGCDUtils alloc]initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
                                      concurrentCount:kGlobalConcurrentCount];
    });
    return queue;
}

+ (LBGCDUtils *)highGlobalQueue{
    
    static LBGCDUtils *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[LBGCDUtils alloc]initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
                                      concurrentCount:kGlobalConcurrentCount];
    });
    return queue;
}

+ (LBGCDUtils *)backGroundGlobalQueue{
    
    static LBGCDUtils *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[LBGCDUtils alloc]initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
                                      concurrentCount:kGlobalConcurrentCount];
    });
    return queue;
}

#pragma mark - lifycycle
- (instancetype)init{
    
    return [self initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
               concurrentCount:kDefaultConcurrentCount];
}

- (instancetype)initWithQueue:(dispatch_queue_t)queue{
    
    return [self initWithQueue:queue
               concurrentCount:kDefaultConcurrentCount];
}

- (instancetype)initWithQueue:(dispatch_queue_t)queue
              concurrentCount:(NSUInteger)concurrentCount{
    
    self = [super init];
    if (self) {
        if (!queue) {
            _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        }else{
            _queue = queue;
        }
        
        _concurrentCount = MIN(concurrentCount, kMaxConcurrentCount);
        if (concurrentCount < kDefaultConcurrentCount) {
            concurrentCount = kDefaultConcurrentCount;
        }
        
        _concurrentCount = concurrentCount; //concurrentCount在[kDefaultConcurrentCount,kMaxConcurrentCount]之间
        if (!_semaphore) {
            _semaphore = dispatch_semaphore_create(concurrentCount);
            
        }
        if (!_serialQueue) {
            _serialQueue = dispatch_queue_create([[NSString stringWithFormat:@"com.buaa.nanhua.serial_%p", self] UTF8String], DISPATCH_QUEUE_SERIAL);
        }
    }
    return self;
}

#pragma mark -- sync && async

//同步
- (void)sync:(dispatch_block_t)block {
    
    if (!block) {
        return;
    }
    
    dispatch_sync(_serialQueue,^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);  //semaphore - 1
        dispatch_sync(self.queue,^{
            if (block) {
                block();
            }
            dispatch_semaphore_signal(self.semaphore);  //semaphore + 1
        });
    });
}

//异步
- (void)async:(dispatch_block_t)block {
    
    if (!block) {
        return;
    }
    
    dispatch_async(_serialQueue,^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);  //semaphore - 1
        dispatch_async(self.queue,^{
            if (block) {
                block();
            }
            dispatch_semaphore_signal(self.semaphore);  //semaphore + 1
        });
    });
}




@end
