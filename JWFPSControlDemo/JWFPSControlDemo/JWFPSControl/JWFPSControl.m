//
//  JWFPSControl.m
//  JWFPSControlDemo
//
//  Created by wangjun on 16/7/14.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JWFPSControl.h"

@interface JWFPSControl()
{
    CADisplayLink *displayLink;
    NSTimeInterval lastTime;
    NSUInteger count;
}

@property (nonatomic, copy) void (^fpsHandler)(NSInteger fpsValue);
@property (nonatomic,strong) UILabel *fpsLabel;

@end

@implementation JWFPSControl

- (void)dealloc
{
    // 移除定时器
    [displayLink setPaused:YES];
    [displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.fpsHandler = nil;
}

+ (JWFPSControl *)shareInstance
{
    static JWFPSControl *fpsControl;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fpsControl = [[JWFPSControl alloc] init];
    });
    return fpsControl;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 监听通知，程序进入前台激活、进入后台休眠
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActiveNotification:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActiveNotification:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
        // 开启定时器，刷新当前屏幕FPS
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkRefresh:)];
        [displayLink setPaused:YES];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        // 添加展示FPS的Label
        _fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-50)/2+50, 0, 50, 20)];
        _fpsLabel.font = [UIFont boldSystemFontOfSize:12];
        _fpsLabel.textColor = [UIColor colorWithRed:0.33 green:0.84 blue:0.43 alpha:1.00];
        _fpsLabel.backgroundColor = [UIColor clearColor];
        _fpsLabel.textAlignment = NSTextAlignmentRight;
        _fpsLabel.tag = 100011;
    }
    return self;
}

#pragma mark - Public Method
- (void)open
{
    [self openWithHandler:nil];
}

- (void)openWithHandler:(void (^)(NSInteger))handler
{
    self.fpsHandler = handler;
    
    NSArray *rootControllerSubViews = [[UIApplication sharedApplication].delegate window].rootViewController.view.subviews;
    for (UIView *tempLabel in rootControllerSubViews)
    {
        if ([tempLabel isKindOfClass:[UILabel class]] && tempLabel.tag == 100011)
        {
            return;
        }
    }
    
    [displayLink setPaused:NO];
    [[[UIApplication sharedApplication].delegate window].rootViewController.view addSubview:_fpsLabel];
}

- (void)close
{
    [displayLink setPaused:YES];
    
    NSArray *rootControllerSubViews = [[UIApplication sharedApplication].delegate window].rootViewController.view.subviews;
    for (UIView *tempLabel in rootControllerSubViews)
    {
        if ([tempLabel isKindOfClass:[UILabel class]] && tempLabel.tag == 100011)
        {
            [tempLabel removeFromSuperview];
            return;
        }
    }
}

#pragma mark - NSNotificationCenter
- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [displayLink setPaused:NO];
}

- (void)applicationWillResignActiveNotification:(NSNotification *)notification
{
    [displayLink setPaused:YES];
}

#pragma mark - Refresh
- (void)displayLinkRefresh:(CADisplayLink *)link
{
    if (lastTime == 0)
    {
        lastTime = link.timestamp;
        return;
    }
    
    count ++;
    NSTimeInterval tempTime = link.timestamp - lastTime;
    if (tempTime < 1) return;
    
    lastTime = link.timestamp;
    float tempFPS = count / tempTime;
    count = 0;
    
    _fpsLabel.text = [NSString stringWithFormat:@"%d FPS",(int)round(tempFPS)];
    if (self.fpsHandler)
    {
        self.fpsHandler((int)round(tempFPS));
    }
}

@end
