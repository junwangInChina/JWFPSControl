//
//  JWFPSControl.h
//  JWFPSControlDemo
//
//  Created by wangjun on 16/7/14.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWFPSControl : NSObject

/**
 *  单利模式
 *
 *  @return 返回当前类的实例
 */
+ (JWFPSControl *)shareInstance;

/**
 *  开启
 */
- (void)open;
/**
 *  开启，带回调Block，实时回调当前fps数据
 *
 *  @param handler 用于回调的block
 */
- (void)openWithHandler:(void(^)(NSInteger fpsValue))handler;
/**
 *  关闭
 */
- (void)close;

@end
