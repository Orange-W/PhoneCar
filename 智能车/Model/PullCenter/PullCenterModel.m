//
//  PullCenterModel.m
//  智能车
//
//  Created by user on 15/11/6.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "PullCenterModel.h"
#import "SetPasswordViewController.h"
#import "MatchPhoneViewController.h"
#import "CoverView.h"

@interface PullCenterModel()
@property (strong, nonatomic) NSDate *pullInitTime;     //当前请求节点
@property (strong, nonatomic) UIWindow *detailWindow;   //详情的 window
@property (strong, nonatomic) CoverView *detailView;    //详情页
@end

@implementation PullCenterModel

static PullCenterModel *sharedInstance = nil;

static const unsigned int  pullEveryTime = 2;           //每pullTime秒请求一次
static const unsigned int  outTimeMax = 120;            //超时时间

#pragma mark -
#pragma mark 请求入列
/**
 *  @author Orange-W, 15-12-04 16:12:34
 *
 *  @brief  向请求队列添加请求事件
 *  @param YCLEventName 请求事件类型
 *  @param view         显示 "加载中..." ProgressView的页面
 *  @param infoArray    UserInfo 额外参数的数组
 *  @return YES/NO
 */
- (BOOL) addPullEvent:(YCLPullEvent) YCLEventName
              forView:(UIView *)view
             userInfo:(NSArray *)infoArray{
    if([_pullQueueIdSet containsObject:@(YCLEventName)]) {
        return NO;
    }
    
    switch (YCLEventName) {
        case YCLCarEventNone:
            return NO;
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
            
        case YCLCarEventCarSituation:
            [self.carSituationModel sendMessage];
            break;
        case YCLCarEventFindCarOutside:
            [self.carOutsideModel sendMessage];
            break;
        case YCLCarEventFindCarSilence:
            [self.carSilenceModel sendMessage];
            break;
        case YCLCarEventMatchPhone:
            [self.matchModel sendMessage];
            break;
        case YCLCarEvenMatchAuthKey:
            [self.authKeyModel sendMessageWithAuthCode:[infoArray firstObject]];
            break;
        default:
            NSLog(@"wrong");
            break;
    }
    
    [self registEvent:YCLEventName forView:(UIView *)view];
    //    NSLog(@"%@%d",[_pullQueueIdSet allObjects],isHas);
    //#warning remove
    //    [self singleLineDealWithPullTextArray:@[]];
    
    return YES;

}

- (BOOL) addPullEvent:(YCLPullEvent) YCLEventName forView:(UIView *)view{
    return [self addPullEvent:YCLEventName forView:view userInfo:nil];
}




- (void)registEvent:(YCLPullEvent) YCLEventName forView:(UIView *)view{
    NSLog(@"添加事件");
    [_pullQueueIdSet addObject:@(YCLEventName)];
    _pullInitTime = [NSDate date];
//    _pullEventStartTimeArray[YCLEventName] = [NSDate date];
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
//        NSLog(@"空队列,不请求!");
        return;
    }
    _earilyPullTime = [NSDate date];
    
//    for (NSDate *compareTime in _pullEventStartTimeArray) {
//        _earilyPullTime = [_earilyPullTime earlierDate:compareTime];
//    }
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
        [self.progressHUD hide:YES afterDelay:3];
        [_pullQueueIdSet removeAllObjects];
    }
//    NSLog(@"正在处理:%lu 个请求!",(unsigned long)[_pullQueueIdSet count]);
}

-(void)sucessToDo:(NSDictionary *)returnValue{
    NSArray *textArray = returnValue[@"sms_reply"];

    for (int i=0; i<YCLCarEventEnd; i++) {
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

- (YCLPullEvent)singleLineDealWithPullTextArray:(NSArray *)textArray {
    NSString *codeString = [textArray firstObject][@"text"];
    NSString  *commandCode= [codeString substringWithRange:NSMakeRange(0,1)];
    YCLCarEventBaseModel *baseModel;
//#warning remove
//    codeString = @"0a0000";
    
    if (!codeString) {
//        NSLog(@"本次无数据");
        return NO;
    }
    NSLog(@"返回:%@",textArray);
    for (int i=0;i<YCLCarEventEnd;i++) {
        if ([_pullQueueIdSet containsObject:@(i)]) {
            NSString *description = @"";
            NSString *returnString=@"";
            switch (i) {
                case YCLCarEventUnlock:
                    baseModel = self.unlockModel;
                    description = [self.unlockModel description];
                    break;
                case YCLCarEventLock:
                    baseModel = self.lockModel;
                    description = [self.lockModel description];
                    break;
                case YCLCarEventOpenAir:
                    baseModel = self.openAirModel;
                    description = [self.openAirModel description];
                    break;
                case YCLCarEventCloseAir:
                    baseModel = self.closeAirModel;
                    description = [self.closeAirModel description];
                    break;
                case YCLCarEventCarSituation:
                    baseModel = self.carSituationModel;
                    description = [self.carSituationModel description];
                    break;
                case YCLCarEventFindCarOutside:
                    baseModel = self.carOutsideModel;
                    description = [self.carOutsideModel description];
                    break;
                case YCLCarEventFindCarSilence:
                    baseModel = self.carSilenceModel;
                    description = [self.carSilenceModel description];
                    break;
                case YCLCarEventMatchPhone:
//                    baseModel = self.carSilenceModel;
                    //把逻辑提出成函数
                    return [self isMatchPhoneWithCodeString:codeString model:self.matchModel];
                    
                case YCLCarEvenMatchAuthKey:
                    return [self isMatchPhoneWithCodeString:codeString model:self.authKeyModel];
                default:
                    NSLog(@"wrong");
                    break;
            }
            NSLog(@"匹配完成:%@",description);
            //这7个功能,防止重复调用
            if(    i==YCLCarEventUnlock
                || i==YCLCarEventLock
                || i==YCLCarEventOpenAir
                || i==YCLCarEventCloseAir
                || i==YCLCarEventFindCarOutside
                || i==YCLCarEventFindCarSilence
                || i==YCLCarEventCarSituation
               ){
                //命令不一致就不执行
                if (![commandCode isEqualToString:baseModel.code]) {
                    
                    NSLog(@"非匹配回复:%@,%@",commandCode,baseModel.code);//
                    return NO;
                }
            }
            
            //使用返回
            returnString = [self.unlockModel analysisCodeWithString:codeString];
            if (returnString) {
                
                
                [self.progressHUD setLabelText:@"请求成功!"];
                [self.progressHUD setDetailsLabelText:@""];
                [self.progressHUD hide:YES afterDelay:1];
                [_pullQueueIdSet removeAllObjects];
                
               
                NSArray *backStringArray = [self showDetailViewWithCodeStringArray:returnString];
                NSLog(@"结果:%@",backStringArray);
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop
                                 animations:^{
                                     self.detailWindow.alpha = 1;
                } completion:nil];
                
                
                return YES;
            }
    
        }
    }
    return NO;
}

#pragma 设置展示返回 view
- (NSArray *) showDetailViewWithCodeStringArray:(NSString *)returnString{
    NSArray *backStringArray = [returnString componentsSeparatedByString:NSLocalizedString(@" ", nil)];
    self.detailView.label1.text = [NSString stringWithFormat:@"命令:%@",backStringArray[0]];
    self.detailView.label2.text = [NSString stringWithFormat:@"是否起效:%@",backStringArray[1]];
    self.detailView.label3.text = [NSString stringWithFormat:@"空调:%@",backStringArray[2]];
    self.detailView.label4.text = [NSString stringWithFormat:@"设备灯:%@",backStringArray[3]];
    self.detailView.label5.text = [NSString stringWithFormat:@"门锁:%@",backStringArray[4]];
    self.detailView.label6.text = [NSString stringWithFormat:@"限位开关:%@",backStringArray[5]];
    return backStringArray;
}


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
- (YCLMatchPhoneModel *)matchModel{
    if (!_matchModel) {
        _matchModel = [[YCLMatchPhoneModel alloc] init];
    }
    return  _matchModel;
}
- (YCLCarEventCarSituationModel *)carSituationModel{
    if (!_carSituationModel) {
        _carSituationModel = [[YCLCarEventCarSituationModel alloc] init];
    }
    return  _carSituationModel;
}
- (YCLCarEventFindCarOutsideModel *)carOutsideModel{
    if (!_carOutsideModel) {
        _carOutsideModel = [[YCLCarEventFindCarOutsideModel alloc] init];
    }
    return  _carOutsideModel;
}
- (YCLCarEventFindCarSilenceModel *)carSilenceModel{
    if (!_carSilenceModel) {
        _carSilenceModel = [[YCLCarEventFindCarSilenceModel alloc] init];
    }
    return  _carSilenceModel;
}

- (YCLCarEvenMatchAuthKeyModel *)authKeyModel{
    if (!_authKeyModel) {
        _authKeyModel = [[YCLCarEvenMatchAuthKeyModel alloc] init];
    }
    return _authKeyModel;
}

- (UIWindow *)detailWindow
{
    if (!_detailWindow) {
        
        _detailWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_detailWindow setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];

        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"CoverView" owner:self options:nil];
        CoverView *plainView = [nibContents lastObject];
        self.detailView = plainView;
        _detailWindow.window.rootViewController = [[UIViewController alloc] init];
        plainView.frame = CGRectMake(30, 100, kSizeMainScreenWdth-60, kSizeMainScreenHeight-200);

        // Add to the view hierarchy (thus retain).
        [self.progressHUD addSubview:plainView];

        [_detailWindow setWindowLevel:UIWindowLevelAlert + 1];//
        
        [_detailWindow addSubview:plainView];
        _detailWindow.rootViewController = [[UIViewController alloc] init];
    }
    return _detailWindow;
}
- (IBAction)closeDetailView:(id)sender {
    [UIView animateWithDuration:1 animations:^{
        self.detailWindow.alpha = 0;
    }];
//    self.detailView.label1.text = @"233";
    NSLog(@"关闭展示窗");
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
//            NSDate *now = [NSDate distantFuture];
          [sharedInstance.detailWindow makeKeyAndVisible];
            sharedInstance.detailWindow.alpha = 0;
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


#pragma 进度框配置
- (MBProgressHUD *)showProgresstoView:(UIView *)view {
    if (!view) {
        return nil;
    }
    
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

#pragma match phone 操作的逻辑函数
- (BOOL) isMatchPhoneWithCodeString:(NSString *)codeString model:(YCLCarEventBaseModel *)model{
    NSString *returnString = [model analysisCodeWithString:codeString];
    [self.progressHUD setLabelText:returnString];
    [self.progressHUD setDetailsLabelText:@""];
    [self.progressHUD hide:YES afterDelay:3];
    [_pullQueueIdSet removeAllObjects];
    
    if ([returnString isEqualToString:@"匹配完成"]) {
        [model pushToNextFromViewController:self.localViewController];
        return YES;
    }
    
    NSLog(@"匹配失败!!");
    return NO;
}

//- (BOOL) isSuccessMatchPhoneWithCodeTring:(NSString *)codeString
//                                 forEventString:(NSString *)eventString{
//    if (![self isMatchPhoneWithCodeString:codeString]) {
//        return NO;
//    }
//    //push 去添加设备
//    
//    if ([eventString isEqualToString:@"addPhone"]) {
//        
//    }else{
//        
//    }
//    
//    return YES;
//}


@end
