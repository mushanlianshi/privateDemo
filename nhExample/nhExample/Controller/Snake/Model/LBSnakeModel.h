//
//  LBSnakeModel.h
//  nhExample
//
//  Created by liubin on 17/5/2.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
extern  NSInteger const kSnakeWidth;

typedef NS_ENUM(NSInteger, LBSnakeDirectionState){
    LBSnakeDirectionUp = 0,
    LBSnakeDirectionDown = 1,
    LBSnakeDirectionLeft = 2 ,
    LBSnakeDirectionRight =3
};


@class LBSnakeNode;

/**
 * 蛇的模型
 */
@interface LBSnakeModel : NSObject


/**
 * 节点的数组  蛇的身子
 */
@property (nonatomic, strong) NSMutableArray<LBSnakeNode *> *snakeNodesArray;


/**
 * 蛇的方向
 */
@property (nonatomic, assign) LBSnakeDirectionState directionType;

@end
