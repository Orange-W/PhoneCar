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
@property (assign ,readonly ,nonatomic) BOOL phoneIsAllow;
@end

@implementation MatchPhoneViewController

- (IBAction)touchMatchButton:(UIButton *)sender {
    
    PullCenterModel *pullCenter = [PullCenterModel sharePullCenter];
    pullCenter.localViewController = self;
    if (self.matchMode == YCLMatchPhone) {
        NSString *number = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
//        number = number?:kTestPhone;
        NSLog(@"number:%@",number);
#warning 测试用,删除
//        number = @"123456";
        if(!number.length){
            NSLog(@"号码不合法");
            MBProgressHUD *HUD = [pullCenter showProgresstoView:self.view];
            HUD.labelText = @"获取手机号失败";
            HUD.detailsLabelText = @"请正确填写手机号";
            [HUD show:YES];
            [HUD hide:YES afterDelay:3];
        }else if (!self.phoneIsAllow){
            [self isAllowable:_matchTextField];
        }else{
            pullCenter.pullPhone = self.matchTextField.text;
            [[NSUserDefaults standardUserDefaults] setObject:number forKey:kApplicationUserDefaultKeyLocalPhone];
            
            NSLog(@"%@",pullCenter.pullPhone);
//            [[NSUserDefaults standardUserDefaults] setObject:number forKey:kApplicationUserDefaultKeyPullPhone];
            [pullCenter addPullEvent:YCLCarEventMatchPhone forView:self.view];
        }
    }else if(self.matchMode == YCLMatchAuthKey){
        NSLog(@"验证");
        [pullCenter addPullEvent:YCLCarEvenMatchAuthKey forView:self.view userInfo:@[self.matchTextField.text]];
    }
    
}

- (IBAction)isAllowable:(UITextField *)sender {
    if (self.matchMode == YCLMatchPhone) {
        if ( self.matchTextField.text.length!=11 || self.nowPhoneTextField.text.length != 11) {
            _warningLabel.text = @"手机和车载设备号应均为11位!";
            _warningLabel.textColor = [UIColor redColor];
        }else{
            _phoneIsAllow = YES;
            _warningLabel.textColor = [UIColor greenColor];
            _warningLabel.text = @"数位合格!";
            [[NSUserDefaults standardUserDefaults] setObject:self.nowPhoneTextField.text forKey:@"SBFormattedPhoneNumber"];
        }
    }else if(self.matchMode == YCLMatchAuthKey){
        
    }
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_matchTextField resignFirstResponder];
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
    
    _matchTextField.delegate = self;
    _matchTextField.keyboardType = UIKeyboardTypeNumberPad;
    //所有都完成
    if (appPassword.length && pullPhone.length && hasMatchAuthKey) {
        NSLog(@"登录页面");
        UIStoryboard *storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *loginViewController = [storyBord instantiateViewControllerWithIdentifier:@"LoginNav"];
        [self presentViewController:loginViewController animated:NO completion:nil];
    }else if (pullPhone.length && hasMatchAuthKey){    //没有设置密码
        NSLog(@"设置密码");
        UIStoryboard *storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        SetPasswordViewController *setPasswordViewController = [storyBord instantiateViewControllerWithIdentifier:@"SetPasswordNav"];
        [self presentViewController:setPasswordViewController animated:NO completion:nil];
    }else if(pullPhone.length){
        NSLog(@"进行授权");
        //没有授权
        [self initViewWithMode:YCLMatchAuthKey];
    }else{
        NSLog(@"匹配手机");//收么都没有
        [self initViewWithMode:YCLMatchPhone];
    }
}

- (void)initViewWithMode:(YCLMatchMode)mode{
    self.matchMode = mode;
    if (mode==YCLMatchAuthKey) {
         NSLog(@"验证授权");
        [self.nowPhoneTextField setHidden:YES];
        self.matchMode = YCLMatchAuthKey;
        self.title = @"授权验证";
        [self.matchButton setTitle:@"授权"forState:UIControlStateNormal];
        self.matchTextField.placeholder = @"请输入你的授权码";
    }else{
        [self.nowPhoneTextField setHidden:NO];
        self.matchMode = YCLMatchPhone;
        _phoneIsAllow = NO;
        NSLog(@"匹配设备");
    }
}
@end
