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


@interface PullCenterModel()

@end

@implementation PullCenterModel
static PullCenterModel *sharedInstance = nil;


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

- (YCLCarEventAddPhoneModel *)addPhoneModel{
    if (!_addPhoneModel) {
        _addPhoneModel = [[YCLCarEventAddPhoneModel alloc] init];
    }
    return _addPhoneModel;
}

- (YCLCarEventDeletePhoneModel *)deletePhoneModel{
    if (!_deletePhoneModel) {
        _deletePhoneModel = [[YCLCarEventDeletePhoneModel alloc] init];
    }
    return _deletePhoneModel;
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
        plainView.frame = CGRectMake(30, 30, kSizeMainScreenWdth-60, kSizeMainScreenHeight-60);

        // Add to the view hierarchy (thus retain).

        [_detailWindow setWindowLevel:UIWindowLevelAlert + 1];//
        
//        [_detailWindow addSubview:plainView];
        _detailWindow.rootViewController = [[UIViewController alloc] init];
        [_detailWindow.rootViewController.view addSubview:plainView];
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
