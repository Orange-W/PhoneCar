//  PullCenterModel.h
//  智能车
//
//  Created by user on 15/11/6.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "RequestBaseModel.h"
#import "YCLCarEventUnlockModel.h"
#import "YCLCarEventLockModel.h"
#import "YCLCarEventOpenAirModel.h"
#import "YCLCarEventCloseAirModel.h"
#import "YCLMatchPhoneModel.h"
#import "YCLCarEventCarSituationModel.h"
#import "YCLCarEventFindCarOutsideModel.h"
#import "YCLCarEventFindCarSilenceModel.h"

typedef NS_ENUM(NSInteger,YCLPullEvent){
    YCLCarEventNone = 0,
    YCLCarEventUnlock = 1,  //开锁
    YCLCarEventLock,        //关锁
    YCLCarEventOpenAir,     //开空调
    YCLCarEventCloseAir,    //关空调
    YCLCarEventCarSituation, //车辆状况
    YCLCarEventFindCarOutside, //野外寻车
    YCLCarEventFindCarSilence, //静音寻车 ~> 7
    
    YCLCarEventMatchPhone = 11,
    YCLCarEvenMatchAuthKey,
    YCLCarEventAddPhone,
    YCLCarEventDeletePhone,
    YCLCarEventEnd,
    
};


@interface PullCenterModel : RequestBaseModel

@property (strong, nonatomic) UIViewController *localViewController;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (assign, atomic) NSInteger outTime;
@property (strong, nonatomic) YCLCarEventUnlockModel *unlockModel;
@property (strong, nonatomic) YCLCarEventLockModel *lockModel;
@property (strong, nonatomic) YCLCarEventOpenAirModel *openAirModel;
@property (strong, nonatomic) YCLCarEventCloseAirModel *closeAirModel;
@property (strong, nonatomic) YCLMatchPhoneModel *matchModel;
@property (strong, nonatomic) YCLCarEventCarSituationModel *carSituationModel;
@property (strong, nonatomic) YCLCarEventFindCarOutsideModel *carOutsideModel;
@property (strong, nonatomic) YCLCarEventFindCarSilenceModel *carSilenceModel;

@property (copy, atomic)NSString *pullPhone;
@property (strong, atomic)NSDate* earilyPullTime;

@property (strong, atomic) NSMutableSet *pullQueueIdSet;
@property (strong, atomic) NSMutableArray *pullEventStartTimeArray;

@property (assign, readonly) BOOL isPullStart;
+ (PullCenterModel *)sharePullCenter;


- (BOOL) addPullEvent:(YCLPullEvent) YCLEventName forView:(UIView *)view;
- (BOOL) addPullEvent:(YCLPullEvent) YCLEventName
              forView:(UIView *)view
             userInfo:(NSArray *)infoArray;
- (void)pullLoopStart;

- (MBProgressHUD *)showProgresstoView:(UIView *)view ;
@end
