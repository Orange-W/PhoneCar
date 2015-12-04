//
//  LoginViewController.m
//  YCLCar
//
//  Created by user on 15/11/22.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *appPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *clearAllButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appPasswordTextField.delegate = self;
    [_clearAllButton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)login:(id)loginButton {
   [_appPasswordTextField resignFirstResponder];
   NSString *appPassword = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationUserDefaultKeyPassword];
    NSLog(@"设置密码:%@",appPassword);
    MBProgressHUD *progress =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.removeFromSuperViewOnHide = YES;
    progress.dimBackground = YES;

    if ([_appPasswordTextField.text isEqualToString:appPassword]) {
        progress.labelText = @"登录成功";
        UIStoryboard *storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *loginViewController = [storyBord instantiateViewControllerWithIdentifier:@"MainNav"];
        [self presentViewController:loginViewController animated:NO completion:nil];
    }else{
        progress.labelText = @"密码错误";
        
    }
    [progress hide:YES afterDelay:2];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_appPasswordTextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
