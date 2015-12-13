//
//  SetingViewController.m
//  YCLCar
//
//  Created by user on 15/11/24.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "SetingViewController.h"
#import "PullCenterModel.h"
@interface SetingViewController ()

@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
//    self.title = @"设置";
//    self.navigationController.navigationBar.barTintColor = kColorBarTintColor;
    self.navigationController.navigationBar.backItem.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"初始化");
        [self clear];
    }
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        [[PullCenterModel sharePullCenter] addPullEvent:YCLCarEventAddPhone forView:self.view];
//          return;
//    }
    MBProgressHUD *HUD =  [[PullCenterModel sharePullCenter] showProgresstoView:self.view];
    HUD.labelText = @"功能开发中";
    [HUD hide:YES afterDelay:2];

}


- (void)clear{
    UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:@"重置设备信息" message:@"该操作将会重置并清除您本机上所有信息\n包括设备号与应用密码\n确认该操作吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是的,我确定!", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    if (buttonIndex == 0) {
        
        return;
        
    }else if(buttonIndex == 1){
        
        NSLog(@"确定重置");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kApplicationUserDefaultKeyPassword];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kApplicationUserDefaultKeyPullPhone];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *loginViewController = [storyBord instantiateViewControllerWithIdentifier:@"MatchNav"];
        [self presentViewController:loginViewController animated:NO completion:nil];
        
    }
    
}




@end
