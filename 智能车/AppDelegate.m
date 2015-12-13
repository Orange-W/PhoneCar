//
//  AppDelegate.m
//  智能车
//
//  Created by user on 15/11/2.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "AppDelegate.h"
#import "PullCenterModel.h"
#import "MatchPhoneViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

   
    _pullCenter = [PullCenterModel sharePullCenter];
    NSString *pullPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"pullPhone"];
//#warning 跳过匹配设备,正式请去掉
//    if (!pullPhone) {
//        pullPhone = kTestPhone;
//        [[NSUserDefaults standardUserDefaults] setObject:pullPhone forKey:kApplicationUserDefaultKeyPullPhone];
//    }
    
    _pullCenter.pullPhone = pullPhone;
    [_pullCenter pullLoopStart];
    
    
//    [_pullCenter addPullEvent:YCLCarEventCloseAir forView:nil];
    
//    MatchPhoneViewController *matController = [[MatchPhoneViewController alloc]init];
//    self.window.rootViewController = matController;

//    RequestBaseModel *model = [[RequestBaseModel alloc] init];

//    [model sendMessageWithPhone:@"18883867540" content:@"【益车利】a5551\n(以上为益车利给您的车载设备的命令,命令类型号: {1})"];

//    [model getReplyMessagesWithPhone:@"18883867540" startTime:[NSDate distantPast] endTime:[NSDate distantFuture]];
    // Override point for customization after application launch.
    

    NSLog(@"%@",self.window);
//    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
