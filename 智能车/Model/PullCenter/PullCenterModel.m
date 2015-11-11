//
//  PullCenterModel.m
//  智能车
//
//  Created by user on 15/11/6.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "PullCenterModel.h"

@interface PullCenterModel()
@property (strong, nonatomic) NSDate *pullInitTime;

@end

@implementation PullCenterModel

static PullCenterModel *sharedInstance = nil;

static const unsigned int  pullEveryTime = 2;
static const unsigned int  outTimeMax = 120;

#pragma mark -
#pragma mark 请求入列
- (BOOL) addPullEvent:(YCLPullEvent) YCLEventName forView:(UIView *)view{
    if([_pullQueueIdSet containsObject:@(YCLEventName)]) {
        return NO;
    }
//    [[self progressHUD] hide:NO];
    [self registEvent:YCLEventName forView:(UIView *)view];
    switch (YCLEventName) {
        case YCLCarEventUnlock:

            [self.unlockModel sendMessage];
            break;
        case YCLCarEventLock:
            [self.lockModel sendMessage];
            break;
        case YCLCarEventOpenAir:
            [self.openAirModel sendMessage];
            break;
        case YCLCarEventCloseAir:
            [self.closeAirModel sendMessage];
            break;
        default:
            NSLog(@"wrong");
            break;
    }
    
//    NSLog(@"%@%d",[_pullQueueIdSet allObjects],isHas);
    return YES;
}

- (void)registEvent:(YCLPullEvent) YCLEventName forView:(UIView *)view{
    [_pullQueueIdSet addObject:@(YCLEventName)];
    _pullInitTime = [NSDate date];
    _pullEventStartTimeArray[YCLEventName] = [NSDate date];
    _outTime = outTimeMax;
    [self showProgresstoView:view];
}

#pragma mark -
#pragma mark 循环开始
- (void) pullLoopStart{
    if (_isPullStart) {
        NSLog(@"pullLoop 已经运行");
        return;
    }
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                              interval:pullEveryTime
                                                target:self
                                              selector:@selector(runPullLoop)
                                              userInfo:nil
                                               repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop mainRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    _isPullStart = YES;

    NSLog(@"启动 pullLoop,间隔:%f",[timer timeInterval]);

}

#pragma mark 循环请求队列
- (BOOL) afterCompletePullEvent:(YCLPullEvent)YCLEventName{
    if(![_pullQueueIdSet containsObject:@(YCLEventName)]) {
        return NO;
    }
    [_pullQueueIdSet removeObject:@(YCLEventName)];
    return YES;
}

- (void) runPullLoop{
    
    if([_pullQueueIdSet count] == 0){
        NSLog(@"空队列,不请求!");
        return;
    }
    _earilyPullTime = [NSDate date];
    
    for (NSDate *compareTime in _pullEventStartTimeArray) {
        _earilyPullTime = [_earilyPullTime earlierDate:compareTime];
    }
    NSLog(@"%@",[_pullInitTime description]);
#warning 记得改时间,测试用
    [self getReplyMessagesWithPhone:_pullPhone
                          startTime:_pullInitTime
                            endTime:[NSDate distantFuture]];
    
    /** 超时 **/
    _outTime -= pullEveryTime;
    _progressHUD.detailsLabelText = [NSString stringWithFormat:@"超时时间(%lds)",(long)_outTime];
    
    if (_outTime<0) {
        [self.progressHUD setLabelText:@"请求超时"];
        [self.progressHUD setDetailsLabelText:@""];
        [self.progressHUD hide:YES afterDelay:3];
        [_pullQueueIdSet removeAllObjects];
    }
//    NSLog(@"正在处理:%lu 个请求!",(unsigned long)[_pullQueueIdSet count]);
}

-(void)sucessToDo:(NSDictionary *)returnValue{
    NSArray *textArray = returnValue[@"sms_reply"];
    
    for (int i=0; i<[_pullEventStartTimeArray count]; i++) {
        if ([_pullQueueIdSet containsObject:@(i)]) {
#warning 这里是单线
            [self singleLineDealWithPullTextArray:textArray];
//            if (returnEvent) {
//                [self afterCompletePullEvent:returnEvent];
//            }
            //执行异步请求
            
            //成功后
            //            if(){
            //                [self afterCompletePullEvent:i];
            //            }
        }
    }
}

- (YCLPullEvent)singleLineDealWithPullTextArray:(NSArray *)textArray{
    NSString *codeString = [textArray firstObject][@"text"];
    if (!codeString) {
        NSLog(@"本次无数据");
        return 0;
    }
    for (int i=0;i<_pullEventStartTimeArray.count;i++) {
        if ([_pullQueueIdSet containsObject:@(i)]) {
            NSString *returnString=@"";
            NSString *description = @"";
            switch (i) {
                case YCLCarEventUnlock:
                    description = [self.unlockModel description];
                    break;
                case YCLCarEventLock:
                    description = [self.lockModel description];
                    break;
                case YCLCarEventOpenAir:
                    description = [self.openAirModel description];
                    break;
                case YCLCarEventCloseAir:
                    description = [self.closeAirModel description];
                    break;
                default:
                    NSLog(@"wrong");
                    break;
            }
            returnString = [self.unlockModel analysisCodeWithString:codeString];
            if (returnString) {
                self.showReturnLabel.text = [NSString stringWithFormat:@"%@:%@",description,returnString];
                [self.progressHUD setLabelText:@"请求成功!"];
                [self.progressHUD setDetailsLabelText:@""];
                [self.progressHUD hide:YES afterDelay:3];
                [_pullQueueIdSet removeAllObjects];
            }
    
        }
    }
    return NO;
}

//- (YCLPullEvent)dealWithPullTextArray:(NSArray *)textArray{
////    NSLog(@"%@",textArray);
////    static dispatch_once_t onceToken;
////        dispatch_once(&onceToken, ^{
//    for (NSDictionary *detailArray in textArray) {
//        NSLog(@"%@",detailArray[@"text"]);
//        NSString *textString = detailArray[@"text"];
//        
//
//        
//    }
////        });
//    return 0;
//}

- (YCLCarEventUnlockModel *)unlockModel{
    if (!_unlockModel) {
        _unlockModel = [[YCLCarEventUnlockModel alloc] init];
    }
    return  _unlockModel;
}
- (YCLCarEventLockModel *)lockModel{
    if (!_lockModel) {
        _lockModel = [[YCLCarEventLockModel alloc] init];
    }
    return  _lockModel;
}
- (YCLCarEventOpenAirModel *)openAirModel{
    if (!_openAirModel) {
        _openAirModel = [[YCLCarEventOpenAirModel alloc] init];
    }
    return  _openAirModel;
}
- (YCLCarEventCloseAirModel *)closeAirModel{
    if (!_closeAirModel) {
        _closeAirModel = [[YCLCarEventCloseAirModel alloc] init];
    }
    return  _closeAirModel;
}

#pragma mark -
#pragma mark 单例
+ (PullCenterModel *)sharePullCenter{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self hideAlloc] init];
    });
    return sharedInstance;
}

#pragma mark 单例禁用
+ (id)hideAlloc
{
    return [super alloc];
}

+ (instancetype)alloc{
    NSAssert(1 == 0, @"请使用 sharePullCenter 函数!");
    return nil;
}


+ (id)new
{
    return [self alloc];
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            sharedInstance.pullQueueIdSet = [[NSMutableSet alloc] init];
            NSDate *now = [NSDate distantFuture];
            sharedInstance.pullEventStartTimeArray = [NSMutableArray arrayWithObjects:now,now,now,now,now,now,now,now,now,now, nil];
            sharedInstance.pullPhone = @"";
            return sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    NSAssert(1 == 0, @"禁用本函数!");
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [self copyWithZone:zone];
}


#pragma 其他
- (MBProgressHUD *)showProgresstoView:(UIView *)view {
    // 快速显示一个提示信息
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.labelText = @"命令已发送,等待回复";
    // 隐藏时候从父控件中移除
    HUD.removeFromSuperViewOnHide = YES;
    
    // YES代表需要蒙版效果
    HUD.dimBackground = YES;
    _progressHUD = HUD;
    
    
    return HUD;
}


@end
