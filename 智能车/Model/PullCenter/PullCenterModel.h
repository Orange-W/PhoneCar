//
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

typedef NS_ENUM(NSInteger,YCLPullEvent){
    YCLCarEventUnlock = 1,  //开锁
    YCLCarEventLock,        //关锁
    YCLCarEventOpenAir,     //开空调
    YCLCarEventCloseAir,    //关空调
    
};


@interface PullCenterModel : RequestBaseModel

@property (strong, nonatomic) UILabel *showReturnLabel;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (assign, atomic) NSInteger outTime;
@property (strong, nonatomic) YCLCarEventUnlockModel *unlockModel;
@property (strong, nonatomic) YCLCarEventLockModel *lockModel;
@property (strong, nonatomic) YCLCarEventOpenAirModel *openAirModel;
@property (strong, nonatomic) YCLCarEventCloseAirModel *closeAirModel;


@property (copy, atomic)NSString *pullPhone;
@property (strong, atomic)NSDate* earilyPullTime;

@property (strong, atomic) NSMutableSet *pullQueueIdSet;
@property (strong, atomic) NSMutableArray *pullEventStartTimeArray;

@property (assign, readonly) BOOL isPullStart;
+ (PullCenterModel *)sharePullCenter;

- (BOOL) addPullEvent:(YCLPullEvent) YCLEventName forView:(UIView *)view;
- (void)pullLoopStart;
@end
