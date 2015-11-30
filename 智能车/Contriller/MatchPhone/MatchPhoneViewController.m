//
//  MatchPhoneViewController.m
//  YCLCar
//
//  Created by user on 15/11/14.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "MatchPhoneViewController.h"
#import "PullCenterModel.h"
#import "SetPasswordViewController.h"

@interface MatchPhoneViewController()

@end

@implementation MatchPhoneViewController
-(void)viewDidLoad{

}

- (IBAction)touchMatchButton:(UIButton *)sender {
    
    PullCenterModel *pullCenter = [PullCenterModel sharePullCenter];
    pullCenter.localViewController = self;
    if (self.matchMode == YCLMatchPhone) {
        NSString *number = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
        number = number?:kTestPhone;
        if(!number){
            NSLog(@"号码不合法");
            MBProgressHUD *HUD = [pullCenter showProgresstoView:self.view];
            HUD.labelText = @"获取手机号失败";
            HUD.detailsLabelText = @"请检查: 设置->电话->本机号码";
            [HUD show:YES];
            [HUD hide:YES afterDelay:3];
        }else{
//            [[NSUserDefaults standardUserDefaults] setObject:number forKey:kApplicationUserDefaultKeyPullPhone];
            [pullCenter addPullEvent:YCLCarEventMatchPhone forView:self.view];
        }
    }else if(self.matchMode == YCLMatchAuthKey){
        NSLog(@"验证");
        [pullCenter addPullEvent:YCLCarEvenMatchAuthKey forView:self.view userInfo:@[self.matchTestField.text]];
    }
    
}

- (IBAction)isAllowable:(UITextField *)sender {
    if (self.matchMode == YCLMatchPhone) {
        if (sender.text.length!=11) {
            _warningLabel.text = @"绑定设备号应为11位!";
            _warningLabel.textColor = [UIColor redColor];
        }else{
            _warningLabel.textColor = [UIColor greenColor];
            _warningLabel.text = @"设备号合格!";
            [[NSUserDefaults standardUserDefaults] setObject:sender.text forKey:@"pullPhone"];
        }
    }else if(self.matchMode == YCLMatchAuthKey){
        
    }
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_matchTestField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *pullPhone = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationUserDefaultKeyPullPhone];
    NSString *appPassword = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationUserDefaultKeyPassword];
    BOOL hasMatchAuthKey = [[NSUserDefaults standardUserDefaults] boolForKey:kApplicationUserDefaultHasMatchAuthKey];
    
    _matchTestField.delegate = self;
    _matchTestField.keyboardType = UIKeyboardTypeNumberPad;
    //所有都完成
    if (appPassword && pullPhone && hasMatchAuthKey) {
        NSLog(@"登录页面");
        UIStoryboard *storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *loginViewController = [storyBord instantiateViewControllerWithIdentifier:@"LoginNav"];
        [self presentViewController:loginViewController animated:NO completion:nil];
    }else if (pullPhone && hasMatchAuthKey){    //没有设置密码
        NSLog(@"设置密码");
        UIStoryboard *storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        SetPasswordViewController *setPasswordViewController = [storyBord instantiateViewControllerWithIdentifier:@"SetPasswordNav"];
        [self presentViewController:setPasswordViewController animated:NO completion:nil];
    }else if(pullPhone){                        //没有授权
        self.matchMode = YCLMatchAuthKey;
        self.title = @"匹配授权";
        [self.matchButton setTitle:@"授权"forState:UIControlStateNormal];
        self.matchTestField.placeholder = @"请输入你的授权码";
    }else{                                      //收么都没有
        self.matchMode = YCLMatchPhone;
        NSLog(@"匹配设备");
    }
}
@end
